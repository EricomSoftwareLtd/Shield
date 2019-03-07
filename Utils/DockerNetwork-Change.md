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
docker swarm leave -f
```

### 3. Remove the docker_gwbridge network:

```bash
docker network rm docker_gwbridge
```

### 4. Recreate the docker_gwbridge network using the desired network prefix, setting the desired values:

```bash
docker network create  \
--subnet 172.20.0.0/20 \
--gateway 172.20.0.1 \
-o com.docker.network.bridge.enable_icc=false \
-o com.docker.network.bridge.name=docker_gwbridge \
docker_gwbridge
```

### 5. (Optional) Confirm the settings on docker_gwbridge:

`docker network inspect docker_gwbridge --format '{{range $k, $v := index .IPAM.Config 0}}{{.| printf "%s: %s " $k}}{{end}}'`

### 6. Start Shield and Recreate your cluster

```bash
shield-start
```
Use add-node.sh to add all the cluster nodes
