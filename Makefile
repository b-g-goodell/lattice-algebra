PYPI_SERVER = pypitest

.DEFAULT_GOAL := help

.PHONY: clean-tox
clean-tox: ## Remove tox testing artifacts
	@echo "+ $@"
	@rm -rf .tox/

.PHONY: clean-build
clean-build: ## Remove build artifacts
	@echo "+ $@"
	@rm -fr build/
	@rm -fr dist/
	@rm -fr *.egg-info

.PHONY: clean-pyc
clean-pyc: ## Remove Python file artifacts
	@echo "+ $@"
	@find . -type d -name '__pycache__' -exec rm -rf {} +
	@find . -type f -name '*.py[co]' -exec rm -f {} +

.PHONY: clean
clean: clean-tox clean-build clean-pyc ## Remove all file artifacts

.PHONY: lint
lint: ## Check code style with flake8
	@echo "+ $@"
	@tox -e lint

.PHONY: test
test:  ## Run tests quickly with the default Python
	@echo "+ $@"
	@tox -e py

.PHONY: test-all
test-all: ## Run tests on every Python version with tox
	@echo "+ $@"
	@tox

.PHONY: coverage
coverage: ## Check code coverage quickly with the default Python
	@echo "+ $@"
	@tox -e cov-report
	@$(BROWSER) htmlcov/index.html

.PHONY: release
release: clean ## Package and upload release - Done in CI normally
	@echo "+ $@"
	@python setup.py sdist bdist_wheel
	@twine upload -r $(PYPI_SERVER) dist/*

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}'
