
# 🌍 Global Environment SQL Project

PostgreSQL project analyzing global environmental data, emissions, and sustainability metrics through SQL queries and data insights.
A synthetic relational database for practising SQL — from basic SELECTs to multi-table JOINs, aggregations, and window functions — using realistic environmental data across 20 countries.

> ⚠️ **This is a synthetic practice dataset.** Numbers are illustrative and are not suitable for research or policy decisions.

---

## 📁 Repository Structure

```
global-environment-sql/
├── create_tables_postgresql.sql   # DDL — run this first
├── countries.csv
├── environment_metrics.csv
├── emissions_by_sector.csv
├── protected_areas.csv
├── environment_policies.csv
├── data_sources.csv
└── README_import_steps.txt
```

---

## 🗄️ Database Schema

Six tables form a star-like schema, all linked through `country_id`.

```
countries  (hub)
    │
    ├── environment_metrics   (7 KPIs per country per year)
    ├── emissions_by_sector   (6 sectors × country × year)
    ├── protected_areas       (named conservation zones)
    ├── environment_policies  (policy name, status, impact)
    └── data_sources          (metadata / citation table)
```

### Table Quick Reference

| Table | Rows | Grain | Key Columns |
|---|---|---|---|
| `countries` | 20 | 1 row per country | `continent`, `region`, `iso_code`, `population_2023`, `area_sq_km` |
| `environment_metrics` | 140 | Country × Year (2018–2024) | `co2_emissions_tons_per_capita`, `renewable_energy_percent`, `forest_area_percent`, `pm25_air_pollution`, `clean_water_access_percent`, `environment_performance_index` |
| `emissions_by_sector` | 840 | Country × Year × Sector | `sector` (6 types), `emissions_million_tons_co2e` |
| `protected_areas` | 60 | One area per row | `protected_area_name`, `area_sq_km`, `year_established`, `designation_type` |
| `environment_policies` | 40 | One policy per row | `policy_name`, `year_introduced`, `status`, `impact_level` |
| `data_sources` | 4 | One row per source table | `description`, `reference_url` |

---

## 📊 Dataset Highlights

- **20 countries** across 7 continents/regions (Asia, Europe, North America, Africa, South America, Oceania)
- **7 years** of metrics data (2018–2024)
- **6 emission sectors:** Energy, Industry, Transport, Agriculture, Buildings, Waste
  - Energy is the dominant sector (~36% of total synthetic emissions)
- **5 protected area designation types:** Regional, Marine, National, Private-Public, UNESCO
- **Policy statuses:** Active, Draft, Under Review, Completed
- **Policy impact levels:** High, Medium, Low
- Average renewable energy share across all countries/years: ~24.5%

---

## 🚀 Getting Started

### Prerequisites

- PostgreSQL 13+ (or pgAdmin 4)

### Step 1 — Create the database

```sql
CREATE DATABASE global_environment_db;
```

Connect to `global_environment_db` in pgAdmin before proceeding.

### Step 2 — Create tables

Run the full contents of `create_tables_postgresql.sql`. This drops any existing tables and recreates them in the correct dependency order.

### Step 3 — Import CSV files

Import in this exact order (foreign key constraints require `countries` to exist first):

1. `countries.csv`
2. `environment_metrics.csv`
3. `emissions_by_sector.csv`
4. `protected_areas.csv`
5. `environment_policies.csv`
6. `data_sources.csv`

**In pgAdmin:** right-click a table → *Import/Export Data* → *Import* → select the CSV → set Header = Yes, Delimiter = comma → click OK.

**Via psql:**
```bash
psql -U postgres -d global_environment_db \
  -c "\copy countries FROM 'countries.csv' CSV HEADER"
# repeat for each table in the order above
```

---

## 🧪 Sample Queries

### Basic — list all countries in Asia
```sql
SELECT country_name, region, population_2023
FROM countries
WHERE continent = 'Asia'
ORDER BY population_2023 DESC;
```

### Aggregation — average CO₂ per capita by continent (latest year)
```sql
SELECT c.continent,
       ROUND(AVG(m.co2_emissions_tons_per_capita), 2) AS avg_co2
FROM environment_metrics m
JOIN countries c USING (country_id)
WHERE m.year = 2024
GROUP BY c.continent
ORDER BY avg_co2 DESC;
```

### Multi-table JOIN — active high-impact policies with country info
```sql
SELECT c.country_name, p.policy_name, p.year_introduced, p.impact_level
FROM environment_policies p
JOIN countries c USING (country_id)
WHERE p.status = 'Active'
  AND p.impact_level = 'High'
ORDER BY p.year_introduced;
```

### Window function — rank countries by renewable energy % per year
```sql
SELECT c.country_name,
       m.year,
       m.renewable_energy_percent,
       RANK() OVER (PARTITION BY m.year ORDER BY m.renewable_energy_percent DESC) AS rank
FROM environment_metrics m
JOIN countries c USING (country_id);
```

### Subquery — countries whose total emissions exceed the global average
```sql
SELECT c.country_name, SUM(e.emissions_million_tons_co2e) AS total_emissions
FROM emissions_by_sector e
JOIN countries c USING (country_id)
GROUP BY c.country_name
HAVING SUM(e.emissions_million_tons_co2e) > (
    SELECT AVG(country_total)
    FROM (
        SELECT SUM(emissions_million_tons_co2e) AS country_total
        FROM emissions_by_sector
        GROUP BY country_id
    ) sub
)
ORDER BY total_emissions DESC;
```

---

## 💡 Practice Ideas

| Skill Level | Challenge |
|---|---|
| Beginner | Filter countries by continent; sort by population |
| Beginner | Find the most recent year of data in `environment_metrics` |
| Intermediate | JOIN metrics + countries; compare forest cover by region |
| Intermediate | GROUP BY sector to find the highest-emitting sector per country |
| Intermediate | Count protected areas per designation type |
| Advanced | Use a window function to calculate year-over-year change in CO₂ per capita |
| Advanced | Identify countries with improving EPI but worsening PM2.5 |
| Advanced | Build a view summarising each country's policy count by status |

---

## 📚 Data Sources (Synthetic Inspiration)

| Table | Inspired by |
|---|---|
| `countries` | [World Bank Open Data](https://data.worldbank.org/) |
| `environment_metrics` | [Our World in Data](https://ourworldindata.org/environmental-impacts) |
| `emissions_by_sector` | [IEA Data & Statistics](https://www.iea.org/data-and-statistics) |

All values are synthetic and generated for SQL learning purposes only.

---

## 📄 License

This dataset is provided for educational use. No warranty is given regarding accuracy. Do not cite in academic or policy work.
