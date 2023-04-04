import 'dart:io';
import 'package:conduit/conduit.dart';
import 'package:dart_application_api/controllers/app_note_controller.dart';
import 'package:dart_application_api/model/user.dart';
import 'package:dart_application_api/model/note.dart';
// import 'package:dart_application_api/model/сategory.dart';
import 'package:dart_application_api/controllers/app_auth_controller.dart';

import 'controllers/app_token_controller.dart';
import 'controllers/app_user_controller.dart';

class AppService extends ApplicationChannel {
  late final ManagedContext managedContext;

  @override
  Future prepare() {
    final persistentStore = _initDatabase();

    managedContext = ManagedContext(
      ManagedDataModel.fromCurrentMirrorSystem(), persistentStore);
    return super.prepare();
  }

  @override
  Controller get entryPoint => Router()
    ..route('note/[:id]')
      .link((AppTokenController.new))!
      .link(() => AppNoteController(managedContext))
    ..route('token/[:refresh]')
      .link(() => AppAuthController(managedContext),)
    ..route('user')
      .link(AppTokenController.new)!
      .link(() => AppUserController(managedContext));

  PersistentStore _initDatabase() {
    final username = Platform.environment['DB_USERNAME'] ?? 'postgres';
    final password = Platform.environment['DB_PASSWORD'] ?? '1337';
    final host = Platform.environment['DB_HOST'] ?? 'postgres_database';
    final port = int.parse(Platform.environment['DB_PORT'] ?? '5432');
    final databaseName = Platform.environment['DB_NAME'] ?? 'postgres';
    return PostgreSQLPersistentStore(username, password, host, port, databaseName);
  }

}