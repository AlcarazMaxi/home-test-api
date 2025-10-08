#!/usr/bin/env node

/**
 * Simple mock server for demo app testing
 * Provides the same API endpoints as the original demo app
 * Compatible with all architectures (Node.js)
 */

const express = require('express');
const cors = require('cors');
const app = express();
const PORT = process.env.PORT || 3100;

// Middleware
app.use(cors());
app.use(express.json());

// Mock inventory data
const inventory = [
  { id: 1, name: "Laptop", price: 999.99, image: "laptop.jpg" },
  { id: 2, name: "Mouse", price: 29.99, image: "mouse.jpg" },
  { id: 3, name: "Keyboard", price: 79.99, image: "keyboard.jpg" },
  { id: 4, name: "Monitor", price: 299.99, image: "monitor.jpg" },
  { id: 5, name: "Headphones", price: 149.99, image: "headphones.jpg" },
  { id: 6, name: "Webcam", price: 89.99, image: "webcam.jpg" },
  { id: 7, name: "Speaker", price: 199.99, image: "speaker.jpg" },
  { id: 8, name: "Tablet", price: 399.99, image: "tablet.jpg" },
  { id: 9, name: "Phone", price: 699.99, image: "phone.jpg" }
];

// Routes
app.get('/', (req, res) => {
  res.json({ 
    message: "Demo App Mock Server", 
    version: "1.0.0",
    endpoints: {
      inventory: "/api/inventory",
      filter: "/api/inventory/filter",
      add: "/api/inventory/add"
    }
  });
});

// Get all inventory items
app.get('/api/inventory', (req, res) => {
  res.json(inventory);
});

// Filter inventory items
app.get('/api/inventory/filter', (req, res) => {
  const { id } = req.query;
  if (id) {
    const filtered = inventory.filter(item => item.id === parseInt(id));
    res.json(filtered);
  } else {
    res.json(inventory);
  }
});

// Add new inventory item
app.post('/api/inventory/add', (req, res) => {
  const { id, name, price, image } = req.body;
  
  // Validate required fields
  if (!id || !name || !price || !image) {
    return res.status(400).json({ 
      message: "Missing required fields: id, name, price, image" 
    });
  }
  
  // Check if item already exists
  const existingItem = inventory.find(item => item.id === parseInt(id));
  if (existingItem) {
    return res.status(409).json({ 
      message: "Item with this ID already exists" 
    });
  }
  
  // Add new item
  const newItem = { id: parseInt(id), name, price: parseFloat(price), image };
  inventory.push(newItem);
  
  res.status(201).json(newItem);
});

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ status: 'healthy', timestamp: new Date().toISOString() });
});

// Start server
app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Mock server running on http://localhost:${PORT}`);
  console.log(`📊 Inventory API available at http://localhost:${PORT}/api/inventory`);
  console.log(`🔍 Filter API available at http://localhost:${PORT}/api/inventory/filter`);
  console.log(`➕ Add API available at http://localhost:${PORT}/api/inventory/add`);
});

// Graceful shutdown
process.on('SIGTERM', () => {
  console.log('🛑 Shutting down mock server...');
  process.exit(0);
});

process.on('SIGINT', () => {
  console.log('🛑 Shutting down mock server...');
  process.exit(0);
});
