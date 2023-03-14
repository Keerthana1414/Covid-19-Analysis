use covid19_project;

select * from date_delta
select * from date_delta7
select * from date_total
select * from delta
select * from delta21_14
select * from delta7
select * from districts_delta
select * from districts_delta21_14
select * from districts_delta7
select * from districts_meta
select * from districts_total
select * from meta
select * from state_statecode
select * from total

-----State-wise Data---
select a.statecode, State, sum(confirmed) as confirmed, sum(recovered) as recovered , sum(tested) as tested, 
sum(deceased) as deceased, sum(vaccinated1) as partially_vaccinated, sum(vaccinated2) as fully_vaccinated 
from date_delta a join state_statecode b on a.statecode = b.statecode
group by a.statecode, State
order by confirmed desc



---- District-wise Data---
select a.statecode, State, Districts, sum(confirmed) as confirmed, sum(recovered) as recovered , sum(tested) as tested, 
sum(deceased) as deceased, sum(vaccinated1) as partially_vaccinated, sum(vaccinated2) as fully_vaccinated 
from districts_delta a join state_statecode b on a.statecode = b.statecode
group by a.statecode, State, Districts
order by confirmed desc



----Vaccination Coverage (atleast one dose)---
with cte as
(
select a.statecode, State, sum(confirmed) as confirmed, sum(recovered) as recovered , sum(tested) as tested, 
sum(deceased) as deceased, sum(vaccinated1) as partially_vaccinated, sum(vaccinated2) as fully_vaccinated 
from date_delta a join state_statecode b on a.statecode = b.statecode
group by a.statecode, State
)
select c.statecode, state, cast((cast(partially_vaccinated as float)/cast(population as float)) as decimal(5,2)) as Vaccination_coverage,
cast((cast(fully_vaccinated as float)/cast(population as float)) as decimal(5,2)) as Fully_vaccinated_proportion
from cte c join meta d on c.statecode=d.statecode
where c.statecode not in ('AN', 'CH', 'DN', 'LD', 'PY')
order by Vaccination_coverage desc



---- KPI Table---
with cte as
(
select a.statecode, year(dates) as year_, month(dates) as month_no, Concat(left(datename(month, dates), 3), ' ', right(year(dates), 2))  as Month_year, sum(confirmed) as confirmed, 
sum(recovered) as recovered , sum(tested) as tested, 
sum(deceased) as deceased, sum(vaccinated1) as partially_vaccinated, sum(vaccinated2) as fully_vaccinated 
from date_delta a join state_statecode b on a.statecode = b.statecode
group by a.statecode, year(dates), month(dates), Concat(left(datename(month, dates), 3), ' ', right(year(dates), 2)) 
)
select ct.statecode,state, Month_year,confirmed, deceased, recovered,tested,
cast((cast(deceased as float)/cast(confirmed as float)) as decimal(5,2)) as CFR,
cast((cast(confirmed as float)/cast(tested as float)) as decimal(5,2)) as TPR,
cast((cast(recovered as float)/cast(confirmed as float)) as decimal(5,2)) as Recovery_rate
from cte ct join state_statecode s on ct.statecode = s.statecode 
where confirmed !=0 and tested !=0 and ct.statecode not in ('AN', 'CH', 'DN', 'LD', 'PY')
order by statecode, year_, month_no




-----Weekly table----
with cte as
(
select a.statecode, year(dates) as year_, month(dates) as month_no, Concat(left(datename(month, dates), 3), ' ', right(year(dates), 2))  as Month_year, 
CASE 
	WHEN DAY(dates) <8 then 'Week 1'
	WHEN DAY(dates) <15 then 'Week 2'
	WHEN DAY(dates) <22 then 'Week 3'
	ELSE 'Week 4'
END AS Week_,
sum(confirmed) as confirmed, 
sum(recovered) as recovered , sum(tested) as tested, 
sum(deceased) as deceased, sum(vaccinated1) as partially_vaccinated, sum(vaccinated2) as fully_vaccinated 
from date_delta a join state_statecode b on a.statecode = b.statecode
group by a.statecode, year(dates), month(dates), Concat(left(datename(month, dates), 3), ' ', right(year(dates), 2)), CASE 
	WHEN DAY(dates) <8 then 'Week 1'
	WHEN DAY(dates) <15 then 'Week 2'
	WHEN DAY(dates) <22 then 'Week 3'
	ELSE 'Week 4'
END
)
select statecode, year_, Month_year,
sum(case when Week_ = 'Week 1' then deceased end) as 'Week 1',
sum(case when Week_ = 'Week 2' then deceased end) as 'Week 2',
sum(case when Week_ = 'Week 3' then deceased end) as 'Week 3',
sum(case when Week_ = 'Week 4' then deceased end) as 'Week 4'
from cte
where confirmed !=0 and tested !=0 and statecode not in ('AN', 'CH', 'DN', 'LD', 'PY')
group by statecode, year_, Month_year, month_no
order by statecode, year_, month_no




----Testing Ratio-----

WITH CTE as
(
SELECT a.*, cast((tested/cast(population as decimal)) as decimal(3,2))as tr
FROM districts_total a 
join districts_meta b
on a.districts=b.districts and a.statecode=b.statecode
WHERE population !=0
),
CTE1 as
(
SELECT *, 
CASE 
	WHEN (tr>=0.05) AND (tr<=0.1) THEN 'A'
	WHEN (tr>0.1) AND (tr<=0.3) THEN 'B'
	WHEN (tr>0.3) AND (tr<=0.5) THEN 'C'
	WHEN (tr>0.5) AND (tr<=0.75) THEN 'D'
	WHEN (tr>0.75) AND (tr<=1) THEN 'E'
END AS Category
From CTE
)
SELECT c1.statecode, State, districts, Category,sum(deceased) as Number_of_Deaths
FROM CTE1 c1 join state_statecode s on c1.statecode = s.statecode
WHERE category is not null AND c1.statecode not in ('AN', 'CH', 'DN', 'LD', 'PY')
group by c1.statecode, state, category, districts 







