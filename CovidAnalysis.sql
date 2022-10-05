
Select * From CovidDeaths_Project..CovidDeaths
where continent is not null
order by 3,4

--Select * From CovidDeaths_Project..CovidVaccinations
--order by 3,4

Select Location, date, total_cases,new_cases,total_deaths,population
From CovidDeaths_Project..CovidDeaths where continent is not null order by 1,2

-- Total Cases and Total Deaths

Select Location, date, total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From CovidDeaths_Project..CovidDeaths where continent is not null and location like '%africa%' order by 1,2 

-- Total Cases and Population -> Shows what percentage of population got covid

Select Location, date, total_cases,population,(total_cases/population)*100 as DeathPercentage
From CovidDeaths_Project..CovidDeaths where location like '%africa%' order by 1,2

-- Which countries with highest ýnfection rate compared to population


Select Location,population,MAX(total_cases) as HighesInfectionCount,MAX((total_cases/population))*100 as PercentPopulationInfected
From CovidDeaths_Project..CovidDeaths 
Group by location, population 
order by PercentPopulationInfected desc

--Showing Countries with Highest Death Count per Population
Select Location,MAX(cast(total_deaths as int)) as TotalDeathCount
From CovidDeaths_Project..CovidDeaths where continent is not null
Group by location 
order by TotalDeathCount desc

-- Showing the continents with the hisghest death count per population

Select continent,MAX(cast(total_deaths as int)) as TotalDeathCount
From CovidDeaths_Project..CovidDeaths where continent is not null
Group by continent 
order by TotalDeathCount desc

-- All Numbers 

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from CovidDeaths_Project..CovidDeaths where continent is not null order by 1,2

-- Total Population vs Vaccinations
select dead.continent, dead.location, dead.date, dead.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dead.location 
order by dead.location, dead.Date) as RollingPeopleVaccinated
from CovidDeaths_Project..CovidVaccinations vac
join CovidDeaths_Project..CovidDeaths dead
On dead.location = vac.location and dead.date = vac.date where dead.continent is not null 
order by 2,3

--TEMP TABLE
DROP table if exists #PercentPopulationVaccinated
CREATE Table #PercentPopulationVaccinated (
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric )

insert into #PercentPopulationVaccinated
select dead.continent, dead.location, dead.date, dead.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dead.location 
order by dead.location, dead.Date) as RollingPeopleVaccinated
from CovidDeaths_Project..CovidVaccinations vac
join CovidDeaths_Project..CovidDeaths dead
On dead.location = vac.location and dead.date = vac.date 


Select *, (RollingPeopleVaccinated/Population)*100 from #PercentPopulationVaccinated

--Creating view to store data for visualizations

Create View PercentPopulationVaccinated as 
select dead.continent, dead.location, dead.date, dead.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dead.location 
order by dead.location, dead.Date) as RollingPeopleVaccinated
from CovidDeaths_Project..CovidVaccinations vac
join CovidDeaths_Project..CovidDeaths dead
On dead.location = vac.location and dead.date = vac.date 
where dead.continent is not null


Select * From PercentPopulationVaccinated