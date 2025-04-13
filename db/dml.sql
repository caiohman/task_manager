-- Status
insert into general_status (id, status_name) values
(1, 'ready'),
(2, 'underway'),
(3, 'working'),
(4, 'paused'),
(5, 'done'),
(6, 'cancelled');


insert into part_status(id, status_name) values
(1, 'requested'),
(2, 'delivered'),
(3, 'installed'),
(4, 'returned');


insert into task_type(id ,task_type ,task_score) values
(1, 'none', 1),
(2, 'precarious', 2),
(3, 'total', 3),
(4, 'alarm', 4);


-- Problem's List
insert into problems (id, problem_description) values
(840, 'Leitor Biométrico Palm'),
(393, 'Módulo de Potência'),
(673, 'Teclado Cliente Falha Chaves Crip. 3DES'),
(390, 'Seg - Dimmer EasyNet Inativo'),
(275, 'Seg - Alarme Zona 1 Violada'),
(229, 'Leitora de Cartões Obstruída'),
(223, 'Impressora com Papel Próximo do Fim'),
(50042, 'Projeto Migração Windows 10 Falha Zero Touch'),
(233, 'Pc Sem Transação de Saque'),
(520, 'Pc Sem Comunicação'),
(730, 'Leitora de Cartões sem Autenticação'),
(530, 'Anti-Skimming Acionado'),
(254, 'Seg-Vistoria Susp Sinistro'),
(860, 'Seg-Vistoria de Segurança'),
(731, 'Teclado Cliente sem Autenticação'),
(70491, 'Assist. Técnica PC Sem Prioridade'),
(70585, 'Assist. Técnica Alarme'),
(276, 'Seg-Alarme Zona 02 Violada'),
(337, 'Seg - Alarme Disparado_RC'),
(522, 'PC com Perda de Conexão'),
(2952, 'Leitora de Cartões Falha Leitura Reincid'),
(353, 'Seg - Dimmer Externo EasyGuard Inativo'),
(676, 'Teclado Cliente Inoperante'),
(979, 'Seg - Dimmer Falha Contingência'),
(745, 'Seg - Dimmer Easyguard Inativo'),
(70501, 'Assist. Técnica PC Com Prioridade'),
(674, 'Teclado Cliente Falha Criptografia 3DES'),
(258, 'PC Com Sist. Operacional Windows Travado');


-- Regions
insert into region (region_name) values
('Jd. Nova Europa'),
('Jd. das Bandeiras'),
('Jardim Campo Belo'),
('Jd. do Lago'),
('Vl. Mimosa'),
('Jd. Planalto'),
('Jd. Ipaussurama'),
('Jd. Bonfim'),
('Jd. Monte Cristo - Pq. Oziel'),
('Jd. Metonopolis'),
('Jd. Londres'),
('Jd. Cristina'),
('Cidade Satélite Iris'),
('Pq. Univ. de Viracopos'),
('Jardim do Bosque'),
('Cj. Ht. Edivaldo Antonio Orsi'),
('Jd. Florence'),
('Jardim Amanda'),
('Pq. Residencial Vl. União'),
('Pq. Viracopos'),
('Vl. Industrial'),
('Jardim Bandeirantes'),
('Parque Industrial'),
('Swift'),
('Jardim do Vovo'),
('Jardim Itatinga'),
('Pq. Paulista'),
('Parque Valenca'),
('Vl. Itapura'),
('Jardim Maracana'),
('Vl. Pompeia'),
('Vl. Aeroporto'),
('Jardim Sao Domingos'),
('Jardim Sao Jose'),
('Jd. Novo Campos Eliseos'),
('Vila Nova'),
('Jd. Fernanda'),
('Dic v'),
('Novo Mundo'),
('Jd. Anchieta'),
('Jd. Aurelia'),
('Jd. Eulina'),
('Cambui'),
('Barao Geraldo'),
('Mansoes Sto Antonio'),
('Jardim Sao Marcos'),
('Chacara Horizonte'),
('Swiss Park'),
('Dic iv (conj hab lech walesa)'),
('Jardim Florence ii'),
('Jd. Campo Belo ii'),
('Jardim Uruguai'),
('Jd. Yeda'),
('Jardim San Diego'),
('Amoreiras'),
('Jd. Planalto de Viracopos'),
('Jardim Sao Cristovao'),
('Jardim Sao Judas Tadeu'),
('Cj. Habit. Parque Itajai ii');

