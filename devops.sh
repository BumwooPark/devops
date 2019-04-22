#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

DOCKER_COMPOSE_PATH=./build/docker-compose.yaml

usage() {
    echo "Usage:  devops.sh [start | stop | restart | deploy]"
    echo ""
    echo ""
    echo " - start         : 컨테이너 환경 전체 실행"
    echo " - stop          : 컨테이너 환경 전체 중지"
    echo " - restart       : 컨테이너 환경 전체 재시작"
    echo " - deploy        : 웹 어플리케이션 무중단 배포"
    echo " - scale [count] : 컨테이너 scale in out"
    echo ""
}

function current_state() {
       if $(docker-compose -f ${DOCKER_COMPOSE_PATH} ps | grep blue | grep -q Up);then
       echo "blue"
       elif $(docker-compose -f ${DOCKER_COMPOSE_PATH} ps | grep green | grep -q Up);then
       echo "green"
       fi
}

function start() {
    echo "Container Service Start..."
    gradle build -b build.gradle
    docker-compose -f ${DOCKER_COMPOSE_PATH} up -d --build nginx blue
}

function stop(){
    echo "Container Service Stop..."
    docker-compose -f ${DOCKER_COMPOSE_PATH} down
}

function restart() {
    echo "Container Service Restart..."
    docker-compose -f ${DOCKER_COMPOSE_PATH} restart
}

function scale() {
    echo "Container Scale to "$1"..."
    docker-compose -f ${DOCKER_COMPOSE_PATH} up -d --scale $(current_state)=$1 $(current_state)
}

function deploy() {
    if [[ $(current_state) == "blue" ]]; then
        SCALE=$(docker-compose -f ${DOCKER_COMPOSE_PATH} ps | grep blue | wc -l | grep -e "[0-9]")
        deploy_green $SCALE
    elif [[ $(current_state) == "green" ]]; then
        SCALE=$(docker-compose -f ${DOCKER_COMPOSE_PATH} ps | grep green | wc -l | grep -e "[0-9]")
        deploy_blue $SCALE
    fi
}

function deploy_green() {
    echo "deploy green..."
    gradle build -b build.gradle
    docker-compose -f ${DOCKER_COMPOSE_PATH} build --no-cache green
    docker-compose -f ${DOCKER_COMPOSE_PATH} up -d --force-recreate --scale green=$1 green
    echo "success deploy green"
    echo
    health_check green
    destroy blue
}

function deploy_blue() {
    echo "deploy blue..."
    gradle build -b build.gradle
    docker-compose -f ${DOCKER_COMPOSE_PATH} build --no-cache blue
    docker-compose -f ${DOCKER_COMPOSE_PATH} up -d --force-recreate --scale blue=$1 blue
    echo "success deploy blue"
    echo
    health_check blue
    destroy green
}

function destroy(){
    echo "destroy $1..."
    docker-compose -f ${DOCKER_COMPOSE_PATH} stop "$1" && docker-compose -f ${DOCKER_COMPOSE_PATH} rm -f "$1"
    echo "success destroy $1..."
}

function health_check() {
    current=$(current_state)
    until [ $(docker-compose -f ${DOCKER_COMPOSE_PATH} ps $1 | egrep "starting|unhealthy" |  wc -l) -eq 0 ]; do
    echo -e "\rhealth checking..." | tr -d '\n'
    sleep 5
    done
    echo "finish"
    echo
}

if [ $# -eq 0 ]; then
    usage
    exit 0
fi

case $1 in
    -h) usage
    ;;
    --help) usage
    ;;
    start)
    start
    ;;
    stop)
    stop
    ;;
    restart)
    restart
    ;;
    deploy)
    deploy
    ;;
    scale)
    if [[ $# != 2 ]]; then
    usage
    exit 0
    fi
    scale $2
    ;;
    *)
    usage
    ;;
esac
