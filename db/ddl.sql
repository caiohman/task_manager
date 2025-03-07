create table if not exists region (
id serial,
region_name varchar(255) not null ,
primary key(id)
);

create table if not exists atm_models (
id serial,
model_name varchar(255) not null,
primary key(id)
);

create table if not exists problems (
id integer,
problem_description varchar(255) not null,
primary key(id)
);

create table if not exists general_status (
id integer unique,
status_name varchar(50) not null ,
primary key(id)
);

create table if not exists part_status (
id integer,
status_name varchar(50) not null,
primary key(id)
);

create table if not exists parts_catalog (
partnumber integer,
part_name varchar(255) not null,
part_image bytea,
primary key(partnumber)
);

create table if not exists car (
id serial,
model varchar(255) not null,
car_year varchar(10) not null,
license_plate varchar(15) not null,
car_image bytea,
primary key(id)
);

create table if not exists task_type (
id integer,
task_type varchar(20) not null,
task_score integer,
primary key(id)
);

create table if not exists tech (
cpf varchar(20) not null,
tech_name varchar(255) not null,
tech_image bytea,
primary key(cpf)
);

create table if not exists atm (
id integer,
region  integer,
position point,
model integer,
atm_name varchar(255) not null,
primary key(id),
constraint fk_atm_region foreign key(region) references region(id),
constraint fk_atm_model foreign key(model) references atm_models(id)
);

create table if not exists parts (
id serial,
partnumber integer,
primary key(id),
constraint fk_parts_partnumber foreign key(partnumber) references parts_catalog(partnumber)
);

create table if not exists parts_move_status (
part integer,
part_status integer,
parts_date date,
parts_time time,
unique(part, part_status),
constraint fk_part_move_part foreign key(part) references parts(id),
constraint fk_part_move_status foreign key(part_status) references part_status(id)
);

create table if not exists day_off (
cpf varchar(20) not null,
day_off_date date,
unique(cpf, day_off_date),
constraint fk_day_off_cpf foreign key(cpf) references tech(cpf)
);

create table if not exists task (
id serial ,
problem integer,
atm integer,
task_type integer,
primary key(id),
constraint fk_task_problem foreign key(problem) references problems(id),
constraint fk_task_atm foreign key(atm) references atm(id),
constraint fk_task_type foreign key(task_type) references task_type(id)
);

create table if not exists region_charge (
tech varchar(20) not null,
region integer,
constraint fk_charge_tech foreign key(tech) references tech(cpf),
constraint fk_charge_region foreign key(region) references region(id)
);

create table if not exists part_model (
part integer,
model integer,
unique(part, model),
constraint fk_part_model_part foreign key(part) references parts_catalog(partnumber),
constraint fk_part_model_model foreign key(model) references atm_models(id)
);

create table if not exists tech_service_status (
id serial,
service_date date,
service_time time,
task integer,
task_status integer,
tech varchar(20) not null,
primary key(id),
constraint fk_service_task foreign key(task) references task(id),
constraint fk_service_task_status foreign key(task_status) references general_status(id),
constraint fk_service_tech foreign key(tech) references tech(cpf)
);

create table if not exists car_user (
id serial,
car integer,
tech varchar(20),
user_date date,
car_km integer,
constraint fk_car_user_car foreign key(car) references car(id),
constraint fk_car_user_tech foreign key(tech) references tech(cpf)
);

create table if not exists car_service (
id serial,
car integer,
car_service_date date,
car_service_description varchar(255) not null,
km integer,
primary key(id),
constraint fk_car_service_car foreign key(car) references car(id)
);

create table if not exists part_task (
id serial,
part integer,
task integer,
primary key(id),
constraint fk_part_task_part foreign key(part) references parts(id),
constraint fk_part_task_task foreign key(task) references task(id)
);

create table if not exists spendings (
id serial,
value_spent money,
car_service integer,
primary key(id),
constraint fk_spending_car_service foreign key(car_service) references car_service(id)
);

create table if not exists tech_procedure (
id serial,
tech_procedure varchar(255) not null,
primary key(id)
);

create table tech_login (
cpf varchar(20),
username varchar(50) not null unique,
userpassword varchar(255) not null unique,
constraint fk_login_id foreign key(cpf) references tech(cpf)
);

create table loose (
loose_name varchar(255) not null unique,
quantity integer,
minimum integer,
cpf varchar(20),
constraint fk_loose_cpf foreign key(cpf) references tech(cpf) on delete cascade
);

-- TODO
-- create pause for tech_service - ok
-- create only one open task per problem code in a atm -- function trigger
-- não pode solicitar uma peça em uma tarefa fechada
