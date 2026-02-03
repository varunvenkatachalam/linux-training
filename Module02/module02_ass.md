# Linux Module 02 Assignment

## 1. List all files larger than 1 MB in the current directory and save the output to a file

### Command
```bash
find . -maxdepth 1 -type f -size +1M > large_files.txt
```

## 2. Replace all occurrences of "localhost" with "127.0.0.1" in a configuration file

### Command
```bash
sed 's/localhost/127.0.0.1/g' config.txt > updated_config.txt
```

##3. Search for lines containing "ERROR" but exclude lines containing "DEBUG"

### Command
```bash
grep "ERROR" log.txt | grep -v "DEBUG" > filtered_log.txt
```

## 4. Identify the process with the highest memory usage and terminate it

### Command
```bash
ps aux --sort=-%mem | head -n 2

kill -9 <PID>
```

## 5. Display all available gateways in sorted order

### Command
```bash
ip route | awk '/default/ {print $3}' | sort -u
```
