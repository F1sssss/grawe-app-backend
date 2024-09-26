const ActiveDirectory = require('activedirectory2');
const logger = require('../logging/winstonSetup');
const SQLQueries = require('../sql/Queries/userQueries');

const config = {
  url: process.env.LDAP_URL,
  baseDN: process.env.LDAP_BASE_DN,
  username: process.env.LDAP_USERNAME, // Service account UPN
  password: process.env.LDAP_PASSWORD, // Service account password
  tlsOptions: {
    rejectUnauthorized: false, // Set to true in production with valid CA
    // ca: [fs.readFileSync('../ca.crt')],
  },
};

const ad = new ActiveDirectory(config);

// Function to authenticate a user
async function authenticateUser(username, password) {
  const userPrincipalName = `${username}@grawe.at`; // Assume UPN format
  return new Promise((resolve, reject) => {
    ad.authenticate(userPrincipalName, password, async (err, auth) => {
      if (err) {
        logger.error(`Error authenticating user from AD ${username}: ${err}`);
        return reject(err);
      }

      if (auth) {
        try {
          const { user } = await SQLQueries.getUserByUsernameOrEmail(username, null, 'signup');
          if (!user) {
            const ad_user = await findADUser(username);
            const { user: new_ad_user, statusCode } = await SQLQueries.createADUser(ad_user);
            return resolve(new_ad_user);
          } else {
            return resolve(user);
          }
        } catch (err) {
          logger.error(`Error processing user from AD ${username}: ${err}`);
          return reject(err);
        }
      } else {
        logger.error(`Authentication failed for user from AD ${username}`);
        return reject(new Error('Authentication failed'));
      }
    });
  });
}

async function findADUser(ad_username) {
  await new Promise((resolve, reject) => {
    ad.authenticate(config.username, config.password, (err, auth) => {
      if (err) {
        logger.error(`Error authenticating service account: ${err}`);
        return reject(err);
      }

      if (!auth) {
        logger.error('Service account authentication failed');
        return reject(new Error('Service account authentication failed'));
      }

      resolve();
    });
  });

  const query = `(&(objectCategory=Person)(sAMAccountName=${ad_username})(memberOf=CN=ME_ReportingApp_Users,OU=Groups,OU=ME,OU=GRAWE,DC=grawe,DC=at))`;
  return await new Promise((resolve, reject) => {
    ad.find(query, (err, results) => {
      if (err) {
        logger.error(`Error searching for user ${ad_username}: ${err}`);
        return reject(err);
      }

      if (!results || results.users.length === 0) {
        logger.error(`No entries found for user ${ad_username}`);
        return reject(new Error('No entries found'));
      } else {
        resolve(results.users[0]);
      }
    });
  });
}
module.exports = { authenticateUser };
