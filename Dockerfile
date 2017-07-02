FROM solsson/kafka:0.11.0.0

WORKDIR /usr/local/kafka-connect-fs

COPY . .

RUN set -e; cd /usr/local; \
  MAVEN_VERSION=3.5.0 PATH=$PATH:$(pwd)/maven/bin; \
  apk add  --no-cache --virtual .build-deps \
    curl \
    openjdk8="$JAVA_ALPINE_VERSION" \
    bash; \
  mkdir ./maven; \
  curl -SLs https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar -xzf - --strip-components=1 -C ./maven; \
  mvn --version; \
  \
  cd ./kafka-connect-fs; \
  mvn package; \
  echo "temp layer"

#RUN echo "temp layer"; \
#  find target/ -name *-jar-with-dependencies.jar -exec mv -v '{}' ../kafka-connect-fs.jar \;; \
#  rm -Rf src pom.xml; \
#  \
#  cd ..; \
#  rm ./maven -Rf; \
#  rm /root/.m2 -Rf; \
#  apk del .build-deps;
#


# http://kafka-connect-fs.readthedocs.io/en/latest/connector.html#running-in-development
#export CLASSPATH="$(find /usr/local/kafka-connect-fs/target/kafka-connect-fs-*-package -type f -name '*.jar' | tr '\n' ':')"
