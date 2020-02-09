FROM python:3.9-rc-alpine3.10

COPY . /

RUN pip install -r requirements.txt

WORKDIR /app

EXPOSE 5000

CMD python ./index.py
