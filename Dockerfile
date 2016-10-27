FROM alpine:3.2

ADD requirements.txt .

RUN apk -U add ca-certificates python python-dev freetds-dev libxml2-dev libxslt-dev py-pip build-base && \
    pip install --upgrade pip && \
    pip install -r requirements.txt && \
    apk del python-dev && \
    rm -r /var/cache/apk/* && \
    mkdir /locust

WORKDIR /locust

ADD locustfile.py /locust
EXPOSE 8089 5557 5558
ENTRYPOINT [ "/usr/bin/locust" ]