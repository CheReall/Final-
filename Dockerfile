FROM dart

WORKDIR /api

ADD pubspec.* /api/

RUN pub get

ADD . /api/

RUN pub get

WORKDIR /api

EXPOSE 8888

ENTRYPOINT [ "pub", "run", "conduit:conduit", "server", "--port", "8888" ]