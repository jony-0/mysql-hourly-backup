# mySql Hourly Backup

Bash script to create hourly backups of a mysql database and save it to amazon s3.

# OS tested

- Ubuntu 18

## Roadmap

- Delete backups older than 'x' days via aws cli. Amazon s3 seems to have this option. Found it on this link. https://lepczynski.it/en/aws_en/automatically-delete-old-files-from-aws-s3/
- Update script so other storage spaces can be used, like dropbox, google drive etc. If time allows it.
