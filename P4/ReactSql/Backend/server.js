const express = require('express');
const db = require('./database'); // Adjust the path as necessary
const cors = require('cors');
const app = express();
const port = 3004;

app.use(cors());
app.use(express.json());

// Fetch all stock entries
app.get('/api/stockinfo', async (req, res) => {
    try {
        const stocks = await db.getAllStocks();
        res.json(stocks);
    } catch (error) {
        console.error('Fetch error:', error);
        res.status(500).send('Error fetching stock information');
    }
});

// Add a new stock entry
app.post('/api/stockinfo', async (req, res) => {
    try {
        const {stockId,name, description } = req.body;
        await db.addStock(stockId, name, description);
        res.status(201).send('Stock added successfully');
    } catch (error) {
        console.error('Add error:', error);
        res.status(500).send('Error adding stock information');
    }
});

app.put('/api/stockinfo/:id', async (req, res) => {
    console.log('Request body:', req.body);
    try {
        const { name, description } = req.body;
        console.log(`Updating stock: ${req.params.id} with name: ${name}, description: ${description}`);
        const result = await db.updateStock(parseInt(req.params.id), name, description);
        console.log('Update result:', result);
        res.send('Stock updated successfully');
    } catch (error) {
        console.error('Update error:', error);
        res.status(500).send('Error updating stock information');
    }
});

// Delete a stock entry
app.delete('/api/stockinfo/:id', async (req, res) => {
    try {
        await db.deleteStock(parseInt(req.params.id));
        res.send('Stock deleted successfully');
    } catch (error) {
        console.error('Delete error:', error);
        res.status(500).send('Error deleting stock information');
    }
});

app.listen(port, () => console.log(`Server running on http://localhost:${port}`));
