const express = require('express');
const app = express();


const port = 3000;

process.on('uncaughtException', err => {
    console.log('UNCAUGHT EXCEPTION! 💥 Shutting down...');
    console.log(err.name, err.message);
    process.exit(1);
});


app.get('/', (req, res) => {
    res.send('Hello, world!');
});

const server = app.listen(port, () => {
    console.log(`App running on port ${port}...`);
});  