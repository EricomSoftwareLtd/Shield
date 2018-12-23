
node {
    
    stage("Get latest version") {
        git url: "https://github.com/EricomSoftwareLtd/Shield.git",  credentialsId: "451bb7d7-5c99-4d21-aa3a-1c6a1027406b", barnch: "DevTest"
    }
    
    stage("Build RPM") {
        sh "cd Setup/rmp && ./_build_in_docker.sh"
    }
}



