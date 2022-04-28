# Running it will be something like this:
#
#    docker run -d \
#         --env SMTP_HOST=smtp.gmail.com \
#         --env SMTP_USERNAME=steve@example.com \
#         --env SMTP_PASSWORD=secret \
#         leehom/rss2email:latest daemon -verbose steve@example.com

# STEP1 - Build-image
###########################################################################
FROM golang:alpine AS builder

LABEL org.opencontainers.image.source=https://github.com/skx/rss2email/

# Ensure we have git
RUN apk update && apk add --no-cache git

# Create a working-directory
WORKDIR $GOPATH/src/github.com/skx/rss2email/

# Copy the source to it
COPY . .

# Get the dependencies
RUN go get -d -v

# Build the binary.
RUN go build -o /go/bin/rss2email

RUN ls -ltr /go/bin


# STEP2 - Deploy-image
###########################################################################
FROM alpine

# Create a working directory
WORKDIR /app

# Copy the binary.
COPY --from=builder /go/bin/rss2email /app/

ENTRYPOINT ["/entrypoint.sh"]