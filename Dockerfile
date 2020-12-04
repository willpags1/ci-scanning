FROM python:2.7
WORKDIR /usr/src
COPY main.py .
COPY requirements.txt .
RUN mkdir /usr/src/app \
  && pip install pipenv \
  && cd /usr/src/ \
  && pipenv install requests \
  && pipenv shell
CMD ["python", "/usr/src/main.py"]
