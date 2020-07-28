build:
	docker build --compress --no-cache -t lpsufrj/cocalc-kubernetes-server:$(date '+%Y-%m-%d') .
	docker build --compress  -t lpsufrj/cocalc-kubernetes-server:latest .
push:
	docker push lpsufrj/cocalc-kubernetes-server:$(date '+%Y-%m-%d')
	docker push lpsufrj/cocalc-kubernetes-server:latest