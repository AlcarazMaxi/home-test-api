const express = require('express');
const app = express();
const port = 3100;

app.use(express.json());
app.use(express.static('public'));

// Mock API endpoints to match original demo app
app.get('/api/inventory', (req, res) => {
  res.json([
    { id: '1', name: 'Test Item 1', price: '$10.00', image: 'test1.jpg' },
    { id: '2', name: 'Test Item 2', price: '$15.00', image: 'test2.jpg' },
    { id: '3', name: 'Baked Rolls x 8', price: '$8.00', image: 'rolls.jpg' },
    { id: '4', name: 'Super Pepperoni', price: '$10.00', image: 'super-pepperoni.jpg' }
  ]);
});

app.get('/api', (req, res) => {
  res.json({ status: 'ok', message: 'Production Demo App Server' });
});

// Mock web pages to match original demo app structure
app.get('/', (req, res) => {
  res.send(`
    <html>
      <head><title>Production Demo App</title></head>
      <body>
        <h1>Production Demo Application</h1>
        <nav>
          <a href="/login">Login</a> | 
          <a href="/grid">Grid</a> | 
          <a href="/search">Search</a> | 
          <a href="/checkout">Checkout</a>
        </nav>
      </body>
    </html>
  `);
});

app.get('/login', (req, res) => {
  res.send(`
    <html lang="en">
      <head><title>Login</title></head>
      <body>
        <main>
          <h1>Login</h1>
          <form id="login-form">
            <label for="username">Username</label>
            <input id="username" type="text" placeholder="Username">
            <label for="password">Password</label>
            <input id="password" type="password" placeholder="Password">
            <button id="signin-button" type="submit">Sign In</button>
          </form>
          <div id="message" style="display: none;"></div>
        </main>
      </body>
    </html>
  `);
});

app.get('/grid', (req, res) => {
  res.send(`
    <html lang="en">
      <head><title>Grid</title></head>
      <body>
        <main>
          <h1>Product Grid</h1>
          <div id="menu">
            <div class="item">
              <h3 data-test-id="item-name">Test Product</h3>
              <span id="item-price">$10.00</span>
              <button data-test-id="add-to-order">Add to Cart</button>
            </div>
          </div>
        </main>
      </body>
    </html>
  `);
});

app.get('/search', (req, res) => {
  res.send(`
    <html lang="en">
      <head><title>Search</title></head>
      <body>
        <main>
          <h1>Search</h1>
          <form>
            <input name="searchWord" type="text" placeholder="Search...">
            <button type="submit">Search</button>
          </form>
          <div id="result">Search results will appear here</div>
        </main>
      </body>
    </html>
  `);
});

app.get('/checkout', (req, res) => {
  res.send(`
    <html lang="en">
      <head><title>Checkout</title></head>
      <body>
        <main>
          <h1>Checkout</h1>
          <form action="/form-validation">
            <input name="firstName" type="text" placeholder="First Name">
            <input name="lastName" type="text" placeholder="Last Name">
            <input name="email" type="email" placeholder="Email">
            <input name="phone" type="tel" placeholder="Phone">
            <button type="submit">Submit Order</button>
          </form>
          <div class="cart-total">
            <span class="price">Total: <b>$25.00</b></span>
          </div>
        </main>
      </body>
    </html>
  `);
});

app.listen(port, () => {
  console.log(`Production demo app running on port ${port}`);
});
