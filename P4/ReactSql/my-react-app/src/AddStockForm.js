import React, { useState } from 'react';

function AddStockForm({ onStockAdded }) {
  const [stockId, setStockId] = useState('');
  const [name, setName] = useState('');
  const [description, setDescription] = useState('');
  const [error, setError] = useState('');

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const response = await fetch('http://localhost:3004/api/stockinfo', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ stockId: stockId, name, description }),
      });
  
      if (response.ok) {
        // Clear error message if stock added successfully
        setError('');
        alert('Stock added successfully');
        onStockAdded(); // Refresh stock list
        setStockId('');
        setName('');
        setDescription('');
      } else {
        // If response status is not OK, parse error message from response body
        const errorText = await response.text();
        setError(errorText); // Set the error message
      }
    } catch (error) {
      // If an exception occurs during the fetch request or parsing the error response,
      // set the error message
    //   setError(error.toString());
    }
  };
  

  return (
    <div style={{ backgroundColor: 'lightcyan', minHeight: '100vh', display: 'flex', justifyContent: 'center', alignItems: 'center' }}>
      <div style={{ maxWidth: '600px', width: '100%', margin: '0 auto', padding: '20px', border: '1px solid #ccc', borderRadius: '5px', backgroundColor: '#f9f9f9', opacity: 0.8 }}>
        {error && <div style={{ color: 'red', marginBottom: '10px' }}>{error}</div>}
        <form onSubmit={handleSubmit}>
          <input
            type="number"
            value={stockId}
            onChange={(e) => setStockId(e.target.value)}
            placeholder="Stock ID (numeric)"
            style={{ display: 'block', width: '100%', marginBottom: '10px', padding: '8px', fontSize: '16px', border: '1px solid #ccc', borderRadius: '4px' }}
            required
          />
          <input
            type="text"
            value={name}
            onChange={(e) => setName(e.target.value)}
            placeholder="Stock Name"
            style={{ display: 'block', width: '100%', marginBottom: '10px', padding: '8px', fontSize: '16px', border: '1px solid #ccc', borderRadius: '4px' }}
            required
          />
          <textarea
            value={description}
            onChange={(e) => setDescription(e.target.value)}
            placeholder="Stock Description"
            style={{ display: 'block', width: '100%', marginBottom: '10px', padding: '8px', fontSize: '16px', border: '1px solid #ccc', borderRadius: '4px' }}
            required
          />
          <button
            type="submit"
            style={{ display: 'block', width: '100%', padding: '10px', fontSize: '16px', color: '#fff', backgroundColor: '#007bff', border: 'none', borderRadius: '4px', cursor: 'pointer' }}
          >
            Add Stock
          </button>
        </form>
      </div>
    </div>
  );
}

export default AddStockForm;
