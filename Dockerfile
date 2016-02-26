FROM trenpixster/elixir:1.2.0

# Install thrift dependencies
RUN apt-get update && apt-get install -y \
      apt-transport-https \
      automake \
      bison \
      clang \
      cmake \
      debhelper \
      flex \
      g++ \
      git \
      libtool \
      make \
      pkg-config

WORKDIR /tmp

RUN gpg --keyserver pgpkeys.mit.edu --recv-key 66B778F9
RUN wget http://www.apache.org/dist/thrift/0.9.3/thrift-0.9.3.tar.gz
RUN wget https://www.apache.org/dist/thrift/0.9.3/thrift-0.9.3.tar.gz.asc
RUN gpg --verify thrift-0.9.3.tar.gz.asc thrift-0.9.3.tar.gz
RUN tar -xzf thrift-0.9.3.tar.gz -C /usr/src --strip-components=1

WORKDIR /usr/src
RUN ls -al
RUN ./configure --without-java
RUN make && make install

WORKDIR /usr/src/app

COPY . /usr/src/app

ENV MIX_ENV=prod

RUN mix deps.get
RUN mix do compile

EXPOSE 4000
EXPOSE 1337
