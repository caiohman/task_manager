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