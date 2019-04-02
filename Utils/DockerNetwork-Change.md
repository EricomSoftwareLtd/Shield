# Ericom Shield Changing Docker Network:

## Changing Docker Network:

### 1.	Edit the Docker Daemon config file:

```bash
sudo vi /etc/docker/daemon.json
```

- Add the following:
```
{
"bip": "172.22.0.1/16"
}
```
Replace the Subnet `172.22.0.1/16` with the subnet you want to use.

(If the file doesn’t exist create one)

(if there are other settings, add `"bip": "172.22.0.1/16",` at the begining after the '{' sign)

### 2.	Restart Docker Service:

```bash
shield-stop (if it's running)
sudo systemctl restart docker
```

## Changing Docker Swarm Network:

### 1. Stop Shield:

```bash
shield-stop
```

### 2. Leave the swarm on all nodes. This will stop swarm tasks and disable swarm multi-host overlay networking on the node:

```bash
sudo docker swarm leave -f
```

### 3. Remove the docker_gwbridge network:

```bash
sudo docker network rm docker_gwbridge
```

### 4. Recreate the docker_gwbridge network using the desired network prefix, setting the desired values:

```bash
sudo docker network create  \
--subnet 172.20.0.0/20 \
--gateway 172.20.0.1 \
-o com.docker.network.bridge.enable_icc=false \
-o com.docker.network.bridge.name=docker_gwbridge \
docker_gwbridge
```

### 5. (Optional) Confirm the settings on docker_gwbridge:

`sudo docker network inspect docker_gwbridge --format '{{range $k, $v := index .IPAM.Config 0}}{{.| printf "%s: %s " $k}}{{end}}'`

### 6. Change Consul Settings in Yaml for single mode:

    consul-server:
        image: 'securebrowsing/shield-configuration:190314-08.02-3983'
        networks:
            - shield
        deploy:
            mode: replicated   #single node
            replicas: 5        #single node
            #mode: global      #multi node

### 7. Start Shield and Recreate your cluster

```bash
shield-start
```
Wait for the system to be up and running. 
Check using shield-status command

### 7. Add other nodes to your cluster

Use add-node.sh to add all the cluster nodes
