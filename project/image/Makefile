build:
	docker build --compress --no-cache -t lpsufrj/cocalc-kubernetes-project:$(date '+%Y-%m-%d') .
	docker build --compress  -t lpsufrj/cocalc-kubernetes-project:latest .
push:
	docker push lpsufrj/cocalc-kubernetes-project:$(date '+%Y-%m-%d')
	docker push lpsufrj/cocalc-kubernetes-project:latest