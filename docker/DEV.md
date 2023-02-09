Build
-----

```shell
docker build . -t zavx0z/bib:0.0.9 -t zavx0z/bib:latest
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
docker volume prune -f
```