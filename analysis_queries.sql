CREATE DATABASE PortfolioProject;
USE PortfolioProject;
SELECT COUNT(*) FROM covid_staging;

SELECT * FROM covid_staging LIMIT 5;
CREATE TABLE CovidDeaths AS
SELECT 
    code,
    continent,
    country,
    date,
    population,
    total_cases,
    new_cases,
    total_deaths,
    new_deaths
FROM covid_staging;
CREATE TABLE CovidVaccinations AS
SELECT 
    code,
    continent,
    country,
    date,
    total_vaccinations,
    people_vaccinated,
    people_fully_vaccinated,
    new_vaccinations,
    median_age,
    gdp_per_capita,
    life_expectancy
FROM covid_staging;
SELECT 
    country,
    date,
    total_cases,
    total_deaths,
    ROUND((total_deaths / total_cases) * 100, 2) AS death_percentage
FROM CovidDeaths
WHERE country = 'India'
    AND total_cases > 0
ORDER BY date DESC
LIMIT 20;

SELECT 
    country,
    population,
    MAX(total_cases) AS peak_cases,
    ROUND(MAX((total_cases / population)) * 100, 2) AS infection_rate_pct
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY country, population
ORDER BY infection_rate_pct DESC
LIMIT 20;


SELECT 
    continent,
    SUM(new_deaths) AS total_death_count
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY total_death_count DESC;



SELECT 
    d.country,
    d.date,
    d.total_cases,
    v.total_vaccinations
FROM CovidDeaths d
JOIN CovidVaccinations v
    ON d.code = v.code
    AND d.date = v.date
WHERE d.country = 'India'
ORDER BY d.date DESC
LIMIT 20;

SELECT 
    d.country,
    d.date,
    v.new_vaccinations,
    SUM(v.new_vaccinations) 
        OVER (PARTITION BY d.country ORDER BY d.date) AS rolling_vaccinations
FROM CovidDeaths d
JOIN CovidVaccinations v
    ON d.code = v.code
    AND d.date = v.date
WHERE d.country = 'India'
ORDER BY d.date;



SELECT 
    d.country,
    d.date,
    IFNULL(v.new_vaccinations, 0) AS new_vaccinations,
    SUM(IFNULL(v.new_vaccinations, 0)) 
        OVER (PARTITION BY d.country ORDER BY d.date) AS rolling_vaccinations
FROM CovidDeaths d
JOIN CovidVaccinations v
    ON d.code = v.code
    AND d.date = v.date
WHERE d.country = 'India'
ORDER BY d.date;
