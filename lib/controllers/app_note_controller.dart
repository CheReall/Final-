import 'dart:collection';
import 'dart:io';
import 'package:conduit/conduit.dart';
import 'package:dart_application_api/model/response.dart';
import 'package:dart_application_api/utils/app_response.dart';
import '../model/author.dart';
import '../model/note.dart';
import '../model/user.dart';
import '../utils/app_utils.dart';

class AppNoteController extends ResourceController {
  AppNoteController(this.managedContext);
  final ManagedContext managedContext;

  @Operation.post()
  Future<Response> createNote(
    @Bind.header(HttpHeaders.authorizationHeader) String header,
    @Bind.body() Note note,
  ) async {
    try{
      final id = AppUtils.getIdFromHeader(header);

      final author = await managedContext.fetchObjectWithID<Author>(id);
      if (author == null){
        final qCreateAuthor = Query<Author>(managedContext)..values.id = id;
        await qCreateAuthor.insert();
      }
      
      final now = DateTime.now();

      final qCreateNote = Query<Note>(managedContext)
        ..values.author!.id = id
        ..values.title = note.title
        ..values.content = note.content
        ..values.dateCreate = now.toString()
        ..values.dateEdit = now.toString();

      await qCreateNote.insert();

      return AppResponse.ok(
        message: 'Успешное обновление данных',
      );
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка создания заметки');
    }
  }

  @Operation.get()
  Future<Response> getNotes(
    @Bind.header(HttpHeaders.authorizationHeader) String header,
  ) async {
    try {
      final id = AppUtils.getIdFromHeader(header);

      final qCreateNote = Query<Note>(managedContext)
        ..where((x) => x.author!.id).equalTo(id);

      final List<Note> list = await qCreateNote.fetch();

      if (list.isEmpty)
        return Response.notFound(
          body: ModelResponse(data: [], message: "Заметок нет")
        );

      return Response.ok(list);

    } catch(e) {
      return AppResponse.serverError(e, message: 'Ошибка получения заметок');
    }
  }

  @Operation.get("id")
  Future<Response> getNote(
    @Bind.header(HttpHeaders.authorizationHeader) String header,
    @Bind.path("id") int id,
  ) async {
    try {
      final currentAuthorId = AppUtils.getIdFromHeader(header);
      final note = await managedContext.fetchObjectWithID<Note>(id);

      if (note == null){
        return AppResponse.ok(message: "Заметка не найдена");
      }
      if (note.author?.id != currentAuthorId){
        return AppResponse.ok(message: "Отказано в доступе");
      }
      note.backing.removeProperty("author");
      return AppResponse.ok(
        body: note.backing.contents, message: "Успешное создание заметки"
      );

    } catch(e) {
      return AppResponse.serverError(e, message: 'Ошибка создания заметки');
    }
  }

  // @Operation.put()
  // Future<Response> updatePassword(
  //   @Bind.header(HttpHeaders.authorizationHeader) String header,
  //   @Bind.query('newPassword') String newPassword,
  //   @Bind.query('oldPassword') String oldPassword,
  // ) async {
  //   try{
  //     final id = AppUtils.getIdFromHeader(header);
  //     final qFindUser = Query<User>(managedContext)
  //       ..where((element) => element.id).equalTo(id)
  //       ..returningProperties(
  //         (element) => [
  //           element.salt,
  //           element.hashPassword,
  //         ],
  //       );

  //       final fUser = await qFindUser.fetchOne();
  //       final oldHashPassword = generatePasswordHash(oldPassword, fUser!.salt ?? "");
  //       if (oldHashPassword != fUser.hashPassword){
  //         return AppResponse.badrequest(
  //           message: 'Неверный старый пароль',
  //         );
  //       }
  //       final newHashPassword = generatePasswordHash(newPassword, fUser.salt ?? "");
  //       final qUpdateUser = Query<User>(managedContext)
  //         ..where((x) => x.id).equalTo(id)
  //         ..values.hashPassword = newHashPassword;
  //       await qUpdateUser.fetchOne();
  //       return AppResponse.ok(body: 'Пароль успешно обновлен');

  //   } catch (e) {
  //     return AppResponse.serverError(e, message: 'Ошибка обновления данных');
  //   }
  // }
}