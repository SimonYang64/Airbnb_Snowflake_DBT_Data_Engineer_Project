
# 🏠 Airbnb End-to-End Data Engineering Project

## 📋 Overview

This project demonstrates an end-to-end cloud data engineering pipeline built using **AWS S3, Snowflake, dbt (Data Build Tool), SQL, and Python**.

The pipeline integrates Airbnb booking, listing, and host datasets into a cloud data warehouse, where raw information is processed through a **Medallion Architecture (Bronze, Silver, and Gold)** to produce structured, analytics-ready data.

The project focuses on cloud data ingestion, ELT development, incremental processing, data transformation, reusable SQL logic, and analytical data modeling.

I developed this project as a hands-on learning experience to strengthen my data engineering skills and gain practical exposure to modern cloud data technologies.

---

## 🏗️ Data Architecture

### Data Pipeline

The project follows a layered architecture that separates data storage, ingestion, transformation, and analytical consumption.

```text
                  Airbnb CSV Datasets
                           |
                           v
                      AWS S3
                   Cloud Storage
                           |
                           v
                       Snowflake
                     STAGING Layer
                           |
                           v
                      BRONZE Layer
                    Raw Data Models
                           |
                           v
                      SILVER Layer
                 Cleaned & Transformed
                           |
                           v
                       GOLD Layer
                   Analytics-Ready
                           |
                           v
                    One Big Table
                          (OBT)
```

### Medallion Architecture

#### 🥉 Bronze Layer — Raw Data

The Bronze layer retrieves data from Snowflake staging tables and preserves the original source attributes for downstream processing.

**Models:**
- `bronze_bookings` — Booking transactions and reservation details.
- `bronze_hosts` — Host information and associated attributes.
- `bronze_listings` — Airbnb listing and property information.

Incremental materializations support processing of newly arriving records without unnecessarily rebuilding existing data.

#### 🥈 Silver Layer — Data Transformation

The Silver layer transforms the raw datasets into consistent, standardized, and business-relevant information.

**Models:**
- `silver_bookings` — Booking information with calculated financial metrics.
- `silver_hosts` — Standardized host profiles with response-rate quality classifications.
- `silver_listings` — Property attributes with nightly price categorization.

**Key transformations:**
- Standardizing host names.
- Calculating total booking amounts.
- Categorizing listing prices into low, medium, and high ranges.
- Classifying host response rates.
- Applying SQL transformations through reusable dbt macros.
- Preserving timestamp fields for downstream processing.

#### 🥇 Gold Layer — Analytics-Ready Data

The Gold layer brings together the transformed datasets into a unified analytical structure.

**Key models:**
- `obt.sql` — One Big Table combining bookings, listings, and host information.
- `fact.sql` — SQL model for fact-oriented analytical modeling.
- `ephemeral/` — Intermediate transformation models.

The OBT combines booking transactions with property and host attributes to support analytical queries across multiple aspects of Airbnb activity.

---

## 🛠️ Technology Stack

| Technology | Purpose |
|------------|---------|
| AWS S3 | Cloud storage for raw CSV datasets |
| Snowflake | Cloud data warehousing and SQL processing |
| dbt Core | Data transformation and model management |
| SQL | Data manipulation, cleaning, and analytical modeling |
| Python | Development environment and tooling |
| uv | Python dependency and environment management |
| Jinja | Dynamic SQL generation and reusable logic |
| Git & GitHub | Source control and project management |
| VS Code | Development environment |

---

## 📊 Project Implementation

### 1. Data Ingestion

The project uses three Airbnb datasets:

- `bookings.csv`
- `hosts.csv`
- `listings.csv`

The CSV datasets are stored in Amazon S3 and loaded into Snowflake using an external stage.

SQL scripts define the database objects and resources needed to support ingestion.

The staging layer contains the source tables:

- `AIRBNB.STAGING.BOOKINGS`
- `AIRBNB.STAGING.HOSTS`
- `AIRBNB.STAGING.LISTINGS`

