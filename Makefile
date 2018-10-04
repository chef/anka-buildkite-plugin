lint:
	docker run -it --rm -v "$(PWD):/plugin" buildkite/plugin-linter --id chef/anka

bats:
	docker-compose run tests
