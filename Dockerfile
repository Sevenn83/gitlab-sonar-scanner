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

ADD https://bintray.com/sonarsource/SonarQube/download_file?file_path=org%2Fsonarsource%2Fscanner%2Fcli%2Fsonar-scanner-cli%2F${SONAR_SCANNER_VERSION}%2Fsonar-scanner-cli-${SONAR_SCANNER_VERSION}.zip /tmp/sonar-scanner.zip

WORKDIR /tmp

RUN \
    unzip /tmp/sonar-scanner.zip && \
    mv -fv /tmp/sonar-scanner-${SONAR_SCANNER_VERSION}/bin/sonar-scanner /usr/bin && \
    mv -fv /tmp/sonar-scanner-${SONAR_SCANNER_VERSION}/lib/* /usr/lib

RUN \
    apk add --no-cache nodejs && \
    ls -lha /usr/bin/sonar* && \
    ln -s /usr/bin/sonar-scanner-run.sh /usr/bin/gitlab-sonar-scanner

WORKDIR /usr/bin