This stage demonstrates the integration of cloud object storage with a cloud data warehouse.

### 2. Data Transformation with dbt

dbt manages the transformation logic across the Bronze, Silver, and Gold layers.

The project uses SQL models, source definitions, Jinja templating, and custom macros to organize reusable transformations.

The Bronze and Silver layers implement incremental materializations, while the Gold layer combines transformed information into analytical datasets.

### 3. Incremental Data Processing

Incremental models were implemented to support processing newly arriving records using timestamp-based logic.

Rather than rebuilding entire datasets during every execution, incremental processing allows dbt to identify and process qualifying new records.

This approach demonstrates how recurring data pipelines can reduce unnecessary processing and maintain transformed datasets over time.

### 4. Reusable SQL Macros

Several custom dbt macros were implemented to support reusable transformation logic.

| Macro | Purpose |
|-------|---------|
| `multiply.sql` | Performs reusable arithmetic calculations |
| `tag.sql` | Categorizes numerical values |
| `trimmer.sql` | Supports string standardization |
| `generate_schema_name.sql` | Organizes dbt models into Snowflake schemas |

The project also uses Jinja loops to generate portions of analytical SQL dynamically.

### 5. Analytical Data Modeling

The Gold OBT combines data from the Silver layer through SQL joins.

The resulting dataset brings together:

**Booking Information**
- Booking identifiers and dates.
- Booking status.
- Financial amounts and fees.

**Listing Information**
- Listing identifiers and property types.
- Geographic information.
- Accommodation capacity.
- Room and bathroom counts.
- Nightly pricing and price categories.

**Host Information**
- Host profiles and registration dates.
- Superhost status.
- Response rates and quality classifications.
- Creation timestamps.

The Gold layer provides an integrated dataset that can support analytical exploration and future BI reporting.

### 6. Snapshots and Historical Data

The project includes a dbt snapshots directory for exploring Slowly Changing Dimension (SCD Type 2) concepts.

The snapshot implementation focuses on timestamp-based change tracking and preserving historical record versions.

This extends the project beyond basic transformations by introducing historical data modeling concepts.

### 7. Data Quality and Validation

The project incorporates dbt compilation, testing capabilities, and Snowflake query validation.

Validation activities include:

- Checking SQL and Jinja compilation.
- Verifying source and model dependencies.
- Inspecting transformation outputs.
- Reviewing schema and column consistency.
- Checking incremental model behavior.
- Exploring data quality tests and validation rules.

---

## 📁 Repository Structure

```text
Airbnb_Snowflake_DBT_Data_Engineer_Project/
│
├── DDL/
│   ├── ddl.sql
│   └── resources.sql
│
├── SourceData/
│   ├── bookings.csv
│   ├── hosts.csv
│   └── listings.csv
│
├── aws_dbt_snowflake_project/
│   │
│   ├── analyses/
│   │   ├── explore.sql
│   │   ├── if_else.sql
│   │   └── loop.sql
│   │
│   ├── macros/
│   │   ├── generate_schema_name.sql
│   │   ├── multiply.sql
│   │   ├── tag.sql
│   │   └── trimmer.sql
│   │
│   ├── models/
│   │   ├── bronze/
│   │   │   ├── bronze_bookings.sql
│   │   │   ├── bronze_hosts.sql
│   │   │   └── bronze_listings.sql
│   │   │
│   │   ├── silver/
│   │   │   ├── silver_bookings.sql
│   │   │   ├── silver_hosts.sql
│   │   │   └── silver_listings.sql
│   │   │
│   │   ├── gold/
│   │   │   ├── ephemeral/
│   │   │   ├── fact.sql
│   │   │   └── obt.sql
│   │   │
│   │   └── sources/
│   │       └── sources.yml
│   │
│   ├── snapshots/
│   ├── tests/
│   ├── dbt_project.yml
│   └── README.md
│
├── LICENSE
└── README.md
```

