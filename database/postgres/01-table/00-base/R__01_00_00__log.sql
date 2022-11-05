/*
Log for every request to (and response from) Antarika
oid                            : Surrogate primary key
containerName                  : Name of container
status                         : RequestReceived, SentForProcessing, ReceivedAfterProcessing, ResponseSent
requestReceivedOn              : Timestamp when request was received from calling service
responseSentOn                 : Timestamp when response was sent to calling service
responseTimeInMs               : Duration of response time
requestSource                  : Which prouct sent the request
requestSourceService           : Which service sent the request
requestJson                    : Full Json payload of the request
responseJson                   : Full Json payload of the response
startSequence                  : Start sequence
endSequence                    : End sequence
traceId                        : To track using ID
*/
create table                   AntarikaRequestLog
(
oid                            varchar(128)                                                not null,
containerName                  varchar(256)                                                not null,
status                         varchar(32)                                                 not null,
requestReceivedOn              timestamp                                                   not null,
responseSentOn                 timestamp,
responseTimeInMs               numeric(10,0)                                               not null       default 0,
requestSource                  varchar(64)                                                 not null,
requestSourceService           varchar(256)                                                not null,
requestJson                    text                                                        not null,
responseJson                   text,
startSequence                  numeric(20,0)                                               not null       default 0,
endSequence                    numeric(20,0)                                               not null       default 0,
traceId                        varchar(32)                                                 not null,
constraint                     pk_AntarikaRequestLog                                       primary key    (oid),
constraint                     ck_status_AntarikaRequestLog                                check          (status = 'RequestReceived' or status = 'SentForProcessing' or status = 'ReceivedAfterProcessing' or status = 'ResponseSent')
);

/*
Log table for storing all SMS text
oid                            : Surrogate primary key
sender                         : Csb request id
mobileNo                       : Mobile number
smsText                        : Sms text
requestStatus                  : Status of sms
errorStatus                    : Count of sms
errorValue                     : Message provicer name
errorDescription               : Request date time
requestTime                    : When SMS request was sent to provider
responseTime                   : When SMS response was recieved from provider
*/
create table                   SmsLog
(
oid                            varchar(128)                                                not null,
sender                         varchar(128)                                                not null,
mobileNo                       varchar(64)                                                 not null,
smsText                        text                                                        not null,
requestStatus                  varchar(32)                                                 not null,
errorStatus                    varchar(32),
errorValue                     numeric(4,0),
errorDescription               text,
requestTime                    timestamp                                                   not null,
responseTime                   timestamp,
constraint                     pk_SmsLog                                                   primary key    (oid)
);


