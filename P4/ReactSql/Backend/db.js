const sql = require('mssql');
const config = {
    // Your config
    user: 'sa',
    password: 'Anshika@1499',
    server: 'localhost', // This must be a string. Ensure there's no typo.
    database: 'stockinfo',
    options: {
        encrypt: true, // If you're connecting to Azure SQL, otherwise set to false
        trustServerCertificate: true, // Change to true for local development
    }
};
const poolPromise = new sql.ConnectionPool(config)
    .connect()
    .then(pool => {
        console.log('Connected to MSSQL');
        return pool;
    })
    .catch(err => console.error('Database Connection Failed: ', err));
module.exports = { poolPromise };
