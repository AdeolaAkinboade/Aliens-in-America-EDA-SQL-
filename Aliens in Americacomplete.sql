Select *
from [Aliens of America]..['Aliens of America - aliens$'] ;


--TRYING TO FIND OUT IF THERE ARE DUPLICATES WITHIN THE DATASET

Select id ,email, count(*) as duplicates_found
from [Aliens of America]..['Aliens of America - aliens$']
group by id,email
HAVING COUNT(*) > 1

--CHECKING IF THERE ARE ANY NULL VALUES ACROSS MULTIPLE COLUMNS
Select *
from [Aliens of America]..['Aliens of America - aliens$']
where ( birth_year is null 
OR id is null
OR type is NULL
OR first_name IS NULL
OR last_name IS NULL 
OR email IS NULL  
OR gender is null);

--ALTER THE TABLE SO 'TYPE' column in dataset doesn't trigger syntax errors
sp_rename "['Aliens of America - aliens$'].type","alien_type","column";

Select *
from [Aliens of America]..['Aliens of America - aliens$'] ;



--Exploratory Data Analysis

--How many different kinds of aliens do we have in total
Select alien_type,count(alien_type) as unique_aliencount_totals
  FROM [Aliens of America]..['Aliens of America - aliens$']
  group by alien_type;

--max birth year  in data set
select top 1 birth_year as maxbirthyear
from [Aliens of America]..['Aliens of America - aliens$']
where birth_year =( select max(birth_year) from [Aliens of America]..['Aliens of America - aliens$'])
group by birth_year
order by count(*) desc

--Total Alien Type
select count(alien_type) as total_aliens
from [Aliens of America]..['Aliens of America - aliens$']

--min birth year in dataset
select top 1 birth_year as minbirthyear
from [Aliens of America]..['Aliens of America - aliens$']
where birth_year =( select min(birth_year) from [Aliens of America]..['Aliens of America - aliens$'])
group by birth_year
order by count(*) 


--Average birth year

select  avg(birth_year) as avgbirth_yr
from [Aliens of America]..['Aliens of America - aliens$']

--current age of aliens

select (2022-birth_year) as age
from [Aliens of America]..['Aliens of America - aliens$']

--or with this query :

select birth_year ,GETDATE() as nowdate, (year(getdate()) - (birth_year)) as age
from [Aliens of America]..['Aliens of America - aliens$']


--Adding colun 'alien_age' into the dataset
ALTER TABLE[Aliens of America]..['Aliens of America - aliens$']
add alien_age int

update [Aliens of America]..['Aliens of America - aliens$']
set alien_age =(year(getdate()) - (birth_year));


--The most common genders in dataset
Select top 3 gender, count(gender) as totals
from [Aliens of America]..['Aliens of America - aliens$']
group by gender
order by count(*) desc


--Types of aliens
select alien_type, count(alien_type) as totals
from [Aliens of America]..['Aliens of America - aliens$']
group by alien_type
order by count(*) desc

--Top occupations
select *
from [Aliens of America]..['Aliens of America - location$'];

select top 3  occupation,count(occupation) as totals
from [Aliens of America]..['Aliens of America - location$']
group by occupation
order by count(*) desc



--Aggressiveness and Non-aggressiveness per Population
select aggressive,
case when count(aggressive)>0 then count(aggressive) else null
end 
as aggressive
from [Aliens of America]..['Aliens of America - details$']
group by aggressive


--Most Aggressive State
Select top 1 aggressive,state,
case when count(aggressive)>0 then count(aggressive)/count(distinct state) else null
end
as aggressiveness
from [Aliens of America]..['Aliens of America - details$'] de
left join [Aliens of America]..['Aliens of America - location$'] ea
on de.detail_id = ea.loc_id
group by aggressive,state
order by count(*) desc


--Least Aggressive State
Select top 1 aggressive,state,
case when count(aggressive)>0 then count(aggressive)/count(distinct state) else null
end
as aggressiveness
from [Aliens of America]..['Aliens of America - details$'] de
left join [Aliens of America]..['Aliens of America - location$'] ea
on de.detail_id = ea.loc_id
group by aggressive,state
order by count(*) 


--Obtaining the Aggressiveness per state

Select state,
case when count(aggressive)>0 then count(aggressive)/count(distinct state) else null
end
as aggressiveness
from [Aliens of America]..['Aliens of America - details$'] de
left join [Aliens of America]..['Aliens of America - location$'] ea
on de.detail_id = ea.loc_id
group by state
order by count(*) desc


--Most Common foods eaten by aliens
select *
from [Aliens of America]..['Aliens of America - details$'];

select top 5 favorite_food, count(favorite_food) as totals
from [Aliens of America]..['Aliens of America - details$']
group by favorite_food
order by count(*) desc


--Common feeding frequency amongst the aliens
select feeding_frequency, count(feeding_frequency) as totals
from [Aliens of America]..['Aliens of America - details$']
group by feeding_frequency
order by count(*) desc

--Feeding Frequency per state
Select feeding_frequency,state,(count (feeding_frequency)/count(distinct state)) as frequ_per_state
from [Aliens of America]..['Aliens of America - details$'] de
left join [Aliens of America]..['Aliens of America - location$'] ea
on de.detail_id = ea.loc_id
group by state,feeding_frequency
order by count(*) desc

--Querying the States that have the mode of the following feeding frequencies
Select top 10 state, feeding_frequency,(count (feeding_frequency)/count(distinct state)) as frequ_per_state
from [Aliens of America]..['Aliens of America - details$'] de
left join [Aliens of America]..['Aliens of America - location$'] ea
on de.detail_id = ea.loc_id
where feeding_frequency like '%Yearly%'
or feeding_frequency like '%Once%'
or feeding_frequency like '%Monthly%'
or feeding_frequency like '%Never%'
group by state,feeding_frequency
order by count(*) desc
