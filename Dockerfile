FROM openjdk:11
ARG JAR_FILE=target/*.jar
ADD ${JAR_FILE} my-app.jar
#EXPOSE 8080
ENTRYPOINT ["java","-jar","/my-app.jar"]
