 
Select *
From PortfolioProject.dbo.CovidVaccinations
Order By 3,4

Select *
From PortfolioProject.dbo.CovidDeaths
Where continent is not null
Order By 3,4


SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
Where continent is not null
ORDER BY 1,2

--Looking at Total Cases Vs Total Deaths
-- Shows the percentage of death who got infected

SELECT location, date, total_cases, total_deaths, (CAST(total_deaths AS DECIMAL(15,3))  / Cast(total_cases AS DECIMAL(15,3))) * 100 DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
WHERE Location = 'India'
and continent is not null
ORDER BY 1,2



--Looking at Total Cases Vs Population
--Shows what percentage of population got Covid

SELECT location, date, total_cases, population, (Cast(total_cases AS DECIMAL(15,3)) / CAST(population AS DECIMAL(15,3))) * 100 CasePercentAsPerPopulation
FROM PortfolioProject.dbo.CovidDeaths
WHERE Location like '%bosnia%'
and continent is not null
ORDER BY 1,2


--Looking at the Countries with Highest Infection Rate compared to Population

SELECT location, population, 
	MAX(Cast(total_cases as BIGINT)) HighestInfectedCount,
	MAX(Cast(total_cases AS DECIMAL(15,2)) / CAST(population AS DECIMAL(15,2))) * 100 CasePercentageAsPerPopulation
FROM PortfolioProject.dbo.CovidDeaths
--WHERE Location = 'India'
Where continent is not null
Group By location, population
ORDER BY CasePercentageAsPerPopulation Desc






--Showing Countries with Highest Deaths Count per Population


SELECT location, population, 
	MAX(Cast(total_deaths as BIGINT)) HighestDeathCount,
	MAX(Cast(total_deaths AS DECIMAL(15,2)) / CAST(population AS DECIMAL(15,2))) * 100 DeathPercentageAsPerPopulation
FROM PortfolioProject.dbo.CovidDeaths
--WHERE Location = 'India'
Where continent is not null
Group By location, population
ORDER BY DeathPercentageAsPerPopulation Desc


-- Showing Countries with Highest Death Count per Population

SELECT location,
	Max(Cast(total_deaths as BIGINT))  as TotalDeathCount
	From PortfolioProject..CovidDeaths
	Where continent is not null
	and location like '%china%'
	Group by location
	Order by TotalDeathCount Desc





-- LET'S BREAK THINGS DOWN BY CONTINENT

--Showing Ccontinents with Highest Death Count 

SELECT continent,
Max(Cast(total_deaths as BIGINT))  as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by continent
Order by TotalDeathCount Desc




-- Looking at Total Population vs Vaccinations


with PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations_smoothed,
SUM(Cast(vac.new_vaccinations_smoothed as bigint)) 
OVER (Partition by dea.location Order by dea.location, dea.date ) as RollingPeopleVaccinated
--, (RollinPeopleVaccinated/ population)* 100
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL
--Order by 2,3
)

Select * , (RollingPeopleVaccinated/ population)* 100
from PopvsVac

--Creating view to store data for future visualizations

SELECT *
FROM PercentPopulationVaccinated