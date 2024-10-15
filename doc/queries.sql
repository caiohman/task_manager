-- Some querys

-- find atm model name
select am.model_name 
from atm_models am
join atm a on a.model =  am.id
	where a.id = 50392;

-- chek employee day off
select do2.day_off_date
from day_off do2
join tech t on t.cpf = do2.cpf
	where t.cpf = '';
	

-- chek employee days left to next day off
select do2.day_off_date as day_off, do2.day_off_date - CURRENT_DATE as days_to_day_off
from day_off do2
join tech t on t.cpf = do2.cpf
	where t.cpf = '';

-- List atm's parts
select pc.* 
from parts_catalog pc
join part_model pm on pm.part = pc.partnumber  
join atm a on a.model = pm.model
	where a.id = 50392;

-- List atm's parts
select pc.* 
from parts_catalog pc
join part_model pm on pm.part = pc.partnumber  
join atm a on a.model = pm.model
	where a.id = 50392 and pc.part_name like 'Leitor%';

-- check day off of two employees
with employee_one as 
(
	select do2.day_off_date as day_off, do2.day_off_date - CURRENT_DATE as days_to_day_off
	from day_off do2
	join tech t on t.cpf = do2.cpf
		where t.cpf = ''
),
employee_two as
(
	select do2.day_off_date as day_off, do2.day_off_date - CURRENT_DATE as days_to_day_off
	from day_off do2
	join tech t on t.cpf = do2.cpf
		where t.cpf = ''
)	
select day_off, days_to_day_off from employee_one union all select day_off, days_to_day_off from employee_two order by day_off asc; 

-- Who is taking a day off?
select t.tech_name 
from tech t
join day_off do2 on do2.cpf = t.cpf
	where do2.day_off_date = CURRENT_DATE;