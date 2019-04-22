FROM openjdk:8-jdk-alpine
MAINTAINER bumwoopark<qjadn0914@naver.com>

RUN apk add --no-cache curl
ADD ./libs/ /src
WORKDIR /src
ENTRYPOINT java -jar *.jar