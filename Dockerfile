FROM continuumio/miniconda3:latest

ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

RUN mkdir /app
WORKDIR /app

RUN pip install mlflow

RUN apt-get update -yqq \
   && apt-get install apt-utils -yqq \
   && apt-get install sudo -yqq \
   && apt-get install apache2 -yqq \
   && apt-get install apache2-utils -yqq \
   && apt-get install vim -yqq \
   && apt-get autoremove -yqq --purge \
   && apt-get clean \
   && rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base
   
ADD apache2.conf /etc/apache2/apache2.conf

RUN ln -sf /etc/apache2/mods-available/proxy.conf /etc/apache2/mods-enabled
RUN ln -sf /etc/apache2/mods-available/proxy.load /etc/apache2/mods-enabled
RUN ln -sf /etc/apache2/mods-available/proxy_http.load /etc/apache2/mods-enabled
# RUN ln -sf /etc/apache2/mods-available/ssl.load /etc/apache2/mods-enabled
# RUN ln -sf /etc/apache2/mods-available/ssl.conf /etc/apache2/mods-enabled

ADD entrypoint.sh ./entrypoint.sh

RUN useradd -u 1002 mlflow
RUN usermod -aG sudo mlflow

RUN echo "mlflow ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN chown -R mlflow:mlflow /app


RUN chmod +x ./entrypoint.sh

USER mlflow

ENTRYPOINT [ "/app/entrypoint.sh" ]
