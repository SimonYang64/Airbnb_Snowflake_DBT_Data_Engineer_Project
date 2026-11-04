
# 🏠 Airbnb End-to-End Data Engineering Project

## 📋 Overview

This project demonstrates an end-to-end cloud data engineering pipeline built using **Amazon Web Services (AWS S3), Snowflake, dbt (Data Build Tool), SQL, and Python**.

The pipeline processes Airbnb bookings, listings, and host data, transforming raw CSV files into structured, analytics-ready datasets using a **Medallion Architecture (Bronze, Silver, and Gold)**.

The project focuses on cloud data integration, data warehousing, SQL transformations, incremental processing, reusable dbt macros, data modeling, and historical data tracking.

It was developed as a hands-on learning project to strengthen my practical data engineering skills and gain experience working with modern cloud-based data platforms.

---

## 🏗️ Data Architecture

The pipeline follows a layered data architecture designed to separate raw ingestion, data transformation, and analytical consumption.

### Data Flow

```text
                Airbnb CSV Datasets
                        |
                        v
                 Amazon AWS S3
                  (Raw Storage)
                        |
                        v
                  Snowflake
                 STAGING Layer
                        |
                        v
                  dbt - BRONZE
                 Raw Data Models
                        |
                        v
                  dbt - SILVER
            Cleaning & Transformation
                        |
                        v
                   dbt - GOLD
              Analytics-Ready Data
                        |
                        v
                One Big Table (OBT)
                 Analytical Queries
```

### Medallion Architecture

**Bronze Layer — Raw Data**

The Bronze layer ingests data from Snowflake's staging tables with minimal transformation. It provides a foundation for downstream processing while preserving the original source attributes.

The Bronze models include:

- `bronze_bookings` — Booking transactions and reservation information.
- `bronze_hosts` — Host profiles and related attributes.
- `bronze_listings` — Airbnb property and listing information.

**Silver Layer — Cleaned and Transformed Data**

The Silver layer transforms the Bronze data into more consistent and usable datasets.

Transformations include:

- Standardizing host names.
- Categorizing host response rates into quality groups.
- Classifying listing prices into categories.
- Calculating total booking amounts.
- Selecting and organizing fields for downstream analysis.

The Silver models include:

- `silver_bookings`
- `silver_hosts`
- `silver_listings`

**Gold Layer — Analytics-Ready Data**

The Gold layer integrates transformed data into business-ready datasets.

The primary analytical model is:

- `obt` — A One Big Table combining bookings, listings, and host information.

The OBT uses SQL joins and Jinja templating to bring multiple Snowflake tables into a unified dataset that can support reporting, exploration, and downstream analytics.

---

## 🛠️ Technology Stack

| Technology | Purpose |
|------------|---------|
| **Amazon S3** | Cloud storage for raw Airbnb CSV datasets |
| **Snowflake** | Cloud data warehouse for ingestion, processing, and analytics |
| **dbt Core** | SQL-based data transformation and model management |
| **SQL** | Data querying, transformation, and analytical modeling |
| **Python** | Local development environment and dependency management |
| **uv** | Python package and virtual environment management |
| **Jinja** | Dynamic SQL generation and reusable transformation logic |
| **Git & GitHub** | Version control and source code management |
| **VS Code** | Development environment |

---

## 📊 Project Implementation

### 1. Data Ingestion with AWS S3 and Snowflake

The pipeline begins with three Airbnb datasets:

- `bookings.csv`
- `hosts.csv`
- `listings.csv`

The CSV files are stored in an Amazon S3 bucket and accessed through Snowflake using an external stage.

Snowflake file formats and `COPY INTO` commands are used to load the files into the `AIRBNB.STAGING` schema.

This process demonstrates how cloud object storage can integrate with a cloud data warehouse to support data ingestion.

### 2. Data Transformation with dbt

The project uses dbt to organize SQL transformations into Bronze, Silver, and Gold layers.

dbt models define how source data is transformed, while Jinja templating and macros make SQL logic reusable across models.

The project also uses dbt's `source()` and `ref()` functions to reference upstream data and models.

### 3. Incremental Data Processing

Incremental materializations are used in the Bronze and Silver layers.

Rather than rebuilding every model from scratch, incremental logic can process newly arriving records based on timestamp fields.

The models use `CREATED_AT` timestamps and dbt's incremental capabilities to support more efficient recurring data processing.

This demonstrates an important data engineering concept: maintaining transformed datasets as source data changes over time.

### 4. Data Cleaning and Business Logic

The Silver layer applies transformations that make the raw data more useful for analysis.

**Booking Transformations**

- Select booking and listing identifiers.
- Retain booking dates and reservation statuses.
- Calculate booking amounts using a reusable multiplication macro.
- Prepare booking records for analytical modeling.

**Host Transformations**

- Standardize host name formatting.
- Preserve host registration dates and superhost indicators.
- Categorize response rates into `VERY GOOD`, `GOOD`, `FAIR`, and `POOR`.
- Retain timestamp information for downstream modeling.

**Listing Transformations**

- Organize property characteristics and geographic attributes.
- Retain accommodation capacity and room information.
- Classify nightly listing prices into `low`, `medium`, and `high` categories.

### 5. Gold Layer Data Modeling

The Gold layer combines the cleaned datasets into an analytical One Big Table.

The OBT brings together information such as:

- Booking identifiers and dates.
- Booking amounts and fees.
- Listing locations and property types.
- Accommodation capacities.
- Nightly prices and price categories.
- Host profiles and superhost indicators.
- Host response rates and quality classifications.
- Record creation timestamps.

