# 🌦️ Weather Forecast Accuracy Pipeline

---

## ✅ Project Status
This project is fully functional, tested and suitable for automation with cron.  
Open for future improvements.

---

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
├── rx_poc.sh                           ← daily weather collector
├── fc_accuracy.sh                      ← forecast accuracy calculator
├── weekly_stats.sh                     ← weekly accuracy summary
├── backup_data.sh                      ← backup utility
│
├── rx_poc.log                          ← daily appended log (generated)
├── historical_fc_accuracy_full.tsv     ← full accuracy dataset (generated)
├── weekly_summary.tsv                  ← weekly summary (generated)
│
├── synthetic_historical_fc_accuracy.tsv ← sample dataset for testing
├── weather_report                      ← raw HTML from wttr.in (temp file)
│
├── backups/                            ← auto-generated tar.gz archives
│
└── README.md                           ← documentation
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

### 1️⃣ rx_poc.sh — Data Collection Script

- Fetches weather for a specific city using **wttr.in**
- Extracts observed temperature  
- Extracts forecasted temperature for next-day noon  
- Appends a formatted row to **rx_poc.log**

**Sample output log:**
```
year    month   day     obs_temp    fc_temp
2025    11      15      23          19
```

### 2️⃣ fc_accuracy.sh — Daily Forecast Accuracy

This script:

- Reads **rx_poc.log**
- Compares each day's forecast with the actual next-day observation
- Computes **signed** and **absolute** accuracy
- Writes the results into **historical_fc_accuracy_full.tsv**

**Columns:**
```
year month day today_temp yesterday_fc accuracy accuracy_range
```


---

### 3️⃣ weekly_stats.sh — Weekly Summary

- Uses the last **7 forecast accuracy values**
- Converts them to **absolute errors**
- Finds the **minimum** and **maximum**
- Saves results into **weekly_summary.tsv**

**Example:**
```
metric value
min_abs_error 1
max_abs_error 4
```

---

### 4️⃣ backup_data.sh — Backup System

Creates a timestamped archive:
```bash
backups/data_backup_20251115_124530.tar.gz
```


**The backup contains:**

- `rx_poc.log`
- `historical_fc_accuracy_full.tsv`
- `weekly_summary.tsv`

## 🔄 Automating the Pipeline with Cron

You can run each step automatically using **cron**.

---

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
## 📦 Checking Backups

### List all existing backups:

```bash
ls -lh backups/
```
### Inspect a specific archive:

```bash
tar -tf backups/data_backup_YYYYMMDD_HHMMSS.tar.gz
```
Example:
- rx_poc.log
- historical_fc_accuracy_full.tsv
- weekly_summary.tsv

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
   +----------------------+
   |   rx_poc.log         |
   +----------------------+
             |
     +------------------+
     | fc_accuracy.sh   |
     +------------------+
             |
 writes full accuracy history
             v
   historical_fc_accuracy_full.tsv
             |
     +-------------------+
     | weekly_stats.sh   |
     +-------------------+
             |
     weekly_summary.tsv
             |
     +------------------+
     | backup_data.sh   |
     +------------------+
             |
       backup .tar.gz
```
🚀 How to Run Manually
```
./rx_poc.sh
./fc_accuracy.sh
./weekly_stats.sh
./backup_data.sh
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

