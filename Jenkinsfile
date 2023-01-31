def remote = [:]
remote.name = "jenkins"
remote.host = "repozitarium.local"
remote.allowAnyHosts = true

node {
    withCredentials([sshUserPrivateKey(credentialsId: 'repozitarium', keyFileVariable: 'identity', usernameVariable: 'userName')]) {
        remote.user = userName
        remote.identityFile = identity
        stage("остановить все контейнеры") {
            sshCommand remote: remote, command: 'docker stop $(docker ps -a -q)', failOnError: false
        }
//         stage("удалить все контейнеры") {
//             sshCommand remote: remote, command: 'docker rm $(docker ps -a -q)', failOnError: false
//         }
//         stage("удалить все изображения") {
//             sshCommand remote: remote, command: 'docker rmi -f $(docker images -aq)', failOnError: false
//         }
//         stage("удалить все тома") {
//             sshCommand remote: remote, command: 'docker volume prune', failOnError: false
//         }
        stage("развертывание образа bib") {
            sshCommand remote: remote, command: 'sh /home/zavx0z/projects/bib/docker/startUbuntu.sh'
        }
        stage("Запуск VNC-viewer в Google Chrome") {
            writeFile file: 'google.sh', text: 'export DISPLAY=:1\n google-chrome http://localhost:6080'
            sshPut remote: remote, from: 'google.sh', into: '.'
            sshScript remote: remote, script: 'google.sh'
        }
    }
}
//             sshGet remote: remote, from: 'abc.sh', into: 'bac.sh', override: true
//             sshRemove remote: remote, path: 'abc.sh'
