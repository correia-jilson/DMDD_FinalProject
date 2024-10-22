import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';

function StockList() {
  const [stocks, setStocks] = useState([]);
  const [selectedStockId, setSelectedStockId] = useState(null);
  const navigate = useNavigate();

  useEffect(() => {
    fetchStocks(); // Initial fetch of stocks
  }, []);

  const fetchStocks = async () => {
    try {
      const response = await fetch('http://localhost:3004/api/stockinfo');
      const data = await response.json();
      setStocks(data);
    } catch (err) {
      console.error("Error fetching stocks:", err);
    }
  };

  const handleDeleteStock = async (stockId) => {
    try {
      await fetch(`http://localhost:3004/api/stockinfo/${stockId}`, { method: 'DELETE' });
      fetchStocks(); // Re-fetch stocks after deletion
    } catch (err) {
      console.error("Error deleting stock:", err);
    }
  };

  const handleEditClick = (stockId) => {
    navigate(`/edit-stock/${stockId}`);
  };

  const toggleDescription = (stockId) => {
    setSelectedStockId(selectedStockId === stockId ? null : stockId);
  };

  const style = {
    container: {
      minHeight: '100vh',
      display: 'flex',
      flexDirection: 'column',
      justifyContent: 'center',
      alignItems: 'center',
      backgroundImage: "url('/stock1.jpg')",
      backgroundSize: 'cover',
      backgroundPosition: 'center',
      top: 0,
      left: 0,
      width: '100%',
      height: '100%',
    },
    content: {
      padding: '20px',
      width: '80%',
      backgroundColor: 'rgba(255, 255, 255, 0.8)', // Semi-transparent background for content
    },
    stockItem: {
      marginBottom: '20px',
      border: '1px solid #ccc',
      borderRadius: '5px',
      padding: '10px',
      backgroundColor: 'white',
    },
    stockName: {
      cursor: 'pointer',
      fontWeight: 'bold',
    },
    stockDescription: {
      marginTop: '10px',
      color: '#555',
    },
    button: {
      marginLeft: '10px',
    },
  };

  return (
    <div style={style.container}>
      <div style={style.content}>
        {stocks.map(stock => (
          <div key={stock.StockID} style={style.stockItem}>
            <div onClick={() => toggleDescription(stock.StockID)} style={style.stockName}>
              {stock.Name}
            </div>
            {selectedStockId === stock.StockID && (
              <div style={style.stockDescription}>{stock.Description}</div>
            )}
            <div>
              <button style={style.button} onClick={() => handleEditClick(stock.StockID)}>Edit</button>
              <button style={style.button} onClick={() => handleDeleteStock(stock.StockID)}>Delete</button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

export default StockList;
