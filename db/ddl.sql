create table if not exists region (
id integer,
region_name varchar(255) not null ,
primary key(id)
);

create table if not exists atm_models (
id integer,
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
id integer,
partnumber integer,
part_status integer,
primary key(id),
constraint fk_part_status foreign key(part_status) references part_status(id),
constraint fk_part_partnumber foreign key(partnumber) references parts_catalog(partnumber)
);

create table if not exists tech (
cpf varchar(20) not null,
tech_name varchar(255) not null,
tech_image bytea,
primary key(cpf)
);

create table if not exists day_off (
cpf varchar(20) not null,
day_off_date date,
constraint fk_day_off_cpf foreign key(cpf) references tech(cpf) 
);

create table if not exists task (
id bigserial ,
problem integer,
task_status integer,
atm integer,
primary key(id),
constraint fk_task_problem foreign key(problem) references problems(id),
constraint fk_task_status foreign key(task_status) references general_status(id),
constraint fk_task_atm foreign key(atm) references atm(id)
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
constraint fk_part_model_part foreign key(part) references parts_catalog(partnumber),
constraint fk_part_model_model foreign key(model) references atm_models(id)   
);

create table if not exists tech_service (
id bigserial,
service_date date, 
task integer,
parts_request integer,
parts_exchange integer,
tech varchar(20) not null,
primary key(id),
constraint fk_service_problem foreign key(task) references task(id),
constraint fk_service_request foreign key(parts_request) references parts(id),
constraint fk_service_exchange foreign key(parts_exchange) references parts(id),
constraint fk_service_tech foreign key(tech) references tech(cpf)
);

create table if not exists car_user (   
id serial,
car integer,
tech varchar(20), 
date_start date,
date_end date,
km_start integer,
km_end integer,
constraint fk_car_user_car foreign key(car) references car(id),
constraint fk_car_user_tech foreign key(tech) references tech(cpf)  
);

create table if not exists car_service (   
id integer,
car integer,
car_service_date date,
car_service_description varchar(255) not null,
km integer,
constraint fk_car_service_car foreign key(car) references car(id)
);