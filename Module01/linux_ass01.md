# Linux Module 1 Assessment

## Question 1
### Create a file and add executable permission to all users

```bash
touch q1_file
chmod 777 q1_file
ls -l q1_file
```

## Question 2
### Create a file and remove write permission for group user alone

```bash
touch q2_file
chmod g-w q2_file
ls -l q2_file
```

## Question 3
### Create a file and add a soft link to the file in a different directory

```bash
mkdir -p dir1/dir2
touch dir1/dir2/q3_file
ln -s dir1/dir2/q3_file dir1/file_softlink
ls -l dir1
```

## Question 4
### Display all active processes running on the system

```bash
ps -ef
```

## Question 5
### Create 3 files and redirect the output of list command sorted by timestamp to a file

```bash
mkdir dir_files
cd dir_files
touch file1
sleep 1
touch file2
sleep 1
touch file3
ls -lt > sorted_files.txt
cat sorted_files.txt
```
