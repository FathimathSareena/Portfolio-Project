--select * from 
--PortfolioProject..[CovidDeaths]
--order by 3,4

--select * from 
--PortfolioProject..[CovidVaccinations]
--order by 3,4


--selecting data that going to be used

select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..[CovidDeaths]
order by 1,2

--looking for total cases vs total deaths

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_Persentage
from PortfolioProject..[CovidDeaths]
where location like '%india%'
order by 1,2

--looking at total cases vs population

select location, date, population, total_cases,  (total_cases/population)*100 as P_Persentage
from PortfolioProject..[CovidDeaths]
--where location like '%india%'
order by 1,2


--looking at the countries where highest case rate compared to population

select location, population, max(total_cases) as Highest_Case_Rate, max((total_cases/population))*100 as P_Persentage
from PortfolioProject..[CovidDeaths]
--where location like '%india%'
group by location, population
order by P_Persentage desc


--showing countries with highest death count per population

select location, max(cast(total_deaths as int)) as Total_Deaths
from PortfolioProject..[CovidDeaths]
--where location like '%india%'
where continent is not null
group by location
order by  Total_Deaths desc


--showing by continent

select continent, max(cast(total_deaths as int)) as Total_Deaths
from PortfolioProject..[CovidDeaths]
--where location like '%india%'
where continent is not null
group by continent
order by  Total_Deaths desc

            --OR--

--select location, max(cast(total_deaths as int)) as Total_Deaths
--from PortfolioProject..[CovidDeaths]
----where location like '%india%'
--where continent is null
--group by location
--order by  Total_Deaths desc


--Global numbers


select sum(new_cases) as Total_Cases, sum(cast(new_deaths as int)) as Total_Deaths,
sum(cast(new_deaths as int))/sum(new_cases)*100 as death_Persentage
from PortfolioProject..[CovidDeaths]
--where location like '%india%'
where continent is not null
--group by date
order by 1,2


select * from PortfolioProject..[CovidVaccinations]

--JOIN
--looking total population vs total vaccinated

select D.continent, D.location, D.date, D.population, V.new_vaccinations,
sum(convert(int, V.new_vaccinations)) over (partition by D.location order by D.location, D.date) as Rolling_vaccinated
--(Rolling_vaccinated/population)*100 as Persentage
from PortfolioProject..[CovidDeaths] D
join PortfolioProject..[CovidVaccinations] V
on D.location = V.location 
and D.date = V.date
where D.continent is not null
order by 2,3


--CTE


with PopvsVac (continent, location, date, population, new_vaccinations, Rolling_vaccinated)
as
(
select D.continent, D.location, D.date, D.population, V.new_vaccinations,
sum(convert(int, V.new_vaccinations)) over (partition by D.location order by D.location, D.date) as Rolling_vaccinated
from PortfolioProject..[CovidDeaths] D
join PortfolioProject..[CovidVaccinations] V
on D.location = V.location 
and D.date = V.date
where D.continent is not null
--order by 2,3
)
select *, (Rolling_vaccinated/population)*100 as Persentage
from PopvsVac


--Temp Table

drop table if exists #percentpopulationvaccinated

create table #percentpopulationvaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
Rolling_vaccinated numeric
)

insert into #percentpopulationvaccinated (Continent, Location,Date, Population, New_vaccinations, Rolling_vaccinated)
select D.continent, D.location, D.date, D.population, V.new_vaccinations,
sum(convert(int, V.new_vaccinations)) over (partition by D.location order by D.location, D.date) as Rolling_vaccinated
--(Rolling_vaccinated/population)*100 as Persentage
from PortfolioProject..[CovidDeaths] D
join PortfolioProject..[CovidVaccinations] V
on D.location = V.location 
and D.date = V.date
where D.continent is not null
--order by 2,3

select *, (Rolling_vaccinated/population)*100 as Persentage
from #percentpopulationvaccinated

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

-- Drop the temporary table if it exists
IF OBJECT_ID('tempdb..#percentpopulationvaccinated') IS NOT NULL
    DROP TABLE #percentpopulationvaccinated;

-- Create the temporary table
CREATE TABLE #percentpopulationvaccinated
(
    Continent nvarchar(255),
    Location nvarchar(255),

    Population numeric, -- Specify precision and scale
    New_vaccinations numeric, -- Specify precision and scale
    Rolling_vaccinated numeric -- Specify precision and scale
);

-- Insert data into the temporary table
INSERT INTO #percentpopulationvaccinated (Continent, Location, Population, New_vaccinations, Rolling_vaccinated)
SELECT 
    D.continent,
    D.location,

    D.population,
    V.new_vaccinations,
    SUM(CONVERT(int, V.new_vaccinations)) OVER (PARTITION BY D.location ORDER BY D.date) AS Rolling_vaccinated
FROM 
    PortfolioProject..[CovidDeaths] D
JOIN 
    PortfolioProject..[CovidVaccinations] V
ON 
    D.location = V.location 
    AND D.date = V.date
WHERE 
    D.continent IS NOT NULL;

-- Select data from the temporary table and calculate the percentage of vaccinated population
SELECT 
    *,
    (Rolling_vaccinated / Population) * 100 AS Percentage
FROM 
    #percentpopulationvaccinated;






	-- For CovidDeaths table
SELECT TOP 1 * 
FROM PortfolioProject..[CovidDeaths];

-- For CovidVaccinations table
SELECT TOP 1 * 
FROM PortfolioProject..[CovidVaccinations];



-- Check column details in CovidDeaths
SELECT  date d
FROM PortfolioProject..[CovidDeaths]


-- Check column details in CovidVaccinations
SELECT COLUMN_NAME, DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'CovidVaccinations';



create view percentpopulationvaccinated as
select D.continent, D.location, D.date, D.population, V.new_vaccinations,
sum(convert(int, V.new_vaccinations)) over (partition by D.location order by D.location, D.date) as Rolling_vaccinated
--(Rolling_vaccinated/population)*100 as Persentage
from PortfolioProject..[CovidDeaths] D
join PortfolioProject..[CovidVaccinations] V
on D.location = V.location 
and D.date = V.date
where D.continent is not null
--order by 2,3


select * from percentpopulationvaccinated