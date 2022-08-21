Select* 
From PortfolioProject..CovidDeaths
--where continent is not null
Order by 3,4

--Select* 
--From PortfolioProject..CovidVaccinations
--Order by 3,4

-- Select Data that we are going to be using

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Order by 1,2

-- Looking at Total Cases vs Total Deaths
-- This Query shows likelihood of dying if you contract Covid in your country

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where location like '%mexico%'
Order by 1,2

-- Looking at Total Cases vs Population
-- Shows what percentage of population got Covid

Select Location, date, total_cases, population, (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
-- where location like '%mexico%'
Order by 1,2

-- Looking at countries with highest infection rate compared to Population

Select Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Group by Location, population
Order by 4 desc

-- Showing Countries with highest Death count per Population

Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
where continent is not null
Group by Location
Order by TotalDeathCount desc

-- Showing highest death count per population by continent

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
where continent is null
Group by location
Order by TotalDeathCount desc

-- Showing Countries with highest Cases count per Population

Select Location, MAX(total_cases) as TotalCasesCount
From PortfolioProject..CovidDeaths
where continent is not null
Group by Location
Order by TotalCasesCount desc



-- BY CONTINENTS



Select* 
From PortfolioProject..CovidDeaths
where continent is null
Order by 3,4

-- Select Data that we are going to be using

Select continent, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
where continent is not null
Order by 1,2

-- Looking at Total Cases vs Total Deaths
-- This Query shows likelihood of dying if you contract Covid in any country of your continent

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent like '%America%' AND continent is not null
Order by 1,2

-- Looking at Total Cases vs Population
-- Shows what percentage of population got Covid

Select location, date, total_cases, population, (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
-- where location like '%mexico%'
where continent is null AND location like '%America%'
Order by 1,2

-- Looking at continent with highest infection rate compared to Population

Select Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
where continent is null
Group by Location, population
Order by 4 desc

-- Showing Continents with highest Death count per Population

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
where continent is null
Group by location
Order by TotalDeathCount desc

-- Showing Continents with highest Cases count per Population

Select Location, MAX(total_cases) as TotalCasesCount
From PortfolioProject..CovidDeaths
where continent is null
Group by Location
Order by TotalCasesCount desc



-- GLOBAL NUMBERS



Select date, SUM(new_cases) as NewCases, SUM(cast(New_deaths as int)) as NewDeaths, SUM(cast(New_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null
group by date
Order by 1,2



-- looking at Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vax.new_vaccinations
, SUM(Cast(vax.new_vaccinations as int)) OVER (Partition by dea.location order by dea.date) as TotalPeopleVaccinated
From PortfolioProject.. CovidDeaths dea
Join PortfolioProject..CovidVaccinations vax
	On dea.location = vax.location
	AND dea.date = vax.date
where dea.continent is not null
Order By 2,3

-- Use CTE

with PopvsVax (continent, location, date, population, new_vaccinations, TotalPeopleVaccinated) as 
(Select dea.continent, dea.location, dea.date, dea.population, vax.new_vaccinations
, SUM(Cast(vax.new_vaccinations as int)) OVER (Partition by dea.location order by dea.date) as TotalPeopleVaccinated
From PortfolioProject.. CovidDeaths dea
Join PortfolioProject..CovidVaccinations vax
	On dea.location = vax.location
	AND dea.date = vax.date
where dea.continent is not null) --and dea.location like '%Mexico%')
Select *, (TotalPeopleVaccinated/population)*100
From PopvsVax

-- Creating a new Table

Drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(continent varchar(255),
location varchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
TotalPeopleVaccinated numeric)

insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vax.new_vaccinations
, SUM(Cast(vax.new_vaccinations as int)) OVER (Partition by dea.location order by dea.date) as TotalPeopleVaccinated
From PortfolioProject.. CovidDeaths dea
Join PortfolioProject..CovidVaccinations vax
	On dea.location = vax.location
	AND dea.date = vax.date

Select *, (TotalPeopleVaccinated/population)*100
From #PercentPopulationVaccinated