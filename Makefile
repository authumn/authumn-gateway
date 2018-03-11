all:

build:
	docker build -t authumn-nginx -f Dockerfile .
