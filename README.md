# 🌦️ Weather Forecast Accuracy Pipeline
![Bash](https://img.shields.io/badge/Bash-Scripts-121011?logo=gnu-bash&logoColor=white)
![Status](https://img.shields.io/badge/Status-Tested%20Successfully-brightgreen)
![Cron](https://img.shields.io/badge/Cron-Automated-blue)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)


## ✅ Project Status
This project is fully functional, tested and suitable for automation with cron.  
Open for future improvements.

## 📌 Project Overview

This project is a small end-to-end **data pipeline in pure Bash** that:

- Collects real weather data from **wttr.in**
- Stores daily observations and forecasts in **rx_poc.log**
- Computes forecast accuracy day-by-day
- Aggregates weekly accuracy statistics
- Creates timestamped backups of key project files
- Can run automatically via **cron**

It demonstrates Bash scripting, data processing, automation and lightweight ETL logic **without Python or external dependencies**.

## 📂 Project Structure

```text
weather-forecast-accuracy/
├── rx_poc.sh                             ← daily weather collector
├── fc_accuracy.sh                        ← forecast accuracy calculator
├── weekly_stats.sh                       ← weekly accuracy summary
├── backup_data.sh                        ← backup utility
│
├── rx_poc.log                            ← daily appended log (generated)
├── historical_fc_accuracy_full.tsv       ← full accuracy dataset (generated)
├── weekly_summary.tsv                    ← weekly summary (generated)
│
├── synthetic_historical_fc_accuracy.tsv  ← sample dataset for testing
├── weather_report                        ← raw HTML from wttr.in (temp file)
│
├── backups/                              ← auto-generated tar.gz archives
│
└── README.md                             ← documentation
```

## 🛠️ Skills & Tools

- **Bash scripting** — text parsing, arrays, loops, error handling  
- **curl** — external API calls (weather data)  
- **grep / awk / cut** — extracting numeric values  
- **tar & gzip** — automated backups  
- **cron** — pipeline automation  
- **Linux CLI** — lightweight ETL design  

---

## 📜 Script Descriptions

### Before first run (important!)

Before running any script, make all .sh files executable:

**In the terminal, run:**
```bash
ls
```
**Then make all Bash scripts executable:**
```bash
chmod +x *.sh
```
After this, all scripts can be executed normally using ./script_name.sh


### 1️⃣ rx_poc.sh — Data Collection Script

- Fetches weather for a specific city using **wttr.in**
- Extracts observed temperature  
- Extracts forecasted temperature for next-day noon  
- Appends a formatted row to **rx_poc.log**

**How to run:**
```bash
./rx_poc.sh
```

**Real example output (from test run):**
```bash
The current Temperature of Casablanca: 21
The forecasted temperature for noon tomorrow for Casablanca : 19 C
```
**Check what was written to the log:**
```bash
cat rx_poc.log
```
**Written to rx_poc.log:**
```
year    month   day     obs_temp    fc_temp
2025    11      15      23          19
```

---

### 2️⃣ fc_accuracy.sh — Daily Forecast Accuracy

This script:

- Reads **rx_poc.log**
- Compares each day's forecast with the actual next-day observation
- Computes **signed** and **absolute** accuracy
- Writes the results into **historical_fc_accuracy_full.tsv**

**How to run:**
```bash
./fc_accuracy.sh
```

**Real example output (from test run):**
```
year    month   day   today_temp   yesterday_fc   accuracy   accuracy_range
2025    11      15    23           19             -4         poor
```
**Check what was written to the log:**
```bash
cat historical_fc_accuracy_full.tsv
```
**Written to historical_fc_accuracy_full.tsv:**
```
year    month   day   today_temp   yesterday_fc   accuracy   accuracy_range
2025    11      15    23           19             -4         poor
```

---

### 3️⃣ weekly_stats.sh — Weekly Summary
- Uses the last **7 forecast accuracy values**
- Converts them to **absolute errors**
- Finds the **minimum** and **maximum**
- Saves results into **weekly_summary.tsv**

**How to run:**
```bash
./weekly_stats.sh
```
**Real example output (from test run):**
```bash
Raw accuracy values (last 7 days):
-5
-1
-2
4
-2
0
1

Absolute accuracy values:
5
1
2
4
2
0
1

minimum absolute error = 0
maximum absolute error = 5
```
**Check what was written to the log:**
```bash
cat weekly_summary.tsv
```
**Written to weekly_summary.tsv:**
```
 metric          value
 min_abs_error   0
 max_abs_error   5
```
---

### 4️⃣ backup_data.sh — Backup System
- Creates a timestamped compressed archive inside the **backups/** directory
- Includes key pipeline output files (`rx_poc.log`, accuracy and weekly stats)
- Ensures safe archiving and historical retention of data
**How to run:**
```bash
./backup_data.sh
```
**Real example output (from test run):**
```bash
Backup created: backups/data_backup_20251115_191059.tar.gz
```
**List all existing backups:**
```bash
ls -lh backups/
```
**Real example:**
```
-rw-rw-r-- 1 codespace codespace 299 Nov 15 19:10 data_backup_20251115_191059.tar.gz
```
**Inspect backup contents:**
```bash
tar -tf backups/data_backup_*.tar.gz
```
**The backup contains:**
- `rx_poc.log`
- `historical_fc_accuracy_full.tsv`
- `weekly_summary.tsv`

---

## 🔄 Automating the Pipeline with Cron

You can run each step automatically using **cron**.

### 1️⃣ Open your crontab:

```bash
crontab -e
```
### 2️⃣ Add the following scheduled jobs:

#### 📌 Daily data collection

```bash
0 6 * * * /home/username/weather-project/rx_poc.sh
```
#### 📌 Daily forecast accuracy calculation

```bash
2 6 * * * /home/username/weather-project/fc_accuracy.sh
```
#### 📌 Weekly: compute weekly statistics

```bash
5 6 * * 0 /home/username/weather-project/weekly_stats.sh
```
#### 📌 Weekly: create backup archive

```bash
10 6 * * 0 /home/username/weather-project/backup_data.sh
```
### 3️⃣ Verify installed cron jobs:

```bash
crontab -l
```

---

## 📊 Data Flow Diagram
```
      [wttr.in API]
             |
             v
     +-----------------+
     |   rx_poc.sh     |
     +-----------------+
             |
      writes daily log
             v
     +-----------------+
     |   rx_poc.log    |
     +-----------------+
             |
     +-----------------+
     | fc_accuracy.sh  |
     +-----------------+
             |
   writes full accuracy history
             v
   historical_fc_accuracy_full.tsv
             |
     +-----------------+
     | weekly_stats.sh |
     +-----------------+
             |
     weekly_summary.tsv
             |
     +------------------+
     | backup_data.sh   |
     +------------------+
             |
       backup .tar.gz
```

📝 Summary

 - Fully automated weather forecast accuracy pipeline
 - Pure Bash + Linux tools
 - Daily and weekly ETL steps
 - Automated backup archiving
 - Cron-ready, portable, dependency-free
 - Great demonstration of scripting, automation and CLI data engineering

## 👩‍💻 Author
**Palina Krasiuk**  
Aspiring Cloud Data Engineer | ex-Senior Accountant  

[LinkedIn](https://www.linkedin.com/in/palina-krasiuk-954403472/) • [GitHub Portfolio](https://github.com/CloudDataPalina)

