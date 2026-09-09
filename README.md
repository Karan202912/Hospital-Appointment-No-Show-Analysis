# Hospital Appointment No-Show Analysis

A PostgreSQL project where I analyzed hospital appointment data to understand why some patients do not show up for their appointments.

The analysis looks at factors such as SMS reminders, waiting time, age, and gender.

## About the Project

The dataset contains information about hospital appointments, including when the appointment was scheduled, the actual appointment date, patient age and gender, whether an SMS reminder was received, and whether the patient showed up.

I also used a generated column called `lead_time_days` to calculate the number of days between the scheduled date and the appointment date.

## Table Used

The project uses one main table:

### `appointments`

| Column          | Type       | Description                          |
| --------------- | ---------- | ------------------------------------ |
| appointment_id  | INTEGER    | Primary key                          |
| gender          | CHAR(1)    | M or F                               |
| scheduled_day   | DATE       | Date when the appointment was booked |
| appointment_day | DATE       | Date of the appointment              |
| age             | SMALLINT   | Patient age                          |
| sms_received    | SMALLINT   | 0 or 1                               |
| lead_time_days  | SMALLINT   | Number of days between the two dates |
| no_show         | VARCHAR(3) | Yes or No                            |

The `lead_time_days` column is generated automatically from:

`appointment_day - scheduled_day`

Indexes were also added on `no_show` and `sms_received`.

## Analysis Questions

I used SQL to answer these questions:

| #  | Question                                                  |
| -- | --------------------------------------------------------- |
| Q1 | What is the overall no-show rate?                         |
| Q2 | Does receiving an SMS reminder affect the no-show rate?   |
| Q3 | Does longer waiting time increase no-shows?               |
| Q4 | Which age group has the highest no-show rate?             |
| Q5 | Within each gender, how do patients rank by waiting time? |

Q5 uses a SQL window function.

## SQL Concepts Used

* GROUP BY
* COUNT
* CASE WHEN
* Aggregate functions
* Indexes
* Generated columns
* Window functions
* RANK()
* Date calculations

## How to Run

1. Create a PostgreSQL database.
2. Connect to the database using pgAdmin or another PostgreSQL client.
3. Run the SQL script from top to bottom.
4. Load the appointment data into the `appointments` table.
5. Run the Q1 to Q5 queries to see the analysis results.

The CSV dataset is not included with the SQL script. The CSV should contain the matching columns except `lead_time_days`, since PostgreSQL calculates that column automatically.

## Notes

* Do not insert a value manually into `lead_time_days`.
* PostgreSQL calculates `lead_time_days` using the scheduled and appointment dates.
* Q3 ignores rows where `lead_time_days` is NULL.
* Q5 uses `appointment_id` to break ties when patients have the same waiting time.

## Project Goal

The main purpose of this project was to practice PostgreSQL and use SQL to analyze a real-world type of dataset.

It also helped me understand how appointment data can be used to find patterns in patient no-shows.
