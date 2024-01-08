select *
from coviddeaths
where continent is not null
order by 1,2

-- looking at total cases vs total deaths
-- shows the likihood dying if you contract covid in your country
select location , date , total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from coviddeaths
where location like '%india%'



-- looking at the total cases vs the population
-- shows what percentage of population got covid
select location , date , total_cases,  population, (total_cases/population)*100 as TotalCasePercentage
from coviddeaths
where location like '%india%'


-- looking at countries with higest infection rate with popuation
select location , max(total_cases) as HigestInfectioncount ,  population , max((total_cases/population))*100 as PercentPoupulationInfected
from coviddeaths
group by location , population
order by PercentPoupulationInfected desc



-- let's break down by continent
-- showing the countries higest deathcount per  population
select location  , max(total_deaths) as HigestDeathcount  
from coviddeaths
where continent is  not null 
group by location
order by HigestDeathcount desc


-- showing the continent with higest death count per population
select continent, max(total_deaths ) as TotalDeathCount
from coviddeaths
where continent is not null
group by continent 
order by TotalDeathCount desc


-- global numbers
select  date , sum(new_cases) ,sum(new_deaths) , (sum(new_cases)/sum(new_deaths))*100 as DeathPercentage
from coviddeaths
where continent is not null
group  by date  
-- where location like '%india%'
order by 1



-- looking total pupulation vs vaccination
select dea.location,dea.date,dea.population,vac.new_vaccinations , 
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location , dea.date) as Vaccinated
from covidvacc as vac
join coviddeaths as dea
	on vac.location = dea.location
    and vac.date = dea.date
order by 1,2


-- use cte
with PupvsVac (location,date,population,new_vaccination,Vaccinated)
as
(
select dea.location,dea.date,dea.population,vac.new_vaccinations , 
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location , dea.date) as Vaccinated
from covidvacc as vac
join coviddeaths as dea
	on vac.location = dea.location
    and vac.date = dea.date
-- order by 1,2
)
select *,(Vaccinated/population)*100
from PupvsVac



-- temp table

create table PercentPopulationVaccinated
(
location nvarchar(255),
date datetime,
population numeric,
new_vaccination numeric,
Vaccinated numeric
)
insert into PercentPopulationVaccinated
select dea.location,dea.date,dea.population,vac.new_vaccinations , 
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location , dea.date) as Vaccinated
from covidvacc as vac
join coviddeaths as dea
	on vac.location = dea.location
    and vac.date = dea.date
-- order by 1,2
)
select *,(Vaccinated/population)*100
from PercentPopulationVaccinated



-- creating view  to store data fro later visualization
create view  PercentPopulationVaccinated as
select dea.location,dea.date,dea.population,vac.new_vaccinations , 
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location , dea.date) as Vaccinated
from covidvacc as vac
join coviddeaths as dea
	on vac.location = dea.location
    and vac.date = dea.date
    
    
select * from PercentPopulationVaccinated







