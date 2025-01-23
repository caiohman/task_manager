const express = require("express");
const { Pool } = require("pg");
const cors = require("cors");
const app = express();
const port = 8090;

const pool = new Pool({
  user: "postgres",
  host: "172.18.0.2",
  database: "database",
  password: "caio",
  port: 5432,
});

app.use(express.json());
app.use(cors()); // TODO: change cors params

app.post("/login", async (req, res) => {
  const { username, password } = req.body;

  if (!username) {
    return res.status(400).json({ error: "Missing username" });
  }

  if (!password) {
    return res.status(400).json({ error: "Missing password" });
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
    res.status(500).json({ error: "Error response" });
  }
});

app.post("/getdayoff", async (req, res) => {
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
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error response" });
  }
});

app.post("/setdayoff", async (req, res) => {
  const { day, month, year, cpf } = req.body;
  // yyyy-mm-dd
  const date = "" + year + "-" + month + "-" + day;

  try {
    const query = `
      insert into day_off(cpf, day_off_date) values
      ($1, $2);
    `;
    const values = [cpf, date];
    await pool.query(query, values);
    res.status(201).json({ message: "Added" });
  } catch (error) {
    console.error(error);
    error.code === "23505"
      ? res.status(400).json({ error: "Day off already exists." })
      : res.status(500).json({ error: "Error response" });
  }
});

