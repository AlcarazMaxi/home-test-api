const express = require('express');
const app = express();
const port = 3100;

app.use(express.json());

// Mock API endpoints for production-grade testing
app.get('/api', (req, res) => {
  res.json({ 
    status: 'ok', 
    message: 'Mock API Server',
    version: '1.0.0',
    timestamp: new Date().toISOString()
  });
});

app.get('/api/inventory', (req, res) => {
  const inventory = [
    { 
      id: '1', 
      name: 'Test Item 1', 
      price: '$10.00', 
      image: 'test1.jpg',
      description: 'A test item for API testing',
      category: 'test',
      stock: 100
    },
    { 
      id: '2', 
      name: 'Test Item 2', 
      price: '$15.00', 
      image: 'test2.jpg',
      description: 'Another test item for API testing',
      category: 'test',
      stock: 50
    },
    { 
      id: '3', 
      name: 'Baked Rolls x 8', 
      price: '$8.00', 
      image: 'rolls.jpg',
      description: 'Fresh baked rolls',
      category: 'food',
      stock: 25
    },
    { 
      id: '4', 
      name: 'Super Pepperoni', 
      price: '$10.00', 
      image: 'super-pepperoni.jpg',
      description: 'Delicious pepperoni pizza',
      category: 'food',
      stock: 30
    }
  ];
  
  res.json({
    success: true,
    data: inventory,
    count: inventory.length,
    timestamp: new Date().toISOString()
  });
});

app.post('/api/inventory/add', (req, res) => {
  const { id, name, price, image, description, category, stock } = req.body;
  
  // Validate required fields
  if (!id || !name || !price) {
    return res.status(400).json({
      success: false,
      error: 'Missing required fields: id, name, price',
      timestamp: new Date().toISOString()
    });
  }
  
  // Simulate successful creation
  const newItem = {
    id: id.toString(),
    name,
    price,
    image: image || 'default.jpg',
    description: description || '',
    category: category || 'general',
    stock: stock || 0,
    createdAt: new Date().toISOString()
  };
  
  res.status(201).json({
    success: true,
    message: 'Item created successfully',
    data: newItem,
    timestamp: new Date().toISOString()
  });
});

app.get('/api/inventory/:id', (req, res) => {
  const { id } = req.params;
  
  // Simulate finding an item
  const item = {
    id,
    name: `Item ${id}`,
    price: '$10.00',
    image: 'item.jpg',
    description: `Description for item ${id}`,
    category: 'general',
    stock: 10,
    createdAt: new Date().toISOString()
  };
  
  res.json({
    success: true,
    data: item,
    timestamp: new Date().toISOString()
  });
});

app.put('/api/inventory/:id', (req, res) => {
  const { id } = req.params;
  const updates = req.body;
  
  // Simulate successful update
  const updatedItem = {
    id,
    ...updates,
    updatedAt: new Date().toISOString()
  };
  
  res.json({
    success: true,
    message: 'Item updated successfully',
    data: updatedItem,
    timestamp: new Date().toISOString()
  });
});

app.delete('/api/inventory/:id', (req, res) => {
  const { id } = req.params;
  
  // Simulate successful deletion
  res.json({
    success: true,
    message: `Item ${id} deleted successfully`,
    timestamp: new Date().toISOString()
  });
});

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({
    status: 'healthy',
    uptime: process.uptime(),
    timestamp: new Date().toISOString()
  });
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error('API Error:', err);
  res.status(500).json({
    success: false,
    error: 'Internal server error',
    timestamp: new Date().toISOString()
  });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    success: false,
    error: 'Endpoint not found',
    path: req.path,
    timestamp: new Date().toISOString()
  });
});

app.listen(port, () => {
  console.log(`Mock API server running on port ${port}`);
  console.log(`Health check: http://localhost:${port}/health`);
  console.log(`API endpoint: http://localhost:${port}/api`);
});
