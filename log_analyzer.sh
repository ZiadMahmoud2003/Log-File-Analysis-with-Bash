#!/bin/bash

LOG_FILE="apache_logs.txt"
REPORT="log_analysis_report.txt"
TMP_DIR=$(mktemp -d)

# Initialize report
{
echo "Log Analysis Report"
echo "==================="
echo "Date: $(date)"
} > "$REPORT"

# 1. Request Counts
total_requests=$(wc -l < "$LOG_FILE")
get_requests=$(grep -c '"GET' "$LOG_FILE")
post_requests=$(grep -c '"POST' "$LOG_FILE")

{
echo -e "\n1. Request Counts"
echo "------------------"
echo "Total requests: $total_requests"
echo "GET requests: $get_requests"
echo "POST requests: $post_requests"
} >> "$REPORT"

# 2. Unique IP Addresses
awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr > "$TMP_DIR/ip_counts.txt"
unique_ips=$(wc -l < "$TMP_DIR/ip_counts.txt")

{
echo -e "\n2. Unique IP Analysis"
echo "------------------------"
echo "Unique IP addresses: $unique_ips"
echo -e "\nTop 5 IPs by request volume:"
head -5 "$TMP_DIR/ip_counts.txt"

echo -e "\nTop IPs and GET/POST count:"
awk '{ip=$1} $6 ~ /GET/ {get[ip]++} $6 ~ /POST/ {post[ip]++}
     END {
         for (i in get) {
             printf "%-16s GET: %-5d POST: %-5d\n", i, get[i], post[i]+0
         }
     }' "$LOG_FILE" | sort -k3 -nr | head -5
} >> "$REPORT"

# 3. Failure Requests
failures=$(awk '$9 ~ /^[45]/ {count++} END {print count}' "$LOG_FILE")
failure_percent=$(awk -v f="$failures" -v t="$total_requests" 'BEGIN {printf "%.2f", (f/t)*100}')

{
echo -e "\n3. Failure Requests"
echo "---------------------"
echo "Failed requests (4xx/5xx): $failures"
echo "Failure percentage: $failure_percent%"
} >> "$REPORT"

# 4. Most Active IP
most_active_ip=$(awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -1 | awk '{print $2}')

{
echo -e "\n4. Most Active IP"
echo "-------------------"
echo "IP Address: $most_active_ip"
} >> "$REPORT"

# 5. Daily Request Averages
awk -F'[:[]' '{print $2}' "$LOG_FILE" | awk '{print $1}' | sort | uniq -c > "$TMP_DIR/daily_counts.txt"
total_days=$(wc -l < "$TMP_DIR/daily_counts.txt")
daily_avg=$(awk '{sum+=$1} END {printf "%.2f", sum/NR}' "$TMP_DIR/daily_counts.txt")

{
echo -e "\n5. Daily Request Averages"
echo "---------------------------"
echo "Total days: $total_days"
echo "Average requests/day: $daily_avg"
} >> "$REPORT"

# 6. Failure Analysis by Day
awk '$9 ~ /^[45]/ {print substr($4,2,11)}' "$LOG_FILE" | sort | uniq -c | sort -nr > "$TMP_DIR/fail_by_day.txt"

{
echo -e "\n6. Days with Most Failures"
echo "----------------------------"
head -5 "$TMP_DIR/fail_by_day.txt"
} >> "$REPORT"

# 7. Requests by Hour
{
echo -e "\n7. Requests by Hour"
echo "----------------------"
awk -F: '{print $2}' "$LOG_FILE" | sort | uniq -c | sort -n
} >> "$REPORT"

# 8. Status Code Breakdown
{
echo -e "\n8. Status Code Breakdown"
echo "---------------------------"
awk '{print $9}' "$LOG_FILE" | sort | grep -E '^[0-9]{3}$' | uniq -c | sort -nr
} >> "$REPORT"

# 9. Most Active IPs by Method
{
echo -e "\n9. Most Active IPs by Method"
echo "------------------------------"
awk '{ip=$1; method=$6}
      method ~ /GET/ {get[ip]++}
      method ~ /POST/ {post[ip]++}
      END {
        for (ip in get) {
          printf "%-16s GET: %-5d POST: %-5d\n", ip, get[ip], post[ip]+0
        }
      }' "$LOG_FILE" | sort -k3 -nr | head -10
} >> "$REPORT"

# 10. Failure Patterns by Hour
{
echo -e "\n10. Failure Patterns by Hour"
echo "------------------------------"
awk '$9 ~ /^[45]/ {split($4,time,":"); print time[2]}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -10
} >> "$REPORT"

# 11. Recommendations
{
echo -e "\n11. Analysis Recommendations"
echo "-------------------------------"
echo "1. Reduce broken links to lower 404s."
echo "2. Set up IP rate limiting for top users."
echo "3. Scale infrastructure for peak hours (14:00–20:00)."
echo "4. Audit server for rare but present 500 errors."
echo "5. Consider bots and crawlers—check robots.txt."
} >> "$REPORT"

# Cleanup
rm -r "$TMP_DIR"

echo "✅ Analysis complete. Report saved to: $REPORT"

