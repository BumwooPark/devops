## Devops 과제

### 1. 테스트 구성 환경
 ```
 macos mojave 10.14.4
 Gradle 5.4
 Docker 18.09.2
 docker-compose 1.23.2
 openjdk 1.8
 ---------------------
 CentOS Linux release 7.6.1810 (Core)
 Gradle 5.1
 Docker 18.09.4
 docker-compose version 1.24.0
 java-1.8.0-openjdk./de 
 ```
 
### 2. 실행 방법 
  #### 1. 컨테이너 환경 전체 실행 
  ```
  bash ./devops.sh start
  ```
  #### 2. 컨테이너 환경 전체 중지 
  ```
  bash ./devops.sh stop 
  ```
  #### 3. 컨테이너 환경 전체 재시작
  ```
  bash ./devops.sh restart
  ```
  #### 4. scale in out
  ```
  bash ./devops.sh scale {count}
  ex) bash ./devops.sh scale 3 
  ``` 
  #### 5. 무중단 배포 (blue-green deploy)
  ```
  bash ./devops.sh deploy
  ```
  #### 6. 컨테이너 환경 전체 중지
  ```
  bash ./devops.sh stop
  ```
  
### 3. 기타 사항
  1. 어플리케이션들의 Log 는 Host 에 file 로 적재
  ```
  ./logs 경로에 nginx 및 application 컨테이너 로그 저장 
  ``` 
  
  2. nginx proxy 80 port , round robin방식으로 설정
  ```
  nginx는 default 스케쥴링이 RR이고 docker-gen 이 포함된 nginx-proxy 이미지를 사용 
  ```
  
  3. health check
  ```
  간단한 up or down 및 hostname을 출력하도록 설정 
  무중단 배포 테스트 가능 
  ```
  
  4. 배포 방식중 blue-green deploy를 구현 
  ```
  ./devops.sh 실행중 새로운 도커 컨테이너 recreate 이후 
  도커 health 체킹 기능을 이용하여 unhealthy 상태가 없을경우 기존 (green or blue)
  컨테이너를 종료 
  ```
  
  
  
  
  

  
