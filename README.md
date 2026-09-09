# Hospital Appointment No-Show Analysis

A PostgreSQL portfolio project analyzing patient appointment data to understand
what drives no-shows - SMS reminders, waiting time before the appointment,
patient age, and gender.

## Overview

The dataset tracks hospital appointments with scheduling and appointment
dates, patient demographics, whether an SMS reminder was sent, and whether
the patient showed up. `lead_time_days` (days between scheduling and the
appointment) is stored as a generated column, computed automatically from
`appointment_day - scheduled_day`.

## Schema

**`appointments`**

| Column           | Type         | Notes                                  |
|------------------|--------------|-----------------------------------------|
| appointment_id   | INTEGER      | Primary key                             |
| gender           | CHAR(1)      | 'M' or 'F'                              |
| scheduled_day    | DATE         | Date the appointment was booked         |
| appointment_day  | DATE         | Date of the actual appointment          |
| age              | SMALLINT     | Patient age, >= 0                       |
| sms_received     | SMALLINT     | 0 or 1                                  |
| lead_time_days   | SMALLINT     | Generated: `appointment_day - scheduled_day` |
| no_show          | VARCHAR(3)   | 'Yes' or 'No'                           |

Indexes on `no_show` and `sms_received` speed up the group-by queries below.

## Analysis Questions

| # | Question |
|---|----------|
| Q1 | What is the overall no-show rate? |
| Q2 | Does receiving an SMS reminder change the no-show rate? |
| Q3 | Does longer waiting time (lead time) increase no-shows? |
| Q4 | Which age group has the highest no-show rate? |
| Q5 | Within each gender, how do patients rank by waiting time? (window function) |

## How to Run

1. Create a PostgreSQL database and connect to it.
2. Run the script top to bottom:
   ```bash
   psql -d your_database -f Hospital_Appointment_No_Show_Project.sql
   ```
3. Load appointment data into the `appointments` table (not included in this
   script - bring your own CSV/dataset with matching columns, excluding
   `lead_time_days`, which is computed automatically).
4. Each `-- Qn.` query can be run independently once data is loaded.

## Notes

- `lead_time_days` is a generated column, so never insert a value for it
  directly - Postgres derives it from the two date columns.
- Q3 excludes rows where `lead_time_days` is NULL to keep bucket counts
  accurate.
- Q5 breaks ties in `lead_time_days` by `appointment_id` for a stable rank.
