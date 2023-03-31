import 'package:conduit/conduit.dart';
import 'package:dart_application_api/model/author.dart';
// import 'package:dart_application_api/model/сategory.dart';

class Note extends ManagedObject<_Note> implements _Note {}

class _Note {
  @primaryKey
  int? id;
  @Column(unique: true, indexed: true)
  String? title;
  String? content;
  String? dateCreate;
  String? dateEdit;

  // @Relate(#noteList, isRequired: true, onDelete: DeleteRule.cascade)
  // Category? category;

  @Relate(#noteList, isRequired: true, onDelete: DeleteRule.cascade)
  Author? author;
}

// Содержание, Категория, Дата создания и редактирования