# **Kafka Cluster with Docker**

This repository demonstrates how to set up a **multi-node Kafka Cluster**
using Docker Compose, including Zookeeper coordination and persistent data volumes.

It also provides a handy Bash script for creating PLC-related topics automatically.


## 🚀 **Getting Started**

1) Prerequisites:
    - Docker and Docker Compose installed
    - WSL2 enabled (if running on Windows)
    - Bash environment available

2) Start the Kafka Cluster:
    ```bash
    docker-compose up -d
    ```

    This command will:
    - Launch 3 Kafka brokers
    - Create persistent data volumes under each broker’s `/data/`

3) Verify that all containers are running:
    ```bash
    docker ps
    ```


## 🧩 **Topic Creation Script**

The script `create_plc_topics.sh` automates topic creation for PLC message streams.

```bash
./create_plc_topics.sh
```

It will:
- Read topic configurations from within the script
- Create each topic with defined replication and partition settings
- Output creation logs for verification


## 🛠 **Maintenance & Cleanup**

Stop and remove containers:

```bash
docker-compose down -v
```

Clean up persistent volumes (optional):
```bash
rm -rf kafka_1/data kafka_2/data kafka_3/data
```

Rebuild the cluster from scratch:
```bash
docker-compose build --no-cache && docker-compose up -d
```

Completely clear all unused data(Please use this command with caution):
```bash
docker system prune -af
```


## 📘 **Notes**

- Each Kafka node has its own persistent `data/` folder for broker logs and offsets.
- `.gitignore` excludes all `data/` directories from version control.
- `.gitattributes` ensures all scripts use LF (Linux) line endings to prevent `$'\r'` issues.


## 📄 **License**

This project is licensed under the Apache License 2.0.
You may obtain a copy of the License at:

    http://www.apache.org/licenses/LICENSE-2.0


## 🧭 **Additional References**
- Apache Kafka Documentation: https://kafka.apache.org/documentation/
- Docker Compose Overview: https://docs.docker.com/compose/
- Confluent Kafka Tools: https://www.confluent.io/resources/
