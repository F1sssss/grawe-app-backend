// Load all the SQL queries from the queries folder

const fse = require("fs-extra");
const { join } = require("path");

const loadSqlQueries = async () => {
  // determine the file path for the folder
  const queriesDirPath = join(process.cwd(), "src", "sql", "queries");

  // get a list of all the files in the folder
  const files = await fse.readdir(queriesDirPath);

  // only files that have the .sql extension
  const sqlFiles = files.filter((f) => f.endsWith(".sql"));

  // loop over the files and read in their contents
  const queries = {};
  for (let i = 0; i < sqlFiles.length; i++) {
    const query = fse.readFileSync(join(queriesDirPath, sqlFiles[i]), {
      encoding: "UTF-8",
    });
    queries[sqlFiles[i].replace(".sql", "")] = query;
  }
  return queries;
};

module.exports = {
  loadSqlQueries,
};
