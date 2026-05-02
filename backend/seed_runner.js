const { Client } = require('pg');
const fs = require('fs');
const path = require('path');
require('dotenv').config();

async function seed() {
    const client = new Client({
        connectionString: process.env.DATABASE_URL,
    });

    try {
        await client.connect();
        console.log('Connected to database');

        const sqlPath = path.join(__dirname, 'sql/seed.sql');
        const sql = fs.readFileSync(sqlPath, 'utf8');

        console.log('Executing seed.sql...');
        await client.query(sql);
        console.log('Database seeded successfully!');
    } catch (err) {
        console.error('Error seeding database:', err);
    } finally {
        await client.end();
    }
}

seed();