---

## 📈 Project Results

The pipeline successfully connects AWS S3, Snowflake, and dbt within a layered data engineering workflow.

### Transformation Results

During development, successful dbt executions processed:

| Dataset | Rows Processed |
|---------|---------------:|
| Silver Bookings | 5,000 |
| Silver Listings | 500 |
| Silver Hosts | 200 |

These figures represent records processed in the observed dbt runs, rather than benchmarks or guaranteed current table row counts.

### Key Outcomes

- Established a working AWS S3-to-Snowflake ingestion process.
- Developed Bronze, Silver, and Gold dbt transformation layers.
- Implemented incremental processing logic.
- Created reusable SQL macros for transformation tasks.
- Integrated multiple datasets into a Gold OBT.
- Worked with snapshot-based historical modeling concepts.
- Organized and published the project in GitHub.

---

## 💡 Technical Challenges and Lessons Learned

This project provided practical experience troubleshooting issues commonly encountered during data pipeline development.

### Cloud Storage and Warehouse Integration

Configured an Amazon S3 external stage and resolved AWS access-related errors when connecting Snowflake to source data.

Learned how object storage, Snowflake warehouse compute, and cloud permissions interact.

### Environment and Dependency Management

Set up a Python virtual environment and installed dbt using uv.

Resolved Windows PATH configuration, PowerShell execution policy, and virtual environment issues.

### Snowflake Authentication

Configured and validated dbt's Snowflake connection using `dbt debug`.

Troubleshot authentication and profile configuration issues before successfully connecting the transformation environment.

### SQL and Jinja Debugging

Resolved compilation errors involving SQL syntax, missing columns, Jinja macros, and model references.

Gained experience using database error messages and compiled SQL to locate problems in transformations.

### Incremental Models and Dependencies

Identified circular dependencies caused by self-referencing dbt models and corrected incremental processing logic.

Improved understanding of dbt model dependencies, materialization strategies, and rebuild behavior.

### Data Modeling and Schema Consistency

Resolved mismatches between Bronze, Silver, and Gold models, including missing timestamp columns needed by downstream analytical datasets.

Learned the importance of validating upstream schemas and downstream dependencies.

---

## 🎯 Skills Demonstrated

- Cloud data engineering with AWS and Snowflake.
- Data ingestion from object storage.
- SQL-based ELT pipeline development.
- Medallion Architecture.
- Incremental data processing.
- Data cleaning and standardization.
- Analytical data modeling.
- dbt Core and Jinja templating.
- Reusable SQL macro development.
- Data lineage and model dependency management.
- Historical data modeling concepts.
- GitHub version control.
- Pipeline troubleshooting and validation.

---

## 🚀 Future Improvements

- [ ] Develop a Power BI dashboard using the Gold OBT.
- [ ] Expand automated dbt tests and data quality coverage.
- [ ] Implement automated pipeline scheduling.
- [ ] Add CI/CD workflows using GitHub Actions.
- [ ] Introduce monitoring and error notifications.
- [ ] Optimize incremental loading and transformation performance.
- [ ] Expand analytical metrics and reporting capabilities.
- [ ] Improve model dependencies using dbt `ref()` relationships.

---

## 📄 License

This repository includes an MIT License. See the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 About Me

Hi! I'm **Simon Yang**, an undergraduate student at the **University of North Carolina at Chapel Hill**, with an interest in data engineering, cloud computing, and data analytics.

I enjoy developing hands-on projects that allow me to apply technical concepts to practical data problems.

Through projects like this, I'm expanding my experience with SQL, Python, cloud data platforms, and modern data pipeline development as I prepare for a career in data engineering.

### Connect With Me

- **LinkedIn:** [Simon Yang](https://www.linkedin.com/in/simon-yang-a5211535a/)
- **Handshake:** [My Handshake Profile](https://app.joinhandshake.com/profiles/ztjfa4)

---

*This repository is part of my personal data engineering portfolio.*
