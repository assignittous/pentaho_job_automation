# Pentaho Job Schedule Automation
## Overview

What this ETL tracker is:  It's a high-level tool that monitors all the jobs run against your task scheduling tool and notifies the administrator when jobs don't run on their expected schedule.


## How it Works
There are 4 components used to track the jobs:

#### 1. Schedule the Pentaho job in the Microsoft Task Scheduler or cron job if you're using a Unix based OS.

The scheduled job will call a batch script that runs a Pentaho job.

![Task Scheduler](https://i2.wp.com/assignittous.com/wp-content/uploads/2018/01/ps_task_scheduler.png?resize=728%2C415&ssl=1)



The script that runs the Pentaho Job.  Basic logging is written to the Master_Job.log file

	cd "/Program Files (x86)/Pentaho/data-integration"

	kitchen.bat /rep:dw_repo_f /file:C:\Cognos\ETL\Pentaho_Repo\Backup_File_Mgmt\Master_Job.kjb /level:Basic > C:\Cognos\ETL\logs\Master_Job.log


#### 2. Add the ETL Job Log step to the end of each job flow. 

This step will add a timestamp for each run to the target ETL_Job_Log table.

![ETL Job Log](https://i2.wp.com/assignittous.com/wp-content/uploads/2018/01/ps_runtime_log_2.png?resize=792%2C224&ssl=1)


**ETL Job Log steps:**

![ETL Job Log Steps](https://i0.wp.com/assignittous.com/wp-content/uploads/2018/01/ps_timestamp.png?resize=591%2C167&ssl=1)

1. Get System data - sets the system date (current date/time) for the StartTime field.
2. Add Constants. Manual values set for the JobID and JobName.
3. Set Values
4. Table Output - JobCheck_Log - Creates and populates the ETL_Job_Log table.  Each job run timestamp is appended to the table.  We can see that there are jobs that run daily, monthly (Marketing_List_Data_Load) and hourly (Master_Conflicts_Check_Load).

![ETL Job Log Output](https://i1.wp.com/assignittous.com/wp-content/uploads/2018/01/ps_etl_log_output.png?resize=390%2C288&ssl=1)


#### 3. Run the Schedule_Job_Check to record the daily schedule info for each job.

This job is scheduled to run every 15 minutes and creates one record for each job showing the last time it was run.  The output targets an Excel file or to a data warehouse table that we can report on.  In our case, we do both.

**Schedule Job Check steps:**

![ETL Schedule Job Steps](https://i1.wp.com/assignittous.com/wp-content/uploads/2018/01/ps_job_run_check.png?resize=1265%2C451&ssl=1)



1. Add Constant Rows - Schedule - Defines the constants for each job.  The JobID and JobName will match each respective record from the ETL_Job_Log table. The frequency runtime and day are set to match the settings in the task scheduler. The RuntimeMinutes is set to match the runtime in minutes and the tolerance is set in minutes to match the time between scheduled runs.  These fields are needed for calcs further down the transformation flow.
2. Table Input - ETL Job Log - This is input from previous timestamp component.  SQL is run on the table and returns the latest record max("StartTime") for each JobID.
3. Merge Join - Steps 1 & 2 are joined on JobID
4. Select values
5. Get System Info - Here we set the current run DateTime, today, first day of week and first day of month. For the last 3 fields, we use the calc that sets the time to 00:00:00.  Later downstream, we'll add the day and minutes to define the scheduled run date to match what was set in our task scheduler.
6. Formula - Sets the period start for each job record.
7. Calculator - Add Runtime Minutes -  There are 2 calcs defined.  The first calc adds the period start defined in the previous step and the RuntimeMinutes set in the first step. This does the final calc that defines the expected job scheduled run datetime.  The second calc shows the time difference in minutes between the current date and the last run time.  We'll use this as one of the checks to see if the schedule if running late.
8. Calculator - Rundiff - This shows the difference in minutes between the LastRunTime and the ScheduleRunDateTime that was calculated in the previous step. The RunDiff is our second check to see if the scheduled run has failed.
9. Select Values - Rename and set values for fields
10. Formula - Email Config - This step defines all the settings for our end notifications.  It also has a calculation that looks at our 2 check fields and sets the job with a status of pass or fail.  We use an OR for the logical expression.  Here is the formula - IF(OR([RunDiff]<0;[TimeDiff]>[Tolerance]);"FAIL";"PASS")
11. Formula - Email Message - Creates the custom text message for the notification.
12. Select Values - Update metadata.  The flow splits into 2 outputs and 1 notification flow.  Data is written to the ETL_Schedule_Log table in our data warehouse and an excel file for reporting purposes. A screenshot of the table is shown at the end this section.
13. The notifications steps first look whether the job has a status of Pass or Fail.  If it Passed, nothing is done for that record.  If it Failed, it moves to the next step "Case Email?", which checks the email flag.  If the flag is set to "N" then nothing is done otherwise it moves to the last step "Mail" and sends out a notification with all the parameter settings from the "Email Config" step.  For our purpose, we had mission-critical jobs that ran every 1/2 hour and we needed to have a way to track those individual jobs whenever they failed.

![ETL Schedule Job Output](https://i2.wp.com/assignittous.com/wp-content/uploads/2018/01/scheduler_output.png?resize=1411%2C175&ssl=1)

#### 4. Email/View the ETL Job Run Status report.

A Cognos report was created with exception highlighting on the status field so that any jobs that failed would stick out.  In our case, we scheduled this job to run at 8:00 am each morning after all the morning scheduled tasks have run.  You could also create the same report using the excel file or the OXI MS XML injector from our open source toolbox.

![ETL Job Report](https://i1.wp.com/assignittous.com/wp-content/uploads/2018/01/ps_job_run_report.png?resize=1024%2C323&ssl=1)

