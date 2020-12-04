FROM python:2.7
WORKDIR /usr/src
COPY main.py .
COPY requirements.txt .
RUN mkdir /usr/src/app \
  && cd /usr/src/
# Normally this wouldn't be on its own RUN command, but I wanted us to start with it commented out for something.
# RUN python -m pip install -r requirements.txt
CMD ["python", "main.py"]