-- Parts
insert into parts_catalog (partnumber, part_name) values
(900001589, 'Teclado Numérico Epp7'),
(900000885, 'Leitora de cartão'),
(300002098, 'Espelho USB'),
(300001717, 'Miolo de chave'),
(900000888, 'Leitora de cartão'),
(900002771, 'Leitor biométrico Palm'),
(900000585, 'HD SATA Diebold'),
(900000723, 'Fonte Para Monitor Original Diebold'),
(300003247, 'kit limpeza leitor biométrico'),
(900001008, 'Monitor 12 pol'),
(300002214, 'Cabo USB 4m Tipo A x Mini USB'),
(900001265, 'Porta Falsa D6135 B24H'),
(300000922, 'Fechadura Cilind. Pressão 421/2 Chav. Gab. 24h'),
(900001377, 'Leitor biométrico Palm Rohs'),
(300001438, 'Sensor Magnético - CJ'),
(900001338, 'Sensor Antiskimming EBX EBX20 N6622'),
(900000960, 'Módulo Dimmer EasyGuard'),
(900001374, 'Leitor Biométrico Finger'),
(900001590, 'Teclado Cliente'),
(900000962, 'Modulo Dimmer EasyNet'),
(900000963, 'Modulo Dimmer Fonte'),
(900000999, 'Monitor lcd 15'),
(900000577, 'Leitor cd dvd'),
(900000582, 'HD NCR'),
(900001010, 'Monitor 15'),
(900001613, 'Transporte Impressora'),
(900000884, 'Leitora de cartões dip'),
(300000341, 'Bateria 3v Litio'),
(300001318, 'Placa Led 12w 220v');

-- Atm's Models
insert into atm_models(model_name) values
('Diebold 6135-149'),
('NCR 6622-8'),
('Diebold 6135-171'),
('NCR 6644-2'),
('NCR 6622-2'),
('NCR P72'),
('Diebold 6535-201'),
('Diebold 6135-116'),
('Diebold 6135-129'),
('Diebold 6135-157'),
('Diebold 6135-115'),
('Diebold 6535-177'),
('NCR 5867'),
('Diebold 6135-064'),
('NCR 6643'),
('Diebold 6135-075'),
('Diebold 6535-192'),
('NCR 6622-10'),
('Diebold 6135-039'),
('Diebold 6135-083'),
('Diebold 6135-056'),
('Diebold 6135-127'),
('Diebold 6134-070'),
('NCR 6644-1'),
('NCR 6622-1'),
('Diebold 6135-020'),
('NCR 6643-1'),
('Diebold 6135-111'),
('Diebold 6135-063'),
('Diebold 6135-076'),
('NCR 6622-7'),
('Diebold 6535-199'),
('Diebold 6135-045'),
('Diebold 6135-025'),
('Diebold 6135-084'),
('NCR 6622-9'),
('NCR 6622-0'),
('Diebold 6135-026'),
('Diebold 6135-108'),
('Diebold 6135-141'),
('Diebold 6535-180');
('Diebold 6535-185');

-- Model's parts
insert into part_model(part, model) values
(900001589, 1),
(900000885, 3),
(900001008, 6),
(900001008, 13),
(900000888, 6);
(900000577, 6);

insert into part_model (part, model)
    select pc.partnumber as part, am.id as model
    from parts_catalog pc
    join atm_models am on 1 = 1
        where pc.partnumber in (900002771, 900000582, 900001338) and am.model_name like 'NCR %';

insert into part_model (part, model)
    select pc.partnumber as part, am.id as model
    from parts_catalog pc
    join atm_models am on 1 = 1
        where pc.partnumber in (300001717, 900000585, 900000723,
         300000922, 900000999)
         and am.model_name like 'Diebold %';

-- available on all models
insert into part_model (part, model)
    select pc.partnumber as part, am.id as model
    from parts_catalog pc
    join atm_models am on 1 = 1
		where pc.partnumber in (300003247, 900001265,
		 900000960, 300001438, 900001374, 900000962,
		 900000963, 300002214, 300000341, 300001318) ;

