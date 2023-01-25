### На машине с Jenkins

- установить плагин [SSH Pipeline Steps](https://www.jenkins.io/doc/pipeline/steps/ssh-steps/)
- сгенерировать RSA-ключ

```shell
ssh-keygen -m PEM
```

- скопировать публичный ключ на управляемую машину

```shell
ssh-copy-id -i id_rsa.pub zavx0z@192.168.1.7
```

- добавить Credentials [sshUserPrivateKey](http://raspberrypi.local:8080/manage/credentials/)
- добавить в "Credentials sshUserPrivateKey" Private Key

```shell
cat id_rsa
```

### На управляемой машине

- проверить присутствие ключа

```shell
vim ~/.ssh/authorized_keys
```

- отредактировать конфигурацию добавив строку `PubkeyAcceptedAlgorithms=+ssh-rsa`  
  [(старый метод аутентификации по ключу)](https://unix.stackexchange.com/questions/721606/ssh-server-gives-userauth-pubkey-key-type-ssh-rsa-not-in-pubkeyacceptedalgorit)

```shell
sudo vim /etc/ssh/sshd_config
```

Перезагрузить сервис ssh

```shell
sudo systemctl restart ssh
```