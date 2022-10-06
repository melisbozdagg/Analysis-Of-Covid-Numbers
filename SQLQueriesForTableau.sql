-- All Numbers ->Table 1

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from CovidDeaths_Project..CovidDeaths where continent is not null order by 1,2


--Showing Countries with Highest Death Count per Population -> Table 2
Select Location,MAX(cast(total_deaths as int)) as TotalDeathCount
From CovidDeaths_Project..CovidDeaths where continent is not null
Group by location 
order by TotalDeathCount desc


-- Which countries with highest ýnfection rate compared to population --> Table 3
Select Location,population,MAX(total_cases) as HighesInfectionCount,MAX((total_cases/population))*100 as PercentPopulationInfected
From CovidDeaths_Project..CovidDeaths 
Group by location, population, date
order by PercentPopulationInfected desc


-- Which countries with highest ýnfection rate compared to population with date --> Table 4
Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidDeaths_Project..CovidDeaths
Group by Location, Population, date
order by PercentPopulationInfected desc