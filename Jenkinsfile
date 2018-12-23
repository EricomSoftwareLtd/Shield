import java.io.File
def host_path = "/home/ozlevka/tmp/jenkins-home/workspace/rpm-build-pipeline/Setup/rpm"
def docker_path = "/var/jenkins_home/workspace/rpm-build-pipeline"
def versions_file = "Setup/shield-version.txt"
def remote = [:]
remote.name = "build"
remote.host = "192.168.50.75"
remote.allowAnyHosts = true
def release_version = 'Unknow'
def github_repo = "Shield"

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
        def version = ''
        for (def i = 0; i < lines.size(); i++) {
            def matcher = lines[i] =~ 'SHIELD_VER=(.+)$'
            if(matcher) {
              def versions = lines[i].split(' ')
              release_version = versions[1].replace('SHIELD_VER=', '').replace(':', '-')

            } else {
                echo lines[i]
            }
        }

        echo version
    }

    stage("Create release") {
        sh "/app/bin/linux/amd64/github-release release -s ${env.GITHUB_TOKEN} -u EricomSoftwareLtd -r ${github_repo} -t RPM-${release_version} -n ${release_version} -p"
    }

    stage("Upload RPM files") {
        def release_files_dir = "Setup/rpm/_build/rpm/RPMS/x86_64"
        def files = findFiles glob: "${docker_path}/${release_files_dir}/*.rpm"
        for(def i = 0; i < files.size(); i++) {
            echo "Will upload ${file[i].path}"
            sh "/app/bin/linux/amd64/github-release upload -s ${env.GITHUB_TOKEN} -u EricomSoftwareLtd -r ${github_repo} -t RPM-${release_version} -f \"${files[i].path}\" --name \"${files[i].name}\"" 
        }
    }
}



