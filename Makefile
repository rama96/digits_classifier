.PHONY: help prepare-dev clean test docs clean

VENV_NAME=env
VENV_ACTIVATE=. $(VENV_NAME)/bin/activate
PYTHONENV=${VENV_NAME}/bin/python
PYTHONGLOBAL=python3.8

.DEFAULT: help
help:
	@echo "1 . make prepare-dev"
	@echo "--prepare development environment, use only once"
	@echo "2. python-on-machine"
	@echo "--Installs python on the machine if not present for the development environment "
	@echo "3. run"
	@echo "--Run the application locally"
	
python-on-machine:
	sudo apt-get -y install ${PYTHONGLOBAL} python3-pip python3.8-venv python3.8-dev

prepare-dev:
	virtualenv -p python3.8 env
	$(VENV_ACTIVATE)
	pip install -U pip
	pip install -r requirements.txt
	cp dotenv .env
	touch .env
	@echo "*** Please remember to add environment variables to .env file ***"

add-env-var:
	$(shell printf "\n# Adding this command to read local .env file" >> env/bin/activate)
	$(shell printf "\nexport \$(grep -v '^#' .env | xargs)" >> env/bin/activate)
run:
	${PYTHON} our_app.py

# In this context, the *.project pattern means "anything that has the .project extension"
clean:
	rm -r *.project