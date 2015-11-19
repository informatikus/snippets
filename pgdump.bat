@echo off
   set PATH_TO_POSTGRES="c:\Program Files\PostgreSQL\9.4"
   set PATH_TO_BACKUP="D:\backup"
   set DATABASE="confluence"
   set BACKUP_NAME=focuspro_%date%.backup
   
   echo backup file name is %BACKUP_NAME%
   echo on
   %PATH_TO_POSTGRES%\bin\pg_dump -i -h localhost -p 5432 -U postgres -F c -b -v -f %PATH_TO_BACKUP%\%BACKUP_NAME% %DATABASE%
