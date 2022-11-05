FROM redis:6.2.7-alpine

RUN apk update
RUN apk add --no-cache tzdata
ENV TZ Asia/Dhaka

# docker build -t my_redis:6.2.7-alpine .
