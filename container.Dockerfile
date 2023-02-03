FROM python:3.7

RUN pip install ec2instanceconnectcli

WORKDIR /logn_mysql

COPY ./install_logn .

ENTRYPOINT /logn_mysql/install_logn