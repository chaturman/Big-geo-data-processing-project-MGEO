*****************DATA CLEANING AND PREPARATION: final variables (observation, block, temperature, precipitation, block_landuse, block_road_length)*******************

### Selecting only six months and calculating the observation in each day of those six months 
from observation table and adding geometry to each block from block table

create table s2241587.nlobs as
with a as (
select block, obsdate, count(obsdate) as observation from public.observation where obsdate >= '2017-01-01' and obsdate <= '2017-06-30'
group by obsdate, block)

select a.block, a.obsdate, a.observation, b.geom from a, public.block as b
where a.block = b.block


### Creating a new road table that contains total road length per block

create table s2241587.raods as
select block, sum(roadlength) from public.block_road_access group by block order by block


### Creating a landuse table that have most prominent landuse type for each block (based on landuse size)

create table s2241587.landuse as
with a as (
	select block, max (areasum) as areasum from public.block_landuse group by block
order by block)

select a.block, a.areasum, b.category from a, public.block_landuse as b
where a.block = b.block and a.areasum = b.areasum


### Creating a table which contain block, observation in each date, temperature on that date, precipitaion on that date, landuse of that block, total road lenght of that block and geometry of that block

create table s2241587.nlallobs1 as
with a as (
select date(dtime::TEXT) as t_date, temper, block from public.temperature order by t_date), 


### Converting date into proper datetime format and selecting other necessary column

b as (
select date(dtime::TEXT) as p_date, precip, block from public.precipitation order by p_date) 


### converting date into proper datetime format and selecting other necessary column

select c.block, c.obsdate, c.observation, a.temper, b.precip, d.category, e.roadlength, c.geom from a,b, s2241587.nlobs as c, s2241587.landuse as d, s2241587.roads as e
where a.block = c.block and c.block= b.block and a.t_date = c.obsdate and c.obsdate=b.p_date and c.block= d.block and c.block = e.block
order by c.obsdate



*****************Merging missing block to the newly created observation table 2241587.nlallobs1*****************

### Identifying the distinct block from 2241587.nlallobs1 table 

select distinct block from s2241587.nlallobs1


### Creating a table with only distinct block from  s2241587.nlallobs1 table

create table s2241587.disblock_nlallobs1 as
select distinct block from  s2241587.nlallobs1


### Creating a table only with the missing block

Create table s2241587.missing_block as
select block, geom from public.block where block not in (select * from s2241587.disblock_nlallobs1)


### Adding new column to s2241587.missing_block table

alter table s2241587.missing_block add  obsdate date
alter table s2241587.missing_block add  observation bigint
alter table s2241587.missing_block add  temper real
alter table s2241587.missing_block add  precip real
alter table s2241587.missing_block add  category character varying
alter table s2241587.missing_block add  roadlength double precision



*****************Final table s2241587.finalobs*****************

### Creating final observation table 

create table s2241587.finalobs as
select * from s2241587.nlallobs1
union
select block, obsdate, observation,temper, precip, category, roadlength, geom from s2241587.missing_block

