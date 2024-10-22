import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';

function EditStock({ onUpdate }) {
  const [stock, setStock] = useState(null);
  const [name, setName] = useState('');
  const [description, setDescription] = useState('');
  const [error, setError] = useState('');
  const { id } = useParams();

  useEffect(() => {
    const fetchStock = async () => {
      try {
        const response = await fetch(`http://localhost:3004/api/stockinfo/${id}`);
        if (response.ok) {
          const data = await response.json();
          setStock(data);
          setName(data.name || '');
          setDescription(data.description || '');
        } else {
          throw new Error('Failed to fetch stock data');
        }
      } catch (error) {
        console.error('Error fetching stock:', error);
      }
    };

    fetchStock();
  }, [id]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const response = await fetch(`http://localhost:3004/api/stockinfo/${id}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ name, description }),
      });

      if (response.ok) {
        alert('Stock updated successfully');
        onUpdate(); // Refresh stock list
      } else {
        const error = await response.text();
        setError(`Failed to update stock: ${error}`);
      }
    } catch (error) {
        console.error('Error fetching stock:', error);
    }
  };

  return (
    <div style={{ backgroundColor: 'lightcyan', minHeight: '100vh', padding: '20px' }}>
      <div style={{ backgroundColor: 'white', padding: '20px', borderRadius: '10px' }}>
        {error && <div>{error}</div>}
        <form onSubmit={handleSubmit}>
          <input
            type="text"
            value={name}
            onChange={(e) => setName(e.target.value)}
            placeholder="Stock Name"
            required
            style={{ marginBottom: '10px', padding: '5px', width: '100%', boxSizing: 'border-box' }}
          />
          <input
            type="text"
            value={description}
            onChange={(e) => setDescription(e.target.value)}
            placeholder="Description"
            required
            style={{ marginBottom: '10px', padding: '5px', width: '100%', boxSizing: 'border-box' }}
          />
          <button type="submit" style={{ padding: '8px 16px', backgroundColor: '#4CAF50', color: 'white', border: 'none', borderRadius: '5px', cursor: 'pointer' }}>Update Stock</button>
        </form>
      </div>
    </div>
  );
}

export default EditStock;
