FROM python:2.7
WORKDIR /usr/src
COPY main.py .
RUN mkdir /usr/src/app \
  && pip install pipenv \
  && cd /usr/src/\
  && pipenv install requests
CMD ["/usr/src/main.py"]
