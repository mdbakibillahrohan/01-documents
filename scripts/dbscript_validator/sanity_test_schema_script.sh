#!/bin/bash

. script_property.sh

startTime=${SECONDS}

rm -r ./outputs/*

./dbscript_validator.py "${SCRIPT_PATH}" 1 "${SCHEMA_TO_CHECK[@]}"
if [ $? -eq 0 ]
then echo "1. dbscript_validator execute done in" "${SCRIPT_PATH}" 1
else
    echo "1. Failed to execute dbscript_validator in" "{$SCRIPT_PATH}" 1
    exit
fi

./livedb_validator.py ${USER} ${PASSWORD} ${HOST} ${PORT} ${DATABASE} ${OWNER} 1 "${SCHEMA_TO_CHECK[@]}"
if [ $? -eq 0 ]
then echo "2. livedb_validator execute done from" ${USER}, ${PASSWORD}, ${HOST}, ${PORT}, ${DATABASE}, ${OWNER} 1 "${SCHEMA_TO_CHECK[@]}"
else
    echo "2. Failed to execute livedb_validator from" ${USER}, ${PASSWORD}, ${HOST}, ${PORT}, ${DATABASE}, ${OWNER} 1 "${SCHEMA_TO_CHECK[@]}"
    exit
fi


echo "3. ...................... Comparing schema and scripts ......................"
./compare_schema.py 1

if [ $? -eq 0 ]
then
    echo "3. compare_schema execute done"
else
    echo "3. Failed to execute in compare_schema"
    exit
fi

endTime=${SECONDS}
diffTime=`expr ${endTime} - ${startTime}`
echo ""
printf '\033[93mTotal execution time \033[1m %02d:%02d:%02d \033[0m\n' $(($diffTime/3600)) $(($diffTime%3600/60)) $(($diffTime%60))


if apropos browser | grep google-chrome
then
    for schema in ${SCHEMA_TO_CHECK[@]}
    do
       google-chrome ./outputs/${schema:3}/compare_result.html &
    done
elif apropos browser | grep firefox
then
    for schema in ${SCHEMA_TO_CHECK[@]}
    do
        firefox ./outputs/${schema:3}/compare_result.html &
    done
else
    echo "You don\'t have chrome or firefox"
    echo "Please open it manually"
fi
