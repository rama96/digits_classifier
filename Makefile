.PHONY: help prepare-dev clean test docs clean

VENV_NAME=env
VENV_ACTIVATE=. $(VENV_NAME)/bin/activate
PYTHONENV=${VENV_NAME}/bin/python
PYTHON=python3.8

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
	$(PYTHONGLOBAL) -m venv ${VENV_NAME}
	$(VENV_ACTIVATE)
	${PYTHON} -m pip install -U pip
	${PYTHON} -m pip install -r requirements.txt
	$(shell printf "\n# Adding this command to read local .env file" >> env/bin/activate)
	$(shell printf "\nexport \$(grep -v '^#' .env | xargs)" >> env/bin/activate)
	cp dotenv .env
	touch .env
	@echo "*** Please remember to add environment variables to .env file ***"

run:
	${PYTHON} our_app.py

# In this context, the *.project pattern means "anything that has the .project extension"
clean:
	rm -r *.project