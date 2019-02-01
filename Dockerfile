FROM openjdk:8-jdk-alpine
## Based on this example http://stackoverflow.com/a/40612088/865222
ENV SONAR_SCANNER_VERSION 3.3.0.1492

RUN apk add --no-cache wget && \
    wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux.zip && \
    unzip sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux.zip && \
    sed -i 's/use_embedded_jre=true/use_embedded_jre=false/g' sonar-scanner-${SONAR_SCANNER_VERSION}-linux/bin/sonar-scanner && \ 
    cd /usr/bin && ln -s /sonar-scanner-${SONAR_SCANNER_VERSION}-linux/bin/sonar-scanner sonar-scanner && \
    apk del wget

RUN apk add --update nodejs nodejs-npm

RUN npm install -g typescript

ENV NODE_PATH "/usr/lib/node_modules/"

COPY sonar-scanner-run.sh /usr/bin
