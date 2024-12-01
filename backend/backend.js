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
    res.status(500).json({ error: "Error response" });
  }    
});

app.post('/listparts', async (req , res) => {
  try {
    const query = `
      select p.id, p.partnumber as code, pc.part_name as name, ps.status_name as status,
      t.atm as atm, pms.parts_date as date, pms.parts_time as time, t.id as taskid 
      from parts p
      join parts_catalog pc on pc.partnumber = p.partnumber
      join parts_move_status pms on pms.part = p.id
      join part_status ps on ps.id = pms.part_status
      join part_task pt on pt.part = p.id 
      join task t on t.id = pt.task order by p.id, pms.part_status desc;
    `;

    const { rows } = await pool.query(query);
    console.log(rows);
    res.status(201).json(rows);
  }catch(error) {
    console.error(error);
    res.status(500).json({ error: "Error response" });
  }
});

app.get('/listatms', async (req , res) => {
  try {
    const query = `
      select a.id as atm, atm_name as name, r.region_name as neighborhood 
      from atm a
      join region r on r.id = a.region;
    `;

    const { rows } = await pool.query(query);
    console.log(rows);
    res.status(201).json(rows);
  }catch(error) {
    console.error(error);
    res.status(500).json({ error: "Error response" });
  }
});

app.get('/listproblems', async (req , res) => {
  try {
    const query = `
      select id as problem, problem_description as name from problems p; 
    `;

    const { rows } = await pool.query(query);
    console.log(rows);
    res.status(201).json(rows);
  }catch(error) {
    console.error(error);
    res.status(500).json({ error: "Error response" });
  }
});

app.get('/listtasktype', async (req , res) => {
  try {
    const query = `
      select * from task_type; 
    `;

    const { rows } = await pool.query(query);
    console.log(rows);
    res.status(201).json(rows);
  }catch(error) {
    console.error(error);
    res.status(500).json({ error: "Error response" });
  }
});

app.post('/listtasks', async (req , res) => {

  try {
    const query = `
      select t.id, t.problem, t.atm, tt.task_type as type, 
      tss.service_date as date, tss.service_time as time,
      gs.status_name as status 
      from task t
      join task_type tt on tt.id = t.task_type
      join tech_service_status tss on tss.task = t.id
      join general_status gs on gs.id = tss.task_status order by t.id, tss.task_status desc;
    `;
  
    const { rows } = await pool.query(query);
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