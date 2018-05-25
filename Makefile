NAME = rhalff/authumn-gateway
VERSION := $(shell cat VERSION)

all: build

git-tag:
	git add .
	git commit -m "Bumped version to $(VERSION)"
	git tag $(VERSION)
	git push
	git push --tags

test:
	env NAME=$(NAME) VERSION=$(VERSION)

build:
	docker build -t $(NAME):$(VERSION) .

release:
	echo "Authumn Gateway $(VERSION)"
	docker push -t $(NAME):$(VERSION)
