FROM python:3.9.16-alpine

# dependency for ssl http
RUN apk update && apk add openssl 

# dsh dependencies
COPY dsh /home/dsh/dsh

# dependencies for librdkafka
RUN apk add alpine-sdk librdkafka librdkafka-dev postgresql-dev

# create dsh group and user
ARG tenantuserid
ENV USERID $tenantuserid
RUN addgroup -g ${USERID} dsh && adduser -u ${USERID} -G dsh -D -h /home/dsh dsh

# install
RUN pip install googleapis-common-protos confluent-kafka==0.11.4 requests

# install required packages
COPY src/ /home/dsh/app/
RUN chown -R $USERID.$USERID /home/dsh/

USER dsh
WORKDIR /home/dsh/app

# entrypoint
ENTRYPOINT ["/home/dsh/dsh/entrypoint.sh"]
CMD ["python" ,"-u", "example_helloworld.py"]
