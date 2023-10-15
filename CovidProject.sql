SELECT * 
FROM CovidDeaths
ORDER BY 3,4 

SELECT * 
FROM CovidVaccinations 
ORDER BY 3,4 

SELECT location,date,total_cases,new_cases,total_deaths,population 
FROM CovidDeaths
ORDER BY 1,2 

SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 AS DeathPercenatage 
FROM CovidDeaths
WHERE location LIKE '%Nig%ia' 
ORDER BY 1, 2 

SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 AS DeathPercenatage 
FROM CovidDeaths
WHERE location LIKE '%HANA%' 
ORDER BY 1,2

SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 AS DeathPercenatage 
FROM CovidDeaths
WHERE location LIKE '%states%' 
ORDER BY 1,2  

SELECT location,date,population,total_cases,(total_cases/population)*100 AS total_casesPercenatage 
FROM CovidDeaths
WHERE location LIKE '%iger%ia' 
ORDER BY 1,2  

SELECT location,date,population,total_cases,(total_cases/population)*100 AS total_casesPercenatage 
FROM CovidDeaths
WHERE location = 'Ghana' 
ORDER BY 1,2

SELECT location,date,population,total_cases,(total_cases/population)*100 AS total_casesPercenatage 
FROM CovidDeaths
WHERE location LIKE '%states%' 
ORDER BY 1,2 

SELECT location,population,MAX(total_cases) AS highestInfectionCount,MAX((total_cases/population)*100) AS PercentagePopulationInfected
FROM CovidDeaths 
WHERE continent IS NOT NULL
GROUP BY location,population
ORDER BY PercentagePopulationInfected DESC

SELECT location,MAX(CAST (total_deaths AS int)) AS TotalDeathsCount
FROM CovidDeaths 
WHERE continent IS NOT NULL 
GROUP BY location
ORDER BY TotalDeathsCount DESC 

SELECT location,MAX(CAST (total_deaths AS int)) AS TotalDeathsCount
FROM CovidDeaths 
WHERE continent IS NOT NULL AND continent  = 'Africa'
GROUP BY location
ORDER BY TotalDeathsCount DESC 

SELECT continent,MAX(CAST (total_deaths AS int)) AS TotalDeathsCount
FROM CovidDeaths 
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathsCount DESC 


SELECT date,MAX(total_cases) AS MaxTotalCase,MAX(total_deaths) AS MaxTotalDeaths, 
FROM CovidDeaths 
WHERE continent IS NOT NULL AND continent  = 'Africa'
GROUP BY date
ORDER BY 1,2 DESC 

SELECT date,MAX(total_cases) AS MaxTotalCase,MAX(total_deaths) AS MaxTotalDeaths, (MAX(total_deaths)/MAX(total_cases))*100 AS TotalDeathAfricaPerc  
FROM CovidDeaths 
WHERE continent IS NOT NULL AND continent  = 'Africa'
GROUP BY date
ORDER BY 1,2

SELECT date,MAX(total_cases) AS MaxTotalCase,MAX(total_deaths) AS MaxTotalDeaths, (MAX(total_deaths)/MAX(total_cases))*100 AS TotalDeathAfricaPerc  
FROM CovidDeaths 
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2 

SELECT date, MAX(new_cases) AS MaxNewCases, MAX(new_deaths) AS MaxNewDeaths 
FROM CovidDeaths 
WHERE continent IS NOT NULL 
GROUP BY date 
ORDER BY 1,2 

SELECT date, MAX(new_cases) AS MaxNewCases, MAX(new_deaths) AS MaxNewDeaths, (MAX(new_deaths)/MAX(new_cases))*100
FROM CovidDeaths 
WHERE continent IS NOT NULL 
GROUP BY date 
ORDER BY 1,2 

SELECT date, SUM(new_cases) AS TotalNewCases, SUM(CAST(new_deaths AS int)) AS TotalNewDeaths
FROM CovidDeaths 
WHERE continent IS NOT NULL 
GROUP BY date 
ORDER BY 1,2 

SELECT date, SUM(new_cases) AS TotalNewCases, SUM(CAST(new_deaths AS int)) AS TotalNewDeaths, (SUM(CAST(new_deaths AS int))/SUM(new_cases))*100 AS TotalDeathPerc
FROM CovidDeaths 
WHERE continent IS NOT NULL 
GROUP BY date 
ORDER BY 1,2 

SELECT date,(SUM(CAST(new_deaths AS int))/SUM(new_cases))*100 AS TotalDeathPerc
FROM CovidDeaths 
WHERE continent IS NOT NULL 
GROUP BY date 
ORDER BY 2 DESC 

