const ldap = require('ldapjs');
const dotenv = require('dotenv');
const cron = require('node-cron');

const UserQueries = require('../sql/Queries/UserQueries');

dotenv.config({
  path: './config.env',
});

const ldapOptions = {
  url: process.env.LDAP_URL,
  connectTimeout: 30000,
  reconnect: true,
  bindDN: process.env.LDAP_USERNAME,
  bindCredentials: process.env.LDAP_PASSWORD,
};

const client = ldap.createClient(ldapOptions);

const MigrateADUsers = cron.schedule('*/60 * * * *', async () => {
  // await migrateAD();
});

const migrateAD = async () => {
  client.bind(ldapOptions.bindDN, ldapOptions.bindCredentials, (err) => {
    if (err) {
      console.error('LDAP bind failed:', err);
    } else {
      console.log('LDAP bind successful');
    }

    const users = [];
    const groups = [];

    client.search(
      'dc=computingforgeeks,dc=com',
      {
        scope: 'sub', // Search scope
        filter: '(objectClass=posixAccount)', // Search filter
        attributes: ['cn', 'uid', 'sn', 'userPassword'], // Specify attributes to retrieve
      },
      (err, res) => {
        if (err) {
          console.error('LDAP search failed:', err);
        }

        res.on('searchEntry', (entry) => {
          users.push(
            entry.pojo.attributes.reduce(
              (acc, attr) => ({
                ...acc,
                [attr.type === 'uid' ? 'uid' : 'userPass']: attr.values[0],
              }),
              { uid: [], userPass: [] },
            ),
          );
        });

        res.on('error', (err) => {
          console.error('error: ' + err.message);
        });

        res.on('end', (result) => {
          users.forEach(async (user) => {
            await UserQueries.migrateUserFromAD(user.uid, user.userPass);
          });

          console.log('status: ' + result.status);
        });
      },
    );
  });
};

module.exports = MigrateADUsers;