insert into part_model (part, model)
    select pc.partnumber as part, am.id as model
    from parts_catalog pc
    join atm_models am on 1 = 1
        where pc.partnumber in (900000888, 900000577, 900001010,
         900000719) and am.model_name like 'NCR 6622%';

insert into part_model (part, model)
    select pc.partnumber as part, am.id as model
    from parts_catalog pc
    join atm_models am on 1 = 1
        where pc.partnumber = 900001377 and am.id in (8, 21, 22, 9, 23);

insert into part_model (part, model)
    select pc.partnumber as part, am.id as model
    from parts_catalog pc
    join atm_models am on 1 = 1
        where pc.partnumber = 900001589
         and (am.model_name like 'Diebold 6135-%'
		 or am.model_name like 'Diebold 6235-%'
		 or am.model_name like 'Diebold 6535-%' );

insert into part_model (part, model)
    select pc.partnumber as part, am.id as model
    from parts_catalog pc
    join atm_models am on 1 = 1
        where pc.partnumber = 900001590 and am.model_name like 'NCR 6622%' and am.model_name = 'NCR P72';

-- ATM
insert into atm (id,region,"position",model,atm_name) values
(50392,1,'(22.90714,47.06324)'::point,6,'pague menos nova europa i'),
(95956,4,'(10.90714,37.06324)'::point,7,'ap plaza atmr'),
(31828,6,'(17.90714,32.06324)'::point,3,'sup sete planalto i'),
(18191,7,'(16.90714,31.06324)'::point,6,'shop das bandeiras cinema ii'),
(37899,8,'(-22.9059656,-47.071665)'::point,8,'term metrop cpq iii'),
(61058,9,'(18.90714,38.06324)'::point,9,'sup minieiro oziel'),
(59570,10,'(-22.9506678,-47.1865278)'::point,10,'padaria adelia iv'),
(36518,8,'(-22.9059656,-47.071665)'::point,11,'term metrop cpq ii'),
(28073,3,'(-23.032421,-47.1176729)'::point,6,'sup generoso campo belo iii'),
(53713,12,'(-22.966351,-47.1328868)'::point,14,'pad damassa'),
(45480,14,'(-22.96769,-47.152091)'::point,6,'sup diadia camucim i'),
(65547,15,'(-22.882079,-47.19734)'::point,15,'sup goodbom hortolandia atmr'),
(43937,8,'(-22.90626,-47.071822)'::point,16,'term metrop cpq vii'),
(28575,16,'(-22.84699,-47.14557)'::point,6,'sup conquista sanmartin'),
(60736,18,'(-22.902382,-47.240661)'::point,17,'posto amanda atmr v'),
(60029,19,'(-22.936793,-47.119049)'::point,18,'dia cabo verde ii'),
(35856,20,'(-23.009033,-47.148652)'::point,2,'aeroporto viracopos ii'),
(39410,3,'(-23.03622,-47.12262)'::point,19,'sup compre mais ii'),
(12341,4,NULL,8,'hortifruti do lago'),
(21865,4,NULL,20,'term rod campinas v'),
(34202,7,'(-22.924788,-47.125977)'::point,11,'shop das bandeiras sonda iv'),
(62901,19,'(-22.944147,-47.125977)'::point,24,'sup pinheiros vila união'),
(60368,22,NULL,17,'sup galassi suleste atmr'),
(1289,4,'(-22.905911,-47.072584)'::point,26,'term rod campinas i'),
(65922,23,'(-22.925102,-47.082984)'::point,27,'sup roldao pq industrial campinas-atmr'),
(32843,24,'(-22.926523,-47.040431)'::point,28,'assai lj312 aboliçao ii'),
(96323,13,'(-22.928912,-47.151666)'::point,6,'sup rocha satelite iris'),
(38090,7,'(-22.927582,-47.125013)'::point,18,'pad nutrimassa i'),
(37307,10,'(-22.95043,-47.18651)'::point,8,'pad adelia ii'),
(60730,25,'(-22.898878,-47.098427)'::point,17,'posto chacara do vovo atmr'),
(53638,26,'(-22.983245,-47.105981)'::point,29,'sup sk itatinga i'),
(17532,3,'(-23.032421,-47.117642)'::point,30,'sup generoso campo belo i'),
(55838,27,'(-22.948102,-47.186469)'::point,6,'sup sete lj 6 ii'),
(52886,28,'(-22.944856,-47.185998)'::point,3,'sup sao joao terminal'),
(41293,19,'(-22.936611,-47.118939)'::point,22,'dia cabo verde i'),
(45007,21,'(-22.902025,-47.080281)'::point,37,'ap boulevard'),
(22452,39,'(-22.948835,-47.176856)'::point,2,'sup dom bosco novo mundo'),
(42129,5,'(-22.943351,-47.0902907)'::point,5,'papelaria katocha i'),
(41652,4,'(-22.932118,-47.079121)'::point,6,'sup big campinas shopping i'),
(43014,31,'(-22.930057,-47.093925)'::point,31,'pague menos mirandopolis iii'),
(37083,53,'(-22.954338,-47.116321)'::point,38,'atacadao yeda i'),
(36496,8,'(-22.90626,-47.071822)'::point,11,'term metrop cpq i'),
(50263,54,'(-22.986118,-47.098622)'::point,5,'sup fernandes i'),
(92169,13,'(-22.935793,-47.130543)'::point,6,'sup maria tereza satelite'),
(30405,17,'(-22.939679,-47.163707)'::point,2,'sup brasil florence i'),
(31304,31,'(-22.930057,-47.093925)'::point,39,'pague menos mirandopolis i'),
(93800,42,'(-22.887673,-47.112241)'::point,6,'restaurante quinta do marques cpq'),
(96277,14,'(-22.970161,-47.145192)'::point,35,'padaria amarena baguete'),
(38728,55,'(-22.944658,-47.111174)'::point,6,'assai lj039 amoreira'),
(14611,10,'(-22.950595,-47.186485)'::point,37,'pad adelia i'),
(62688,33,'(-23.04033,-47.10739)'::point,19,'sup lf sao domingos'),
(6696,41,'(-22.908944,-47.095646)'::point,34,'sup enxuto jbd i'),
(90596,3,'(-23.032421,-47.117642)'::point,40,'sup generoso campo belo ii'),
(46801,2,'(-22.9556,-47.0914)'::point,8,'sup ariel ii'),
(50028,34,'(-22.962631,-47.09493)'::point,6,'sup brasil sao jose'),
(46724,2,'(-22.9556,-47.0914)'::point,8,'sup ariel i'),
(46309,5,'(-22.942955,-47.09026)'::point,40,'papelaria katocha ii'),
(55812,28,'(-22.944856,-47.185998)'::point,4,'sup sao joao terminal ii'),
(52812,35,'(-22.937628,-47.106743)'::point,3,'sup diadia cpos eliseos ii'),
(42637,21,'(-22.90769,-47.1065677)'::point,25,'sup vila industrial'),
(92223,56,'(-22.98294,-47.142939)'::point,3,'sup topazio'),
(41826,4,'(-22.1,-47.15)'::point,14,'campinas shopping'),
(50011,11,'(-22.913257,-47.116868)'::point,6,'sup vila nobrega'),
(49203,13,'(-22.93705,-47.15814)'::point,17,'sup atacado distac atmr'),
(33999,29,'(-22.886053,-47.59831)'::point,28,'p. acucar itapura i'),
(34974,30,'(-22.954222,-47.190112)'::point,11,'sup generoso maracana'),
(22710,3,'(-23.03622,-47.12262)'::point,6,'sup compre mais i'),
(32273,32,'(-22.972135,-47.122908)'::point,31,'sup revolucao itamarati i'),
(59238,33,'(-23.03677,-47.10372)'::point,18,'sup joel sao domingos ii'),
(24780,33,'(-23.03693,-47.10367)'::point,25,'sup joel sao domingos i'),
(50128,34,'(-22.962631,-47.09493)'::point,9,'sup brasil sao jose ii'),
(58652,2,'(-22.94948,-47.09257)'::point,32,'muffato max bandeiras atmr'),
(52875,35,'(-22.966441,-47.136188)'::point,3,'shop spazio ouro verde ii'),
(28793,35,'(-22.93652,-47.09814)'::point,12,'ap portal cpos eliseos atmr'),
(60113,36,'(-22.881206,-47.069107)'::point,17,'covabra vila nova atmr ii'),
(11472,4,'(-22.933026,-47.07803)'::point,2,'campinas shopping iv'),
(53772,26,'(-22.983244,-47.105979)'::point,6,'sup sk itatinga ii'),
(59234,13,'(-22.93482,-47.16304)'::point,22,'pague menos satelite iris ii'),
(90595,37,'(-23.040146,-47.128473)'::point,33,'sup generoso fernanda ii'),
(39723,37,'(-23.0403375,-47.1286165)'::point,18,'sup generoso fernanda i'),
(91694,38,'(-22.980721,-47.126042)'::point,6,'sup precos baixos d+ dic'),
(46345,21,'(-22.905911,-47.072584)'::point,3,'term rod campinas x'),
(10797,40,'(-22.928962,-47.097791)'::point,2,'sup shimozono eliseos i'),
(42394,8,'(-22.90626,-47.071822)'::point,14,'term metrop cpq vi'),
(16447,42,'(-22.894486,-47.101003)'::point,30,'sup eulina'),
(6058,43,'(-22.901128,-47.052753)'::point,33,'p. acucar cambui i'),
(31367,44,'(-22.827691,-47.081094)'::point,2,'pague menos barao geraldo'),
(33352,45,'(-22.850305,-47.054167)'::point,28,'sup dalben mansoes ii'),
(21033,46,'(-22.84756,-47.11544)'::point,6,'drog amarais i'),
(6004,22,'(-22.896863,-47.097061)'::point,29,'sup galassi lj 03'),
(40123,47,'(-22.648466,-47.188191)'::point,35,'shop cosmopolis plaza ii'),
(52765,23,'(-22.91949,-47.08629)'::point,6,'sup soberano pq industrial'),
(51986,48,'(-22.960004,-47.066308)'::point,3,'mini extra swisspark'),
(30126,49,'(-22.985079,-47.119838)'::point,5,'sup coto i'),
(93876,50,'(-22.947169,-47.166532)'::point,2,'sup oliveira florence '),
(37901,51,'(-23.033966,-47.120139)'::point,36,'nikey campo belo i'),
(54102,4,'(-22.938237,-47.07945)'::point,8,'sup generoso lago i'),
(92221,52,'(-22.956971,-47.13723)'::point,30,'sup dm uruguai'),
-- more information (60040, 'sup pontel sao cristovao');


