# Build stage
FROM golang:1.17.2-alpine3.14 AS builder
ENV GO111MODULE=on \
  GOPROXY=https://goproxy.cn,direct \
  DB_SOURCE=postgresql://root:simple@postgresql:5432/simple_bank?sslmode=disable
WORKDIR /app
COPY . .
RUN go build -o main main.go
RUN apk --no-cache add curl
RUN curl --limit-rate 1G -L https://github.com/golang-migrate/migrate/releases/download/v4.14.1/migrate.linux-amd64.tar.gz | tar xvz

# Run stage
FROM alpine:3.14
ENV GIN_MODE=release
WORKDIR /app
COPY --from=builder /app/main .
COPY --from=builder /app/migrate.linux-amd64 ./migrate
COPY app.env .
COPY start.sh .
COPY wait-for.sh .
COPY db/migration ./migration

EXPOSE 8080
CMD ["/app/main"]
ENTRYPOINT [ "/app/start.sh" ]
