FROM ubuntu as stage1
WORKDIR /app
RUN apt update && apt install default-jdk -y 
COPY Prime.java  /app
RUN javac /app/Prime.java

FROM ubuntu as stage2
RUN apt update && apt install default-jre -y 
COPY --from=stage1 /app/Prime.class .
CMD ["Prime"]
ENTRYPOINT ["java"]

