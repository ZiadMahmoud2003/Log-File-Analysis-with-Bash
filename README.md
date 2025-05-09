````markdown
# 📊 Log File Analysis with Bash

This project performs a detailed analysis of Apache server log files using a custom Bash script. It generates a comprehensive report including request patterns, failure trends, and system insights to aid in performance tuning, debugging, and monitoring.

---

## 📁 Project Structure

| File | Description |
|------|-------------|
| `log_analyzer.sh` | Bash script that parses and analyzes the Apache log file |
| `apache_logs.txt` | Sample log file used as input |
| `apache_log_analysis_final_report.pdf` | Final professional report generated from the analysis |

---

## 🧠 Objectives

This project helps in:
- Understanding web traffic behavior
- Identifying failure patterns (4xx, 5xx errors)
- Analyzing peak usage hours
- Recognizing security anomalies (e.g., IP overuse)
- Offering actionable recommendations based on real server data

---

## 📌 Features

- ✅ Count total, GET, and POST requests
- ✅ List unique IPs and breakdown by request method
- ✅ Calculate daily request averages
- ✅ Analyze request distribution by hour
- ✅ Highlight status code frequencies
- ✅ Detect days and hours with high failure rates
- ✅ Identify top requesting IPs
- ✅ Include a professional Word-formatted report

---

## 🛠️ How to Use

1. **Prepare your environment**
   ```bash
   chmod +x log_analyzer.sh
````

2. **Run the script**

   ```bash
   ./log_analyzer.sh
   ```

3. **Output**

   * Generates `log_analysis_report.txt` in the current directory
   * Includes counts, breakdowns, and insights

---

## 📊 Sample Insights

* Most requests are **GET** requests (>99%)
* A few IP addresses dominate traffic (likely bots/crawlers)
* Majority of failures are **404 Not Found**
* Peak traffic occurs between **14:00 and 20:00**
* Low number of **500 errors**, indicating stable server

---

## 💡 Recommendations

* Fix broken URLs to reduce 404 errors
* Implement rate limiting for heavy users
* Monitor activity during peak hours
* Consider integrating monitoring (e.g., Prometheus, Grafana)
* Audit server logs for suspicious activity





