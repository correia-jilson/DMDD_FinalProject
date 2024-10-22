const { poolPromise } = require('./db'); // Ensure this path is correct
const sql = require('mssql');

async function getAllStocks() {
    const pool = await poolPromise;
    const result = await pool.request().query('SELECT * FROM StockInfo');
    return result.recordset;
}

async function addStock(stockId, name, description) {
    const pool = await poolPromise;
    await pool.request()
        .input('StockID', sql.Int, stockId)
        .input('Name', sql.VarChar, name)
        .input('Description', sql.VarChar, description)
        .query('INSERT INTO StockInfo (StockID, Name, Description) VALUES (@StockID, @Name, @Description)');
}

async function updateStock(stockId, name, description) {
    const pool = await poolPromise;
    await pool.request()
        .input('StockID', sql.Int, stockId)
        .input('Name', sql.VarChar, name)
        .input('Description', sql.VarChar, description)
        .query('UPDATE StockInfo SET Name = @Name, Description = @Description WHERE StockID = @StockID');
}

async function deleteStock(stockId) {
    const pool = await poolPromise;
    await pool.request()
        .input('StockID', sql.Int, stockId)
        .query('DELETE FROM StockInfo WHERE StockID = @StockID');
}

module.exports = {
    addStock,
    getAllStocks,
    updateStock,
    deleteStock
};
