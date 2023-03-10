Restart
------

```shell
docker stop bib && sleep 4 && /bin/sh /home/zavx0z/projects/bib/docker/startUbuntu.sh
```

Build
-----

```shell
docker build . -t zavx0z/bib:noVNC_0.0.3
```

Push
----

```shell
docker image push --all-tags zavx0z/bib
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