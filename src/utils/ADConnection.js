const ActiveDirectory = require('activedirectory2');
const logger = require('../logging/winstonSetup');
const SQLQueries = require('../sql/Queries/UserQueries');

const config = {
  url: process.env.LDAP_URL,
  baseDN: process.env.LDAP_BASE_DN,
  username: process.env.LDAP_USERNAME, // Your service account UPN
  password: process.env.LDAP_PASSWORD, // Service account password
  tlsOptions: {
    rejectUnauthorized: false, // Set to true in production with valid CA
    // ca: [fs.readFileSync('path/to/ca.crt')]
  },
};

const ad = new ActiveDirectory(config);

// Function to authenticate a user
function authenticateUser(username, password) {
  const userPrincipalName = `${username}@grawe.at`; // Assume UPN format
  return ad.authenticate(userPrincipalName, password, async (err, auth) => {
    if (err) {
      logger.error(`Error authenticating user from AD ${username}: ${err}`);
      return null, err;
    }

    if (auth) {
      const { user } = await SQLQueries.getUserByUsernameOrEmail(username, null, 'signup');
      if (!user) {
        let results,
          err = findADUser(username);
        if (err) {
          return null, err;
        }
        const { user: new_ad_user, statusCode } = await SQLQueries.createADUser(results);
        return new_ad_user, null;
      }
    } else {
      logger.error(`Authentication failed for user from AD ${username}`);
      return null, 'Authentication failed';
    }
  });
}

function findADUser(ad_username) {
  return ad.authenticate(config.username, config.password, (err, auth) => {
    if (err) {
      logger.error(`Error authenticating user from AD ${ad_username}: ${err}`);
      return null, err;
    }

    if (auth) {
      console.log('Authenticated successfully!');
      // Perform a search
      const query = `(&(objectCategory=Person)(sAMAccountName=${ad_username})(memberOf=CN=ME_ReportingApp_Users,OU=Groups,OU=ME,OU=GRAWE,DC=grawe,DC=at))`;
      ad.find(query, (err, results) => {
        if (err) {
          logger.error(`Error searching for user from AD ${ad_username}: ${err}`);
          return null, err;
        }

        if (!results || results.length === 0) {
          logger.error(`No entries found for user from AD ${ad_username}`);
          return null, 'No entries found';
        } else {
          return results.users[0], null;
        }
      });
    } else {
      logger.error(`Authentication failed for user from AD ${ad_username}`);
      return null, 'Authentication failed';
    }
  });
}

module.exports = { authenticateUser };
