FROM golang:1.11
# EXPOSE 8888
COPY ekshealthtest .
CMD ./ekshealthtest