-- Tech's informations
insert into tech (cpf, tech_name) values
('000.000.000-00', 'Caio Ohman Balthazar Gaudêncio'),
('000.000.000-03', 'Paulo Roberto Armbrust'),
('000.000.000-04', 'Rafael Ramiro Dias Santos'),
('000.000.000-05', 'Fabricio Gabriel Ramalheiro'),
('000.000.000-06', 'Marcio Cawilla');


insert into region_charge (tech , region) values
('000.000.000-00', 1), ('000.000.000-00', 2);


-- Car's informations
insert into car (model, car_year, license_plate) values
('Gol', 2023, 'DMJ-9A81'),
('HB20', 2024, 'SIT-9F20'),
('Argo', 2024, 'TCU-1E17');


insert into car_user (car, tech, user_date, car_km) values
(1, '000.000.000-00', '2024-10-14', 50000),
(2, '000.000.000-00', '2024-10-24', 39137),
(3, '000.000.000-00', '2024-11-29', 10);


insert into car_service (car, car_service_date, car_service_description, km) values
(1, '2024-10-14', 'Encher o pneu', 50004),
(1, '2024-10-24', 'Devolver', 50004),
(2, '2024-10-30', 'Abastecer', 39545),
(2, '2024-11-05', 'Abastecer', 39906),
(3, '2024-11-29', 'Abastecer', 15);

insert into spendings (value_spent, car_service) values
(133.00, 3);


insert into tech_login (cpf, username, userpassword) values
('000.000.000-00', 'caiohman', 're$peiT0'),
('000.000.000-03','paulo','senha03'),
('000.000.000-04','rafael','senha04'),
('000.000.000-05','fabricio','senha05'),
('000.000.000-06','marcio','senha06');

insert into loose (loose_name, quantity, minimum) values
('Bobina NCR', 10, 5),
('Bobina Diebold', 10, 5);
