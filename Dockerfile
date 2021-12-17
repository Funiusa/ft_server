FROM    debian:buster
COPY ./srcs/ ./tmp/
COPY ./srcs/autoindex_on.sh .
COPY ./srcs/autoindex_off.sh .
EXPOSE 80 8080 443 
CMD bash /tmp/build.sh && bash