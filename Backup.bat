@REM Change PGPASSFILE to match location in filesystem/Set up pgpass.conf if necessary
@REM Change FOLDER to location where backups are being made
@REM Change TABLE to appropriate table
@REM Change HOST, PORT, USER, and DATABASE to match postgres login
@REM Change RECIPIENT to appropriate UID

@REM Set to location of pgpass file
set PGPASSFILE=E:\Warkah\Documents\Brooklyn College\Graduate\CISC 7510X - Database Systems\pgpass.conf

@REM Temporary outputfile location
set FOLDER=C:\Users\Warkah\Desktop\
set OUTFILE=%FOLDER%outfile

@REM Command for table to be copied
set TABLE=dividends
set COMMAND="\copy (SELECT * FROM %TABLE%) to %OUTFILE% with csv"

@REM Gets current timestamp
For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set DATEPART=%%c-%%a-%%b)
For /f "tokens=1-2 delims=/: " %%a in ("%TIME%") do (if %%a LSS 10 (set TIMEPART=0%%a%%b) else (set TIMEPART=%%a%%b))
set TIMENOW=%DATEPART%_%TIMEPART%

@REM Filename with timestamp
set FINAL=%TIMENOW%_%TABLE%.csv

@REM Login information for postgres server
set HOST=localhost
set PORT=5432
set USER=warkahs
set DATABASE=cisc7510

@REM Login into postgres server
psql -h %HOST% -p %PORT% -U %USER% -d %DATABASE% -w -c %COMMAND%

@REM Rename to csv
set BACKUP=%FOLDER%%FINAL%
mv %OUTFILE% %BACKUP%

@REM GZIP file
gzip %BACKUP% 

set RECIPIENT='Warkah Scott'
@REM encrypt file
gpg -r %RECIPIENT% -o %BACKUP%2.gz -e %BACKUP%.gz
rm %BACKUP%.gz
mv %BACKUP%2.gz %BACKUP%.gz
