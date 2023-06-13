// Load all the SQL sql_queries from the sql_queries folder

const fse = require('fs-extra');
const { join } = require('path');

module.exports = loadSqlQueries = async (QueryFileName) => {
  const queriesDirPath = join(process.cwd(), 'src', 'sql', 'sql_queries');

  if (QueryFileName) {
    return fse.readFileSync(join(queriesDirPath, QueryFileName), {
      encoding: 'UTF-8'
    });
  }

  const files = await fse.readdir(queriesDirPath);

  const sqlFiles = files.filter((f) => f.endsWith('.sql'));

  const queries = {};
  for (let i = 0; i < sqlFiles.length; i++) {
    queries[sqlFiles[i].replace('.sql', '')] = fse.readFileSync(
      join(queriesDirPath, sqlFiles[i]),
      {
        encoding: 'UTF-8'
      }
    );
  }
  return queries;
};
