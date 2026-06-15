-- PostgreSQL schema for Global Environment SQL Project
CREATE DATABASE global_environment_db;
-- After creating DB in pgAdmin, connect to it and run the rest below.

DROP TABLE IF EXISTS environment_policies;
DROP TABLE IF EXISTS protected_areas;
DROP TABLE IF EXISTS emissions_by_sector;
DROP TABLE IF EXISTS environment_metrics;
DROP TABLE IF EXISTS data_sources;
DROP TABLE IF EXISTS countries;

CREATE TABLE countries (
  country_id INT PRIMARY KEY,
  country_name VARCHAR(80),
  continent VARCHAR(40),
  region VARCHAR(80),
  iso_code CHAR(2),
  population_2023 BIGINT,
  area_sq_km NUMERIC(12,2),
  capital_city VARCHAR(80)
);

CREATE TABLE environment_metrics (
  metric_id INT PRIMARY KEY,
  country_id INT REFERENCES countries(country_id),
  year INT,
  co2_emissions_tons_per_capita NUMERIC(8,2),
  renewable_energy_percent NUMERIC(6,2),
  forest_area_percent NUMERIC(6,2),
  pm25_air_pollution NUMERIC(8,2),
  clean_water_access_percent NUMERIC(6,2),
  waste_generated_kg_per_capita_day NUMERIC(6,2),
  environment_performance_index NUMERIC(6,2)
);

CREATE TABLE emissions_by_sector (
  emission_id INT PRIMARY KEY,
  country_id INT REFERENCES countries(country_id),
  year INT,
  sector VARCHAR(40),
  emissions_million_tons_co2e NUMERIC(12,2)
);

CREATE TABLE protected_areas (
  area_id INT PRIMARY KEY,
  country_id INT REFERENCES countries(country_id),
  protected_area_name VARCHAR(120),
  area_sq_km NUMERIC(12,2),
  year_established INT,
  designation_type VARCHAR(40)
);

CREATE TABLE environment_policies (
  policy_id INT PRIMARY KEY,
  country_id INT REFERENCES countries(country_id),
  policy_name VARCHAR(100),
  year_introduced INT,
  status VARCHAR(30),
  impact_level VARCHAR(20)
);

CREATE TABLE data_sources (
  source_id INT PRIMARY KEY,
  table_name VARCHAR(80),
  description TEXT,
  reference_url TEXT
);
