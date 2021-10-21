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
select SUM(new_cases), SUM(cast(new_deaths as int)) as Total_Deaths, SUM(cast(new_deaths as int))/SUM(new_cases) * 100 as Death_Percentage
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
 







