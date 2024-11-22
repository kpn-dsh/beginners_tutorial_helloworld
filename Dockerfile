FROM python:3.7.0-alpine

ARG UID
ARG GID=${UID}
ARG USER=dsh
ARG GROUP=dsh

# dependencies for librdkafka
RUN apk add --no-cache \
      alpine-sdk \
      librdkafka \
      librdkafka-dev \
      openssl \
      postgresql-dev

# create dsh group and user
RUN addgroup -g ${GID} ${GROUP} \
 && adduser -u ${UID} -G ${GROUP} -D -h /home/${USER} ${USER}

# install
RUN pip install googleapis-common-protos confluent-kafka==0.11.4 requests

# dsh dependencies
COPY --chown=${UID}:${GID} --chmod=550 dsh/entrypoint.sh /entrypoint.sh
COPY --chown=${UID}:${GID} --chmod=550 dsh/setup_ssl_dsh.sh /setup_ssl_dsh.sh
COPY --chown=${UID}:${GID} dsh/lib /home/${USER}/dsh/lib
# install required packages
COPY --chown=${UID}:${GID} src /app

USER ${USER}
WORKDIR /app

# entrypoint
ENTRYPOINT ["/entrypoint.sh"]
CMD ["python" ,"-u", "example_helloworld.py"]
