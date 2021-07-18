.PHONY: help prepare-dev clean test docs clean

VENV_NAME=env
VENV_ACTIVATE=. $(VENV_NAME)/bin/activate
PYTHONENV=${VENV_NAME}/bin/python
PYTHON=python3.8

.DEFAULT: help
help:
	@echo "make prepare-dev"
	@echo "       prepare development environment, use only once"
	@echo "make docs"
	@echo "       build documentation using pydocmd"
	@echo "make clean"
	@echo "       clean temp files"
	@echo "make test"
	@echo "       Run pytest. Arguments: workers (required): number of workers (accepts interger (e.g. 4) or auto such as workers=auto"
	@echo "make test-single"
	@echo "       Run pytest on a specific file/directory. Arguments: file (required): path to directory or file"

python-on-machine:
	sudo apt-get -y install ${PYTHONGLOBAL} python3-pip python3.8-venv python3.8-dev

prepare-dev:
	$(PYTHONGLOBAL) -m venv ${VENV_NAME}
	$(VENV_ACTIVATE)
	${PYTHON} -m pip install -U pip
	${PYTHON} -m pip install -e .[development]
	$(shell printf "\n# Adding this command to read local .env file" >> env/bin/activate)
	$(shell printf "\nexport \$(grep -v '^#' .env | xargs)" >> env/bin/activate)
	cp dotenv .env
	touch .env
	@echo "*** Please remember to add environment variables to .env file ***"

test:
	python -m pytest

test-new:
	@echo Input argument: $(workers)
	pytest -c pytest.ini --verbose --color=yes -n $(workers) -rsx --cov=bv_pricing

test-single:
	@echo Input argument: $(file)
	pytest -c pytest.ini --verbose --color=yes $(file)

pytest:
	@echo " Running pytest with DANAMICA_CONFIG=test_config.ini"
	@export DANAMICA_CONFIG=test_config.ini && pytest -c pytest.ini

test-coverage:
	${PYTHONENV} coverage run -m pytest
	${PYTHONENV} coverage report

docs:
	$(VENV_ACTIVATE); cd docs; pydocmd build; pydocmd serve

clean:
	rm -rf .tox
	rm -rf .coveragerc

start-service:
	@echo "Compose starts and runs your entire app."
	docker-compose up

build-db:
	docker volume create --driver local pgdata
	docker-compose build db

build-all:
	docker volume create --driver local pgdata
	docker-compose build --build-arg SSH_KEY_PRV="$(cat ~/.ssh/id_rsa)" --build-arg SSH_KEY_PUB="$(cat ~/.ssh/id_rsa.pub)"

delete-build:
	docker-compose down
	docker-compose rm web
	docker-compose rm db
	docker volume rm pgdata

stop-existing-postgres-service:
	sudo service postgresql stop