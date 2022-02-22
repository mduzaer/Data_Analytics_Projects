--Tables and Columns:

select * 
from CovidPortfolioProject.dbo.CovidDeaths
order by 3,4;



select * 
from CovidPortfolioProject.dbo.CovidVaccinations
order by 3,4;


select location, date, total_cases, new_cases, total_deaths, population
from CovidPortfolioProject.dbo.CovidDeaths
order by 1, 2;


--Total cases vs Total deaths:
select location, date, total_cases, total_deaths, ((Total_deaths/Total_cases)*100) as Death_Percentage
from CovidPortfolioProject.dbo.CovidDeaths
--where location like '%India%' 
where continent is not null
order by 1, 2;



--Total cases vs Population:
select location, date, total_cases, Population, ((Total_cases/Population)*100) as Population_Percentage
from CovidPortfolioProject.dbo.CovidDeaths
--where location like '%India%'
where continent is not null
order by 1, 2;


--Highest infection rate compared to Population:
select location, Population, MAX(Total_cases) as Highest_Infection, (MAX(Total_cases)/Population)*100 as Highest_Infection_Percentage
from CovidPortfolioProject.dbo.CovidDeaths
--where location like '%India%'
where continent is not null
group by location, Population
order by 4 desc;


--Highest Death count per population:
select location, MAX(cast(total_deaths as int)) as Highest_Deaths
from CovidPortfolioProject.dbo.CovidDeaths
--where location like '%India%'
where continent is not null
group by location
order by 2 desc;


select continent, MAX(cast(total_deaths as int)) as Highest_Deaths
from CovidPortfolioProject.dbo.CovidDeaths
--where location like '%India%'
where continent is not null
group by continent
order by 2 desc;


select location, Population, MAX(total_deaths) as Highest_Deaths, (MAX(total_deaths)/Population)*100 as Highest_Death_Percentage
from CovidPortfolioProject.dbo.CovidDeaths
--where location like '%India%'
where continent is not null
group by location, Population
order by 4 desc;


--Death percent by date:
select date, SUM(new_cases), SUM(cast(new_deaths as int)), SUM(cast(new_deaths as int))/SUM(new_cases) * 100 as Death_Percentage
from CovidPortfolioProject.dbo.CovidDeaths
--where location like '%India%'
where continent is not null
group by date
order by 1 desc;


--Global Death percent:
select SUM(new_cases) AS Total_cases, SUM(cast(new_deaths as int)) as Total_Deaths, SUM(cast(new_deaths as int))/SUM(new_cases) * 100 as Death_Percentage
from CovidPortfolioProject.dbo.CovidDeaths
where continent is not null;


--Total Population vs Vaccinations
select Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations
from CovidPortfolioProject.dbo.CovidDeaths as Dea
join CovidPortfolioProject.dbo.CovidVaccinations as Vac
 on Dea.location = Vac.location
 and Dea.date = Vac.date
 where Dea.continent is not null
 order by 2,3;


 --Total Population vs Vaccinations (rolling num - added together)
 select Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations,
 SUM(cast(Vac.new_vaccinations as int)) over (Partition by Dea.location order by Dea.location, Dea.date) as Rolling_People_Vaccinated
from CovidPortfolioProject.dbo.CovidDeaths as Dea
join CovidPortfolioProject.dbo.CovidVaccinations as Vac
 on Dea.location = Vac.location
 and Dea.date = Vac.date
 where Dea.continent is not null
 order by 2,3;



 --Creating TEMP table:

 Create table Percent_Population_Vaccinated
 (
 continent nvarchar(255),
 location  nvarchar(255),
 date datetime,
 population numeric,
 new_vaccinations numeric,
 Rolling_People_Vaccinated numeric
 )

 Insert into Percent_Population_Vaccinated
 select Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations,
 SUM(cast(Vac.new_vaccinations as int)) over (Partition by Dea.location order by Dea.location, Dea.date) as Rolling_People_Vaccinated
from CovidPortfolioProject.dbo.CovidDeaths as Dea
join CovidPortfolioProject.dbo.CovidVaccinations as Vac
 on Dea.location = Vac.location
 and Dea.date = Vac.date
 where Dea.continent is not null;
 --order by 2,3;


 select *, (Rolling_People_Vaccinated/population)*100
 from Percent_Population_Vaccinated;








 -- 1. 

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From CovidPortfolioProject.dbo.CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

-- Just a double check based off the data provided
-- numbers are extremely close so we will keep them - The Second includes "International"  Location


--Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
--From PortfolioProject..CovidDeaths
----Where location like '%states%'
--where location = 'World'
----Group By date
--order by 1,2


-- 2. 

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From CovidPortfolioProject.dbo.CovidDeaths
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc


-- 3.

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidPortfolioProject.dbo.CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc


-- 4.


Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidPortfolioProject.dbo.CovidDeaths
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc














