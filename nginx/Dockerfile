FROM nginx:1.17.7

WORKDIR /etc/nginx
COPY conf.d ./conf.d
COPY bootstrap.sh .

CMD ["./bootstrap.sh"]
