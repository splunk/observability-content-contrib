FROM golang:1.24-alpine AS build

RUN apk add --no-cache git
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY import.go .
RUN go build -o main .

FROM hashicorp/terraform:1.13

WORKDIR /app
COPY --from=build /app/main .
ENTRYPOINT ["/app/main"]