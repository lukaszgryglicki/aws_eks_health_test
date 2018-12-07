FROM golang:1.11
COPY ekshealthtest .
CMD ./ekshealthtest 1> ekshealthtest.log 2> ekshealthtest.err
