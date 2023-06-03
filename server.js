const app=require('./app');
const sql = require('mssql');
const DBconfig = require('./sql/DBconfig');
const {config} = require("dotenv");
const db= require('./sql/DBConnect');
const loadSqlQueries= require('./utils/loadSQL');
const ExecuteQuery= require('./utils/excecuteQuery');


const server = app.listen(DBconfig.port, () => {
    console.log(`App running on port  ${DBconfig.port}...`);
});


//Connect to the database
(async function connectToDatabase() {
    try{
        const conn= await db.DBConnection(DBconfig.sql);
        const query= await loadSqlQueries.loadSqlQueries();

        const result=await ExecuteQuery(query.test);
        console.log(result);
    }catch(err){
        console.log("Error connecting to MSSQL database server.js");
        console.log(err);
    }
})();
app.get('/', (req, res) => {
    res.send('Hello, world!');
});


//Error handling

process.on('unhandledRejection', err => {
    console.log('UNHANDLED REJECTION! 💥 Shutting down...');
    console.log(err.name, err.message);
    server.close(() => {
        process.exit(1);
    });
});

process.on('SIGTERM', () => {
    console.log('👋 SIGTERM RECEIVED. Shutting down gracefully');
    server.close(() => {
        console.log('💥 Process terminated!');
    });
});