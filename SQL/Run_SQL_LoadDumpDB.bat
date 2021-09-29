cd .\SQL_LoadDumpDB
exit | sqlplus -S sys as sysdba/0@orcl @Scripts\Create_STUDENT_DB.sql
echo "STUDENT_DB IS CREATED, PRESS KEY TO PREPARE FOR DATA LOAD"
pause
sqlldr STUDENT_DB/0 control=./FACULTIES.ctl
sqlldr STUDENT_DB/0 control=./STUDENT.ctl
sqlldr STUDENT_DB/0 control=./TEST.ctl
sqlldr STUDENT_DB/0 control=./STUDENT_TEST.ctl
echo "STUDENT_DB IS LOADED, PRESS KEY TO PREPARE FOR DATA PRINT"
pause
exit | sqlplus -S STUDENT_DB/0@orcl @Scripts\Select_STUDENT_DB.sql
echo "STUDENT_DB IS PRINTED, PRESS KEY TO PREPARE FOR DATA EXPORT"
pause
cls
if exist C:\Oracle\admin\orcl\dpdump\STUDENT_DB.DMP del C:\Oracle\admin\orcl\dpdump\STUDENT_DB.DMP /q /s
expdp \"STUDENT_DB/0@orcl AS SYSDBA\" SCHEMAS=STUDENT_DB DIRECTORY=DATA_PUMP_DIR DUMPFILE=STUDENT_DB.dmp
echo "DATABASE IS EXPORTED, PRESS KEY TO PREPARE FOR DATA IMPORT"
pause
exit | sqlplus -S sys as sysdba/0@orcl @Scripts\Drop_STUDENT_DB.sql
echo "STUDENT_DB IS DROPPED"
impdp \"SYS/0@orcl AS SYSDBA\" SCHEMAS=STUDENT_DB DIRECTORY=DATA_PUMP_DIR DUMPFILE=STUDENT_DB.dmp
echo "DATABASE IS IMPORTED, PRESS KEY FOR EXIT PROGRAM"
pause