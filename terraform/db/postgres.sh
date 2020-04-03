#!/bin/bash
export PATH=$PATH:/usr/bin

yum -y install https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm
yum -y install postgresql
yum -y install postgresql-server

postgresql-setup initdb
systemctl enable postgresql.service
systemctl start postgresql.service

sudo -u postgres psql -c 'SELECT version();'
sudo -u postgres bash -c "psql -c \"CREATE USER myuser WITH PASSWORD 'nosoylaclave';\""
sudo -u postgres bash -c "psql -c \"CREATE database mydb;\""
sudo -u postgres bash -c "psql -c \"grant all privileges on database mydb to myuser; ;\""
echo "listen_addresses = '*'" >> /var/lib/pgsql/data/postgresql.conf
echo "host  all   all   10.0.1.1/16  md5" >> /var/lib/pgsql/data/pg_hba.conf

systemctl restart postgresql.service