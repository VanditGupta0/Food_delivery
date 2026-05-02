const { Client } = require('pg');
require('dotenv').config();

console.log("URL:", process.env.DATABASE_URL);

const client = new Client({
  connectionString: process.env.DATABASE_URL,
});

client.connect()
  .then(() => {
    console.log("Connected to DB successfully!");
    return client.query('SELECT NOW()');
  })
  .then(res => {
    console.log("Time:", res.rows[0]);
    process.exit(0);
  })
  .catch(err => {
    console.error("Connection error", err);
    process.exit(1);
  });
