'use strict';
const dbDonfig= require('./dbConfig');
const sql = require('mssql');


module.exports.DBConnection= async (config)=>{

    let pool=null;

        const closepool= async ()=>{
            try {
                await pool.close();
                pool=null;
            } catch (err){
                pool=null;
                console.log(err);
            }
        }

        const getConnection= async ()=>{
            try{
                if(pool){
                    return pool;
                }

                pool= await sql.connect(config);

                pool.on('error', async err=>{
                    console.log(err);
                    await closepool()
                });

                console.log('Connected to MSSQL database');
                return pool;

            }   catch (err){
                console.log("Error connecting to MSSQL database DBconnect.js");
                console.log(err);
                pool=null;
            }
        }

        return{
            getConnection: await getConnection(config),
            pool: pool
        }
}
