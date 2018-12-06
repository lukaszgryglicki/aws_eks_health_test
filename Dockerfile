FROM golang:1.11
COPY ekshealthtest .
CMD ./ekshealthtest
