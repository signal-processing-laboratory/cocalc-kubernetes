build:
	docker build --compress --no-cache -t ringeratlas/cocalc-kubernetes-project:$(date '+%Y-%m-%d') .
	docker build --compress  -t ringeratlas/cocalc-kubernetes-project:latest .
push:
	docker push ringeratlas/cocalc-kubernetes-project:$(date '+%Y-%m-%d')
	docker push ringeratlas/cocalc-kubernetes-project:latest