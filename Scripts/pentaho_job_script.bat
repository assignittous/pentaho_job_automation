REM Runs the Master Pentaho Job (kjb) and writes the log to a file (Master_Job.log)
REM Created by Assign It To Us Jan 1, 2018


cd "/Program Files (x86)/Pentaho/data-integration"

kitchen.bat /rep:dw_repo_f /file:C:\Cognos\ETL\Pentaho_Repo\Backup_File_Mgmt\Master_Job.kjb /level:Basic > C:\Cognos\ETL\logs\Master_Job.log