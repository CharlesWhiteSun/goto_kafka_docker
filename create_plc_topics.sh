#!/bin/bash

echo "=== 讀取 Topics 設定 ==="

TOPICS=("plc_power_prod" "plc_power_dev" "plc_power_control")

BOOTSTRAP_SERVER="kafka_1:9092"     # Kafka 服務地址，輸入一個 # INTERNAL 節點名稱即可 (根據 docker-compose.yml 中的服務名稱)
REPLICATION_FACTOR=3                # 複本數量，根據 Kafka 集群節點數量調整
PARTITIONS=3                        # 分區數量，根據預期負載調整
RETENTION_MS=$((30*24*60*60*1000))  # 30 天的保留時間
MIN_INSYNC_REPLICAS=2               # 最小同步副本數量，保證資料安全性。
CLEANUP_POLICY="delete"             # 清理策略/ 可選值：delete, compact
MAX_MESSAGE_BYTES=$((2*1024*1024))  # 最大訊息大小 2MB (預設 1MB)

echo "=== 建立 PLC Topics ==="

for TOPIC in "${TOPICS[@]}"; do
    echo "檢查 Topic: $TOPIC 是否已存在..."
    EXISTS=$(docker exec -it kafka_1 kafka-topics \
        --bootstrap-server $BOOTSTRAP_SERVER \
        --list | grep -w "$TOPIC")

    if [ -n "$EXISTS" ]; then
        echo "⚠ Topic '$TOPIC' 已存在，跳過建立。"
    else
        echo "建立 Topic: $TOPIC"
        docker exec -it kafka_1 kafka-topics --create \
            --bootstrap-server $BOOTSTRAP_SERVER \
            --replication-factor $REPLICATION_FACTOR \
            --partitions $PARTITIONS \
            --topic $TOPIC \
            --config retention.ms=$RETENTION_MS \
            --config min.insync.replicas=$MIN_INSYNC_REPLICAS \
            --config cleanup.policy=$CLEANUP_POLICY \
            --config max.message.bytes=$MAX_MESSAGE_BYTES

        if [ $? -eq 0 ]; then
            echo "✅ Topic '$TOPIC' 建立成功"
        else
            echo "❌ Topic '$TOPIC' 建立失敗"
        fi
    fi
done

echo "=== 完成建立 PLC Topics ==="
echo "目前 Kafka Topics 列表："
docker exec -it kafka_1 kafka-topics --list --bootstrap-server $BOOTSTRAP_SERVER
