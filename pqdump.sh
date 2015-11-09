echo Cleanup and backup up ALL databases

ls -t *_all.sql | sed -e "1,7d" | xargs -I {} rm {}
pg_dumpall > `date +\%Y-\%m-\%d_\%H\%M\%S`_all.sql

