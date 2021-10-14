# Build stage
FROM golang:1.17.2-alpine3.14 AS builder
ENV GO111MODULE=on \
  GOPROXY=https://goproxy.cn,direct
WORKDIR /app
COPY . .
RUN go build -o main main.go

# Run stage
FROM alpine:3.14
ENV GIN_MODE=release
WORKDIR /app
COPY --from=builder /app/main .
COPY app.env .

EXPOSE 8080
CMD ["/app/main"]
