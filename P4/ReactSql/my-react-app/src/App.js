import React from 'react';
import { BrowserRouter as Router, Route, Routes, Link } from 'react-router-dom';
import StockList from './StockList'; // Adjust the path as necessary
import AddStock from './AddStockForm'; // Adjust the path as necessary
import EditStock from './EditStcokform'; // Adjust the path as necessary

function App() {
  return (
    <Router>
      <div>
        <nav>
          <ul>
            <li>
              <Link to="/">Home</Link>
            </li>
            <li>
              <Link to="/add-stock">Add Stock</Link>
            </li>
          </ul>
        </nav>

        <Routes>
          <Route path="/" element={<StockList />} />
          <Route path="/add-stock" element={<AddStock />} />
          <Route path="/edit-stock/:id" element={<EditStock />} />
        </Routes>
      </div>
    </Router>
  );
}

export default App;
