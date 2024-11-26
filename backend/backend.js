const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');
const app = express();
const port = 8090;

const pool = new Pool({
  user: 'postgres',
  host: 'db',
  database: 'database',
  password: 'caio',
  port: 5432,
});

app.use(express.json());
app.use(cors()); // TODO: change cors params

app.post('/login', async (req, res) => {
    const { username, password } = req.body;
     
    if (!username) {
      return res.status(400).json({ error: "Missing username"});
    }

    if (!password) {
      return res.status(400).json({ error: "Missing password"});
    }
  
    try {
      const query = `
        SELECT t.cpf, t.tech_name, t.tech_image
        FROM tech t
        JOIN tech_login tl ON tl.cpf = t.cpf  
        WHERE tl.username = $1 AND tl.userpassword = $2;
      `;

      const values = [username, password];
  
      const { rows } = await pool.query(query, values);
      console.log(rows);
      res.status(201).json(rows);
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: "Error response"});
    }
});

app.post('/getdayoff', async (req , res) => {
  const { cpf } = req.body;

  try {
    const query = `
      select do2.day_off_date 
      from day_off do2 
      where do2.cpf = $1;
    `;
    const values = [cpf];
  
    const { rows } = await pool.query(query, values);
    console.log(rows);
    res.status(201).json(rows);  
  }catch(error) {
    console.error(error);
    res.status(500).json({ error: "Error response"});
  }
    
});

app.post('/setdayoff', async (req , res) => {
  const { day, month, year, cpf } = req.body;
  // yyyy-mm-dd
  const date = '' + year + '-' + month + '-' + day

  try {
    const query = `
      insert into day_off(cpf, day_off_date) values 
      ($1, $2);
    `;
    const values = [cpf, date];
  
    const { rows } = await pool.query(query, values);
    console.log(rows);
    res.status(201).json(rows);  
  }catch(error) {
    console.error(error);
    res.status(500).json({ error: "Error response"});
  }
    
});

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
});