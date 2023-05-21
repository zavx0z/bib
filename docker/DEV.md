Restart
------

```shell
docker stop bib && sleep 4 && /bin/sh /home/zavx0z/projects/bib/docker/startUbuntu.sh
```

Build
-----

```shell
docker build . -t zavx0z/bib:webRTC
docker build . -t zavx0z/bib:latest
```

Push
----

```shell
docker image push zavx0z/bib:latest
```
Run shell
```bash
docker exec -it bib /bin/bash
```

Clear
-----

```shell
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker rmi -f $(docker images -aq)
docker volume prune -f &&
docker network prune -f
```

```shell
supervisorctl reload
supervisorctl status x:
```