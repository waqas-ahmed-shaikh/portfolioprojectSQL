Select *
From
portfolio_project..CovidDeaths
Where continent is not null
Order by 3, 4

--Select *
--From
--portfolio_project..CovidVaccinations
--Order by 3, 4

--Selecting the data that we need
Select
location, population,date, total_cases, new_cases, total_deaths
From
portfolio_project..CovidDeaths
Order by
1,3

--Looking at total cases vs total deaths
--Shows likelihood of dying after contracting covid
Select
location,date, population, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
From
portfolio_project..CovidDeaths
Where
location like '%India%'
Order by
1,2

--Looking at total cases vs population
--Shows what percentage of people has gotten COVID
Select
location, date, population, total_cases, (total_cases/ population)*100 as percent_population_infected
From
portfolio_project..CovidDeaths
Where
location = 'India'
Order by 
1, 2

--Which countries have highest infection rate

Select
location, population, Max(total_cases) as highest_infection_count  , max(total_cases/population*100) as percent_infection_rate
From
portfolio_project..CovidDeaths
Group by 
location, population
Order by
percent_infection_rate desc

--Countries with maximum death rate

Select
location, max(cast(total_deaths as bigint)) as highest_death_count
From
portfolio_project..CovidDeaths
Where 
continent is not null 
Group by
location
Order by
highest_death_count desc

--Lets view everything by continent
--Showing continents with highest death count

Select
continent, max(cast(total_deaths as bigint)) as highest_death_count
From
portfolio_project..CovidDeaths
Where 
continent is not null
Group by
continent
Order by
highest_death_count desc

--GLOBAL NUMBERS

Select
date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/ sum(new_cases)*100 as death_percentage
From
portfolio_project..CovidDeaths
Where
continent is not null
group by
date
Order by 
1, 2


Select
sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/ sum(new_cases)*100 as death_percentage
From
portfolio_project..CovidDeaths
Where
continent is not null
Order by 
1, 2

-- Covid Vaccination

Select *
From
portfolio_project..CovidVaccinations

--Looking at Total Population vs Total vaccination

Select
dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From
portfolio_project..CovidDeaths as dea
Join
portfolio_project..CovidVaccinations as vac
	on
	dea.location = vac.location and
	dea.date = vac.date
Where dea.continent is not null
Order by
2,3

Select
dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
Sum(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.date) as rolling_people_vaccinated
From
portfolio_project..CovidDeaths as dea
Join portfolio_project..CovidVaccinations as vac
On
	dea.location = vac.location and
	dea.date = vac.date
Where dea.continent is not null
Order by
2,3

--Creating CTE (Common Table Expressions)

With popvac (continent, location, date, population, new_vaccinations, rolling_people_vaccinated)
as
(
Select
dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
Sum(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.date) as rolling_people_vaccinated
From
portfolio_project..CovidDeaths as dea
Join portfolio_project..CovidVaccinations as vac
On
	dea.location = vac.location and
	dea.date = vac.date
Where dea.continent is not null
--Order by
--2,3
)

Select *,(rolling_people_vaccinated/population*100) as percent_vaccinated
From
popvac

