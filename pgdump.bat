@echo off
   set BACKUP_FILE=focuspro_%date%.backup
   echo backup file name is %BACKUP_FILE%
   echo on
   bin\pg_dump -i -h localhost -p 5432 -U postgres -F c -b -v -f %BACKUP_FILE% confluence
