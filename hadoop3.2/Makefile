DOCKER_NETWORK = docker-hadoop_default
ENV_FILE = hadoop.env
current_branch := 0.1
build:
	docker build -t coomia/hadoop3.2-base:$(current_branch) ./base
	docker build -t coomia/hadoop3.2-namenode:$(current_branch) ./namenode
	docker build -t coomia/hadoop3.2-datanode:$(current_branch) ./datanode
	docker build -t coomia/hadoop3.2-resourcemanager:$(current_branch) ./resourcemanager
	docker build -t coomia/hadoop3.2-nodemanager:$(current_branch) ./nodemanager
	docker build -t coomia/hadoop3.2-historyserver:$(current_branch) ./historyserver