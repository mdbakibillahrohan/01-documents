#!/bin/bash
. ./two_schema_property.sh

startTime=${SECONDS}

rm -r ./output/*

./livedb_validator.py ${USER1} ${PASSWORD1} ${HOST1} ${PORT1} ${DATABASE1} ${OWNER1} 1 "${SCHEMA_TO_CHECK[@]}"
if [ $? -eq 0 ]
then echo "2. livedb_validator execute done from" ${USER1} ${PASSWORD1} ${HOST1} ${PORT1} ${DATABASE1} ${OWNER1} 1 "${SCHEMA_TO_CHECK[@]}"
else
    echo "2. Failed to execute livedb_validator from" ${USER1} ${PASSWORD1} ${HOST1} ${PORT1} ${DATABASE1} ${OWNER1} 1 "${SCHEMA_TO_CHECK[@]}"
    exit
fi

./livedb_validator.py ${USER2} ${PASSWORD2} ${HOST2} ${PORT2} ${DATABASE2} ${OWNER2} 2 "${SCHEMA_TO_CHECK[@]}"
if [ $? -eq 0 ]
then echo "2. livedb_validator execute done from" ${USER2} ${PASSWORD2} ${HOST2} ${PORT2} ${DATABASE2} ${OWNER2} 2 "${SCHEMA_TO_CHECK[@]}"
else
    echo "2. Failed to execute livedb_validator from" ${USER2} ${PASSWORD2} ${HOST2} ${PORT2} ${DATABASE2} ${OWNER2} 2 "${SCHEMA_TO_CHECK[@]}"
    exit
fi
echo "3. ...................... Comparing between two schema ......................"
./compare_schema.py 1 2

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
       google-chrome ./output/${schema}/compare_result.html &
    done
elif apropos browser | grep firefox
then
    for schema in ${SCHEMA_TO_CHECK[@]}
    do
        firefox ./output/${schema}/compare_result.html &
    done
else
    echo "You don\'t have chrome or firefox"
    echo "Please open it manually"
fi
