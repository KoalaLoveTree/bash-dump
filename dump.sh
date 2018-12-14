#!/usr/bin/env bash

while getopts n:t:c:u:p:d: option
do
case "${option}"
in
t) DBTYPE=${OPTARG};;
d) DIR=${OPTARG};;
n) DBNAME=${OPTARG};;
c) CONT=${OPTARG};;
u) USR=${OPTARG};;
p) PASSWD=${OPTARG};;
esac
done

if [ -z ${DBTYPE} ]; then
    DBTYPE='mysql'
fi
if [ -z ${DIR} ]; then
    DIR='dump'
fi

mkdir -p ${DIR}
cd ${DIR}

if [ ${DBTYPE} == 'mysql' ]; then
    docker exec ${CONT} mysqldump -u${USR} -p${PASSWD} ${DBNAME} | gzip > ${CONT}`date +%d-%m-%Y"_"%H_%M_%S`.sql.gz  
elif [ ${DBTYPE} == 'postgres' ]; then
  docker exec  ${CONT} pg_dump -U ${USR} -d ${DBNAME} -w | gzip > ${CONT}`date +%d-%m-%Y"_"%H_%M_%S`.sql.gz  
fi
