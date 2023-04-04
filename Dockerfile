FROM dart

WORKDIR /api

ADD pubspec.* /api/

RUN dart pub get

ADD . /api/

RUN dart pub get --offline --no-precompile

RUN dart pub global activate conduit

WORKDIR /api

EXPOSE 80

ENTRYPOINT [ "dart", "pub", "run", "conduit:conduit", "serve", "--port", "80" ]