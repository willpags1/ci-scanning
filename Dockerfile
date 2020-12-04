FROM python:2.7
WORKDIR /usr/src
COPY main.py .
COPY requirements.txt .
RUN mkdir /usr/src/app \
  && cd /usr/src/ \
  && pip install -r requirements.txt
CMD ["python", "/usr/src/main.py"]
