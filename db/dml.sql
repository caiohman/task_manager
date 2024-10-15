-- Status
insert into general_status (id, status_name) values (1, 'ready'),
(2, 'working'),
(3, 'done');

insert into part_status(id, status_name) values (1, 'available'), 
(2, 'delivered'), 
(3, 'requested');

-- Problem's List
insert into problems (id, problem_description) values (840, 'Leitor Biométrico Palm'), 
(393, 'Módulo de Potência'),
(673, 'Teclado Cliente Falha Chaves Crip. 3DES'),
(390, 'Seg - Dimmer EasyNet Inativo'),
(275, 'Seg - Alarme Zona 1 Violada'); 

-- Regions
insert into region (id, region_name) values (1, 'Jd. Nova Europa'), 
(2, 'Jd. das Bandeiras'), 
(3, 'Campo Belo'),
(4, 'Jd. do Lago'),
(5, 'Vl. Mimosa'),
(6, 'Jd. Planalto');

-- Parts
insert into parts_catalog (partnumber, part_name) values (900001589, 'Teclado Numérico'),
(900000885, 'Leitora de cartão'), 
(300002098, 'Espelho USB'), 
(300001717, 'Miolo de chave'), 
(900000888, 'Leitora de cartão'),
(900002771, 'Leitor biométrico Palm');

insert into parts (id, partnumber, part_status) values (1, 900001589, 1),
(2, 900000885, 1), 
(3, 300002098, 1),
(4, 300001717, 1),
(5, 900000888, 1),
(6, 900002771, 1);

-- Atm's Models
insert into atm_models(id, model_name) values (1, 'Diebold 6135-149'), 
(2, 'NCR 6622-8'), 
(3, 'Diebold 6135-171'), 
(4, 'NCR 6644-2'),
(5, 'NCR 6622-2'), 
(6, 'NCR P72'),
(7, 'Diebold 6535-201');

-- Model's parts
insert into part_model(part, model) values (900001589, 1), 
(900000885, 3),
(900000888, 5); 

insert into part_model (part, model) 
    select pc.partnumber as part, am.id as model 
    from parts_catalog pc 
    join atm_models am on 1 = 1 
        where pc.partnumber = 900002771 and am.model_name like 'NCR %';  

insert into part_model (part, model) 
    select pc.partnumber as part, am.id as model 
    from parts_catalog pc 
    join atm_models am on 1 = 1 
        where pc.partnumber = 300001717 and am.model_name like 'Diebold %'; 

-- ATM
insert into atm (id, region, position, model, atm_name) values (50392, 1, '(22.90714, 47.063240)', 6, 'pague menos nova europa i'),
(95956, 4, '(10.90714, 37.063240)', 7, 'ap plaza atmr'),
(42129, 5, '(15.90714, 30.063240)', 5, 'papelaria katocha i'),
(31828, 6, '(17.90714, 32.063240)', 3, 'sup sete planalto i');

-- Task
insert into task (problem, task_status, atm) values (840, 1, 50392);

insert into tech_service (service_date, task, tech) values ('2024-10-12', 1, '000.000.000-00');

