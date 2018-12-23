import java.io.File
def host_path = "/home/ozlevka/tmp/jenkins-home/workspace/rpm-build-pipeline/Setup/rpm"
def versions_file = "Setup/shield-version.txt"
def remote = [:]
remote.name = "build"
remote.host = "192.168.50.75"
remote.allowAnyHosts = true


node {
    
    stage("Get latest version") {
        git url: "https://github.com/EricomSoftwareLtd/Shield.git",  credentialsId: "451bb7d7-5c99-4d21-aa3a-1c6a1027406b", branch: "DevTest"
    }

    withCredentials([usernamePassword(credentialsId: 'ssh-credentials', usernameVariable: 'username', passwordVariable: 'password')]) {
        remote.user = username
        remote.password = password 
        stage("Build RPM") {
            sshCommand remote: remote, command: "/bin/bash -c \"sudo ${host_path}/_build_in_docker.sh\""
        }
    }

    stage("Parse versions file") {
        def all = readFile("${versions_file}")
        def lines = all.split('\n')
        for (def i = 0; i < lines.size(); i++) {
            echo lines[i]
        }
    }
}



