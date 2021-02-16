build:
	docker build --compress --no-cache -t ringeratlas/cocalc-kubernetes-server:$(date '+%Y-%m-%d') .
	docker build --compress  -t ringeratlas/cocalc-kubernetes-server:latest .
push:
	docker push ringeratlas/cocalc-kubernetes-server:$(date '+%Y-%m-%d')
	docker push ringeratlas/cocalc-kubernetes-server:latest