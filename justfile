# remove all build, test, coverage and Python artifacts
clean: clean-build clean-pyc clean-test 

# remove build artifacts
clean-build:
	rm -fr build/
	rm -fr dist/
	rm -fr .eggs/
	find . -name '*.egg-info' -exec rm -fr {} +
	find . -name '*.egg' -exec rm -f {} +

# remove Python file artifacts
clean-pyc:
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +

# remove test and coverage artifacts
clean-test: 
	rm -fr .tox/
	rm -f .coverage
	rm -fr htmlcov/
	rm -fr .pytest_cache

# check style
ruff: 
	ruff check

# run tests quickly with the default Python
test: 
	pytest

# run tests on every Python version with uv
test-all: 
	uv run --python=3.10 --extra test pytest
	uv run --python=3.11 --extra test pytest
	uv run --python=3.12 --extra test pytest
	uv run --python=3.13 --extra test pytest

# check code coverage quickly with the default Python
coverage: 
	coverage run --source air_cli -m pytest
	coverage report -m
	coverage html
	$(BROWSER) htmlcov/index.html

# generate Sphinx HTML documentation, including API docs
docs: 
	rm -f docs/air_cli.md
	rm -f docs/modules.md
	sphinx-apidoc -o docs/ air_cli
	$(MAKE) -C docs clean
	$(MAKE) -C docs html
	$(BROWSER) docs/_build/html/index.html

# compile the docs watching for changes
servedocs: docs 
	watchmedo shell-command -p '*.md' -c '$(MAKE) -C docs html' -R -D .

# package and upload a release
release: dist 
	uv publish -t $(UV_PUBLISH_TOKEN)

# Build the project, useful for checking that packaging is correct
build: 
	rm -rf build
	rm -rf dist
	uv build	

