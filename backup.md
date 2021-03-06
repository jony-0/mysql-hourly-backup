### install aws cli

```bash
sudo apt-get install awscli
```

## configure aws cli

```bash
$ aws configure
$ AWS Access Key ID [****************XS57] :
$ AWS Secret Access Key [****************F1dv] :
$ Default region name [ca-central-1]: ca-central-1
$ Default output format [None]:
```
make sure you use proper aws access key, secret and region you have your bucket in.

## Version 1 of the script

```bash
# Create variables that will be used later
backedup_db_name=`date +"%Y-%m-%d-%H"-db-name.gz`
mysql_user='db_user' 
mysql_password='password'
database_name='db_name'
s3_bucket_name='bucket_name'

# using mysql root user will not give below error

# "mysqldump: Error: 'Access denied; you need (at least one of) the PROCESS privilege(s) for this operation' when trying to dump tablespaces"

# Backup database into a sql dump file and save it to /tmp folder (you can store it elsewhere if desired). Below command is storing the file in the root directory.

mysqldump -u$mysql_user -p$mysql_password $database_name | gzip > $backedup_db_name

# Move file from server to your S3 bucket
# Below command will move the backups in to a folder /mysql-backups in the s3 bucket of your choosing.

aws s3 mv $backedup_db_name s3://$s3_bucket_name/mysql-backups/
```
aws mv command will move the database from your server to your amazon s3 bucket, which means it also delets the copy from your server.

Although above script will work, but it will also throw a warning message that will warn you about using
mysqldump passwords on command line interface as this is not a secure method.

Since you are using Ubuntu, all you need to do is just to add your credentials to a file and use that file path in your script, and it will disable the mysqldump password prompting. This is done by creating the file .my.cnf (permissions need to be 600).

```bash
touch .my.cnf
chmod 600 .my.cnf
```

copy paste this in the file

```bash
[mysqldump]
user=mysqluser
password=secret
```
in case of ISPmanager (ignore this if you are not using ISPmanager to manage your server.)
```bash
[client]
user=mysqluser
password=secret
```

again make sure to use mysql root user if you do not want see that previlliage error related to tablespaces.

this removes the warning message of using mysqldump password on command line interface

If your .my.cnf file is not in a default location and mysqldump doesn't see it, specify it using --defaults-file.

to get the path of your .my.cnf file. Navigate to the folder that contains .my.cnf file and type this command.

```bash
pwd
```

# New script will be

```bash
backedup_db_name=`date +"%Y-%m-%d-%H"-db-name.gz`
database_name='enter_db_name_here'
s3_bucket_name='enter_bucket_name_here'
my_cnf_path='enter_path_to_.my.cnf_file_here/.my.cnf'

mysqldump --defaults-file=$my_cnf_path $database_name | gzip > $backedup_db_name
aws s3 mv $backedup_db_name s3://$s3_bucket_name/mysql-backup/
```

now all you need to do is setup a cron job at your server that will run this script every hour. For that you need to save above script in a file.

```bash
touch backup_sql
```

make sure to set correct permission to this newly created file. Touch command seems to be setting 644 by default. 600 is good enough for me.

```bash
chmod 600 backup_sql
```

cron job to run every hour.

```bash
sh path_to/backup-sql
```
