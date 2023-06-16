
## _Pre-requisite_
- Postgresql 11
- Docker, swarm
- gitlab-runner


## _Command_
```sh
sudo su - root
mkdir -p /data/gds/log
mkdir -p /data/gds/data
docker network create --driver overlay --attachable --subnet=162.17.1.0/24 --gateway=162.17.1.1 app_net
docker volume create --name gds_log_data --driver local --opt type=none --opt device=/data/gds/log --opt o=bind
docker volume create --name gds_file_data --driver local --opt type=none --opt device=/data/gds/data --opt o=bind
docker rmi $(docker images | grep gds | tr -s ' ' | cut -d ' ' -f 3) -f
docker service rm $(docker service ls | grep gds | tr -s ' ' | cut -d ' ' -f 1) -f
```

> **Docker nginx port mapping with host Port :** `--publish 72:80`


## _Database_
| item | value |
| ------ | ------ |
| Host | localhost |
| Port | 5432 |
| DB Name | gds |
| Username | gds |
| Password | gds |
| TSD | [GDS__Table-State-Data](https://docs.google.com/spreadsheets/d/1IXbNa7G44I1Scx0_0m6YaUC0dKJjQewayRabyDZKz9M/edit#gid=554079026) |


## _Demo Application_
| item | value |
| ------ | ------ |
| url | [dev.gdsflight.com](https://dev.gdsflight.com/) |
| user | demo |
| password | sa |

## _Licence_
**TICL**
