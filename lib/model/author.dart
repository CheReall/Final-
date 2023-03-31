import 'package:conduit/conduit.dart';
import 'package:dart_application_api/model/note.dart';

class Author extends ManagedObject<_Author> implements _Author {}

class _Author {
  @primaryKey
  int? id;

  ManagedSet<Note>? noteList;
}