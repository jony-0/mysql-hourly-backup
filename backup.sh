backedup_db_name=`date +"%Y-%m-%d-%H"-db-name.gz`
database_name='enter_db_name_here'
s3_bucket_name='enter_bucket_name_here'
my_cnf_path='enter_path_to_.my.cnf_file_here/.my.cnf'

mysqldump --defaults-file=$my_cnf_path $database_name | gzip > $backedup_db_name
aws s3 mv $backedup_db_name s3://$s3_bucket_name/mysql-backup/
