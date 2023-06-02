const app=require('./app');
const sql = require('mssql');
const DBconfig = require('./sql/DBconfig');



const server = app.listen(DBconfig.port, () => {
    console.log(`App running on port  ${DBconfig.port}...`);
});

async function connectToDatabase() {
    try {
        await sql.connect(DBconfig.sql);
        console.log('Connected to MSSQL database');
    } catch (error) {
        console.error('Failed to connect to MSSQL dtabase:', error);
    }
}


connectToDatabase()

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