app.post("/listparts", async (req, res) => {
  try {
    const query = `
      select p.id, p.partnumber as code, pc.part_name as name, ps.status_name as status,
      t.atm as atm, pms.parts_date as date, pms.parts_time as time, t.id as taskid,
      t.problem, a.atm_name
      from parts p
      join parts_catalog pc on pc.partnumber = p.partnumber
      join parts_move_status pms on pms.part = p.id
      join part_status ps on ps.id = pms.part_status
      join part_task pt on pt.part = p.id
      join task t on t.id = pt.task
	    join atm a on a.id = t.atm
      order by p.id, pms.part_status desc;
    `;

    const { rows } = await pool.query(query);
    console.log(rows);
    res.status(201).json(rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error response" });
  }
});

app.get("/listatms", async (req, res) => {
  try {
    const query = `
      select a.id as atm, atm_name as name, r.region_name as neighborhood
      from atm a
      join region r on r.id = a.region;
    `;

    const { rows } = await pool.query(query);
    console.log(rows);
    res.status(201).json(rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error response" });
  }
});

app.get("/listproblems", async (req, res) => {
  try {
    const query = `
      select id as problem, problem_description as name from problems p;
    `;

    const { rows } = await pool.query(query);
    console.log(rows);
    res.status(201).json(rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error response" });
  }
});

app.get("/listtasktype", async (req, res) => {
  try {
    const query = `
      select * from task_type;
    `;

    const { rows } = await pool.query(query);
    console.log(rows);
    res.status(201).json(rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error response" });
  }
});

app.post("/listtasks", async (req, res) => {
  try {
    const query = `
      select t.id, t.problem, t.atm, tt.task_type as type,
        tss.service_date as date, tss.service_time as time,
        gs.status_name as status, a.atm_name, am.model_name
        from task t
        join task_type tt on tt.id = t.task_type
        join tech_service_status tss on tss.task = t.id
        join general_status gs on gs.id = tss.task_status
        join atm a on a.id = t.atm
        join atm_models am on am.id = a.model
        order by t.id, tss.task_status desc;
    `;

    const { rows } = await pool.query(query);
    console.log(rows);
    res.status(201).json(rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error response" });
  }
});

app.post("/setnewtask", async (req, res) => {
  const { id, atm, problem, type, cpf } = req.body;

  try {
    const insertTask = `
      insert into task (id, atm, problem, task_type) values (
      $1, $2, $3, (select id from task_type tt where tt.task_type = $4));
    `;

    const insertTechServiceStatus = `
      insert into tech_service_status (service_date, service_time, task, task_status, tech) values (
      CURRENT_DATE, CURRENT_TIME, $1 , 1, $2);
    `;

    const valuesTask = [id, atm, problem, type];
    const valuesTechServiceStatus = [id, cpf];

    await pool.query(insertTask, valuesTask);
    await pool.query(insertTechServiceStatus, valuesTechServiceStatus);

    res.status(201).json({ message: "Created" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error response" });
  }
});

app.get("/listgeneralstatus", async (req, res) => {
  try {
    const query = `
      select gs.id, gs.status_name as name from general_status gs;
    `;

    const { rows } = await pool.query(query);
    console.log(rows);
    res.status(201).json(rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error response" });
  }
});

app.post("/settasknewstatus", async (req, res) => {
  const { id, status, cpf } = req.body;

  try {
    const insertTechServiceStatus = `
      insert into tech_service_status (service_date, service_time, task, task_status, tech) values (
      CURRENT_DATE, CURRENT_TIME, $1 , (select id from general_status where status_name = $2), $3);
    `;

    const valuesTechServiceStatus = [id, status, cpf];

    await pool.query(insertTechServiceStatus, valuesTechServiceStatus);

    res.status(201).json({ message: "Created" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error response" });
  }
});

app.get("/listpartstatus", async (req, res) => {
  try {
    const query = `
      select ps.id, ps.status_name as name from part_status ps ;
    `;

    const { rows } = await pool.query(query);
    console.log(rows);
    res.status(201).json(rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error response" });
  }
});

app.post("/setnewstatuspart", async (req, res) => {
  const { id, status } = req.body;

  try {
    const insertPartStatus = `
      insert into parts_move_status (part, part_status, parts_date, parts_time) values
      ($1, $2, CURRENT_DATE, CURRENT_TIME)
    `;

    const valuesPartStatus = [id, status];

    await pool.query(insertPartStatus, valuesPartStatus);

    res.status(201).json({ message: "Created" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error response" });
  }
});

app.get("/listregion", async (req, res) => {
  try {
    const query = `
      select id, region_name as name from region r;
    `;

    const { rows } = await pool.query(query);
    console.log(rows);
    res.status(201).json(rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error response" });
  }
});

app.get("/listmodels", async (req, res) => {
  try {
    const query = `
      select id, model_name as name from atm_models am;
    `;

    const { rows } = await pool.query(query);
    console.log(rows);
    res.status(201).json(rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error response" });
  }
});

app.post("/setnewatm", async (req, res) => {
  const { id, coordinates, region, model, name } = req.body;

  try {
    const insertAtm = `
      insert into atm (id, position, region,  model, atm_name) values
      ($1, $2, $3, $4, $5);
    `;

    const valuesNewAtm = [id, coordinates, region, model, name];

    await pool.query(insertAtm, valuesNewAtm);

    res.status(201).json({ message: "Created" });
  } catch (error) {
    console.error(error);
    error.code === "23505"
      ? res.status(400).json({ error: "Atm already exists." })
      : res.status(500).json({ error: "Error response" });
  }
});

app.post("/listpartsatm", async (req, res) => {
  const { atm } = req.body;

  try {
    const getPartsAtm = `
      select pc.partnumber, pc.part_name as name
      from parts_catalog pc
      join part_model pm on pm.part = pc.partnumber
      join atm_models am on am.id = pm.model
      join atm on atm.model = pm.model
      where atm.id = $1;
    `;

    const valuesPartAtm = [atm];

    const { rows } = await pool.query(getPartsAtm, valuesPartAtm);
    console.log(rows);
    res.status(201).json(rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error response" });
  }
});

app.post("/setpartsatm", async (req, res) => {
  const { partnumber, taskId } = req.body;

  try {
    const createPart = `
      insert into parts (id, partnumber) values
      (( select count(id) from parts ) + 1, $1);
    `;

    const bindTask = `
      insert into part_task (part, task) values
      (( select count(id) from parts ), $1);

    `;

    const addMoveStatus = `
      insert into parts_move_status (part, part_status, parts_date, parts_time) values
      (( select count(id) from parts ), 1, CURRENT_DATE, CURRENT_TIME);
    `;

    const valuesCreatePart = [partnumber];
    const valueBindTask = [taskId];

    await pool.query(createPart, valuesCreatePart);
    await pool.query(bindTask, valueBindTask);
    await pool.query(addMoveStatus);

    res.status(201).json({ message: "Created" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error response" });
  }
});

app.post("/getalldayoff", async (req, res) => {
  const { cpf } = req.body;

  try {
    const query = `
      select t.tech_name as name, do2.day_off_date
      from day_off do2
      join tech t on t.cpf = do2.cpf
      where do2.cpf != $1;
    `;

    const values = [cpf];

    const { rows } = await pool.query(query, values);
    console.log(rows);
    res.status(201).json(rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error response" });
  }
});

app.post("/listcar", async (req, res) => {
  const { cpf } = req.body;

  try {
    const query = `
      select cu.user_date, cu.car_km, c.model,
      c.car_year , c.license_plate, cs.car_service_date,
      cs.car_service_description, cs.km
      from car_user cu
      join car c on c.id = cu.car
      join car_service cs on cs.car = c.id
      where cu.tech = $1;
    `;

    const values = [cpf];

    const { rows } = await pool.query(query, values);
    console.log(rows);
    res.status(201).json(rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error response" });
  }
});

app.post("/getatmlist", async (req, res) => {
  try {
    const query = `
      select id, position, region, model, atm_name from atm;
    `;

    const { rows } = await pool.query(query);
    console.log(rows);
    res.status(201).json(rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error response" });
  }
});

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
});
