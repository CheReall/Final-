import 'package:dart_application_api/dart_application_api.dart' as dart_application_api;
import 'dart:io';
import 'package:conduit/conduit.dart';
import 'package:dart_application_api/dart_application_api.dart';

void main() async {
  final port = int.parse(Platform.environment["PORT"] ?? '8888');
  final service = Application<AppService>()
    ..options.port = port
    ..options.configurationFilePath = 'config.yaml';
  await service.start(numberOfInstances: 3, consoleLogging: true);
}