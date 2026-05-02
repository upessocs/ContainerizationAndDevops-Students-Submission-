const express = require('express');
const { Pool } = require('pg');

const app = express();
app.use(express.json());

const pool = new Pool({
  host: process.env.DB_HOST,
  user: process.env.POSTGRES_USER,
  password: process.env.POSTGRES_PASSWORD,
  database: process.env.POSTGRES_DB,
  port: 5432,
});

// Table auto-creation on startup
const initDb = async () => {
  try {
    await pool.query('CREATE TABLE IF NOT EXISTS records (id SERIAL PRIMARY KEY, data TEXT)');
    console.log("Database initialized");
  } catch (err) { console.error("DB Init Error:", err); }
};
initDb();

app.get('/health', (req, res) => res.status(200).json({ status: 'healthy' }));

app.post('/insert', async (req, res) => {
  const { text } = req.body;
  await pool.query('INSERT INTO records (data) VALUES ($1)', [text]);
  res.send({ message: 'Record inserted' });
});

app.get('/fetch', async (req, res) => {
  const { rows } = await pool.query('SELECT * FROM records');
  res.json(rows);
});

app.listen(3000, '0.0.0.0', () => console.log('Server running on port 3000'));
