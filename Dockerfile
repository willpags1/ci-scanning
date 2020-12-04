FROM python:2.7
WORKDIR /usr/src
COPY main.py .
COPY requirements.txt .
RUN mkdir /usr/src/app \
  && cd /usr/src/ \
  && python -m pip install -r requirements.txt
CMD ["python", "main.py"]