SELECT *
FROM CovidVaccinations 

SELECT * 
FROM CovidDeaths dea 
JOIN CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date 
	
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
FROM CovidDeaths dea 
JOIN CovidVaccinations vac 
	ON dea.location = vac.location
	AND dea.date = vac.date 
WHERE dea.continent IS NOT NULL 
ORDER BY 1,2,3 

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(CAST(vac.new_vaccinations AS int)) OVER (PARTITION BY dea.location ORDER by dea.date)
FROM CovidDeaths dea 
JOIN CovidVaccinations vac 
	ON dea.location = vac.location
	AND dea.date = vac.date 
WHERE dea.location = 'United States' AND dea.continent IS NOT NULL 
ORDER BY 1,2,3  

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(CAST(vac.new_vaccinations AS int)) OVER (PARTITION BY dea.location)
FROM CovidDeaths dea 
JOIN CovidVaccinations vac 
	ON dea.location = vac.location
	AND dea.date = vac.date 
WHERE dea.location = 'Senegal' AND dea.continent IS NOT NULL 
ORDER BY 1,2,3 

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(CAST(vac.new_vaccinations AS int)) OVER (PARTITION BY dea.location) AS RunningTotalVaccinated
FROM CovidDeaths dea 
JOIN CovidVaccinations vac 
	ON dea.location = vac.location
	AND dea.date = vac.date 
WHERE dea.location = 'Senegal' AND dea.continent IS NOT NULL 
ORDER BY 1,2,3 
 

 -- USING CTE TO LOOK AT RUNNING TOTAL VACCINATED VS POPULATION
 WITH Vacc_Vs_Pop (continent, location, date, population, new_vaccinations, RunningTotalVaccinated) 
 AS 
 (
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(CAST(vac.new_vaccinations AS int)) OVER (PARTITION BY dea.location ORDER by dea.date) AS RunningTotalVaccinated
FROM CovidDeaths dea 
JOIN CovidVaccinations vac 
	ON dea.location = vac.location
	AND dea.date = vac.date 
WHERE  dea.continent IS NOT NULL 
--ORDER BY 1,2,3
) 
SELECT *, (RunningTotalVaccinated/population)*100 AS PopulationVaccinated
FROM Vacc_Vs_Pop 
ORDER BY continent,location 

 WITH Vacc_Vs_Pop (continent, location, date, population, new_vaccinations, RunningTotalVaccinated) 
 AS 
 (
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(CAST(vac.new_vaccinations AS int)) OVER (PARTITION BY dea.location ORDER by dea.date) AS RunningTotalVaccinated
FROM CovidDeaths dea 
JOIN CovidVaccinations vac 
	ON dea.location = vac.location
	AND dea.date = vac.date 
WHERE  dea.continent IS NOT NULL 
--ORDER BY 1,2,3
) 
SELECT *, (RunningTotalVaccinated/population)*100 AS PopulationVaccinated
FROM Vacc_Vs_Pop  
WHERE location = 'Nigeria'
ORDER BY continent,location 


 -- USING TEMP TABLE TO LOOK AT RUNNING TOTAL VACCINATED VS POPULATION
 
 DROP TABLE IF EXISTS #Vacc_Vs_Pop
 CREATE TABLE #Vacc_Vs_Pop (
 continent nvarchar(255),
 location nvarchar(255),
 date datetime, 
 population numeric, 
 new_vaccinations numeric, 
 RunningTotalVaccinated numeric
 ) 
INSERT INTO #Vacc_Vs_Pop 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(CAST(vac.new_vaccinations AS int)) OVER (PARTITION BY dea.location ORDER by dea.date) AS RunningTotalVaccinated
FROM CovidDeaths dea 
JOIN CovidVaccinations vac 
	ON dea.location = vac.location
	AND dea.date = vac.date 
WHERE  dea.continent IS NOT NULL 
--ORDER BY 1,2,3 

SELECT *,(RunningTotalVaccinated/population)*100 AS RunningVaccinatedPercentage
FROM #Vacc_Vs_Pop 
WHERE location = 'Nigeria' 

CREATE VIEW RunningVaccinatedPercentage AS 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(CAST(vac.new_vaccinations AS int)) OVER (PARTITION BY dea.location ORDER by dea.date) AS RunningTotalVaccinated
FROM CovidDeaths dea 
JOIN CovidVaccinations vac 
	ON dea.location = vac.location
	AND dea.date = vac.date 
WHERE  dea.continent IS NOT NULL 
--ORDER BY 1,2,3 

SELECT * 
FROM RunningVaccinatedPercentage