The resulting dataset provides a consolidated view of Airbnb activity without requiring analysts to manually join the individual source tables.

### 6. Reusable SQL Macros

Custom dbt macros help reduce repeated SQL logic and improve maintainability.

Examples include:

| Macro | Function |
|-------|----------|
| `multiply()` | Performs reusable numeric calculations |
| `tag()` | Categorizes numerical values into descriptive groups |
| `trimmer()` | Supports text cleaning and standardization |
| `generate_schema_name()` | Supports custom Snowflake schema organization |

The project also uses Jinja loops to dynamically construct sections of the Gold OBT query.

### 7. Snapshots and Historical Data

The project includes dbt snapshot configurations for exploring Slowly Changing Dimensions (SCD Type 2).

Snapshots are designed to preserve previous versions of records as source information changes.

The snapshot work focuses on tracking historical attributes using unique identifiers and timestamp-based change detection.

---

## 📁 Repository Structure

```text
AWS_DBT_Snowflake/
│
├── aws_dbt_snowflake_project/
│   │
│   ├── models/
│   │   ├── sources/           # Snowflake source definitions
│   │   ├── bronze/            # Raw data models
│   │   ├── silver/            # Cleaned and transformed models
│   │   └── gold/              # Analytical models and OBT
│   │
│   ├── macros/                # Reusable SQL and Jinja macros
│   ├── snapshots/             # Historical data tracking definitions
│   ├── analyses/              # Exploratory SQL queries
│   ├── tests/                 # Data quality test definitions
│   ├── seeds/                 # Static reference data support
│   └── dbt_project.yml        # dbt project configuration
│
├── pyproject.toml             # Python project configuration
├── uv.lock                    # Dependency lockfile
├── .gitignore                 # Git exclusions
└── README.md                  # Project documentation
```

---

## 📈 Data Quality and Validation

Data quality and validation are important parts of maintaining reliable analytical pipelines.

The project incorporates dbt testing capabilities and model compilation checks to support validation of transformations.

Relevant validation concepts include:

- Checking unique identifiers.
- Identifying missing values.
- Validating source-to-model relationships.
- Confirming that models compile successfully.
- Verifying that transformed tables contain the expected columns.
- Inspecting incremental model behavior.

These practices help ensure that data remains consistent as it moves through the transformation layers.

---

## 💡 Technical Challenges and Lessons Learned

Building this project provided practical experience troubleshooting real data engineering problems across multiple technologies.

### AWS and Snowflake Integration

Configured an Amazon S3 external stage and resolved access-related issues when connecting Snowflake to cloud storage.

This reinforced the distinction between cloud storage, warehouse compute resources, and authentication.

### Python and dbt Environment Configuration

Configured a Python virtual environment, managed dependencies using uv, and resolved Windows PATH and environment-related issues.

Established a working dbt connection to Snowflake and validated the configuration using `dbt debug`.

### SQL and Jinja Debugging

Troubleshot SQL compilation errors, incorrect column references, missing macro names, and Jinja syntax issues.

This provided experience interpreting Snowflake and dbt error messages and inspecting compiled SQL.

### Model Dependencies and Incremental Processing

Resolved circular dependencies caused by self-referencing dbt models.

Implemented incremental model logic and explored how database objects are rebuilt and maintained.

### Data Modeling and Schema Consistency

Identified missing fields between transformation layers and updated upstream models to maintain the expected Gold layer schema.

This demonstrated the importance of data lineage, schema validation, and consistent transformations.

---

## 🎯 Skills Demonstrated

This project provided hands-on experience with:

- Cloud data ingestion using Amazon S3 and Snowflake.
- SQL development and cloud data warehousing.
- ELT pipeline development.
- Medallion Architecture.
- Incremental data transformations.
- Data cleaning and standardization.
- dbt models, macros, and Jinja templating.
- Analytical data modeling and multi-table joins.
- Data lineage and dependency management.
- Snapshot-based historical data modeling concepts.
- Git-based version control.
- Debugging and validating data pipelines.

---

## 🚀 Future Improvements

Potential improvements to expand the project include:

- [ ] Expand automated dbt testing and data quality coverage.
- [ ] Add a Power BI or Tableau dashboard using the Gold layer.
- [ ] Implement automated pipeline scheduling.
- [ ] Introduce GitHub Actions for CI/CD.
- [ ] Improve incremental loading and change detection.
- [ ] Add pipeline monitoring and error notifications.
- [ ] Expand documentation and data lineage visibility.
- [ ] Replace hardcoded warehouse object references with dbt-managed dependencies where appropriate.

---

## 👨‍💻 About Me

Hi! I'm **Simon Yang**, an undergraduate student at the **University of North Carolina at Chapel Hill**, interested in data engineering, cloud technologies, and data analytics.

I enjoy working on hands-on projects that allow me to apply technical concepts to real-world data problems.

Through projects like this one, I'm developing my skills in SQL, Python, cloud data platforms, and data pipeline development as I prepare for a career in data engineering.

I'm always interested in learning new technologies, improving my technical skills, and connecting with others working in data.

### Connect With Me

- **LinkedIn:** [Simon Yang](https://www.linkedin.com/in/simon-yang-a5211535a/)
- **Handshake:** [My Handshake Profile](https://app.joinhandshake.com/profiles/ztjfa4)

---

*This repository is part of my personal data engineering portfolio.*
