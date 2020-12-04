FROM python:2.7
WORKDIR /usr/src/myproject
COPY source/ .
RUN mkdir /usr/src/app \
  && pip install pipenv \
  && cd /usr/src/myproject \
  && pipenv install requests
