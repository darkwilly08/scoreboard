import 'package:anotador/backup_and_restore/models/backup_type.dart';

class Backup {
  final String name;
  final BackupType type;

  Backup(this.type, this.name);

  @override
  String toString() {
    return name;
  }
}
