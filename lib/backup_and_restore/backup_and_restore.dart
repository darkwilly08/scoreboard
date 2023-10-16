import 'dart:io';

import 'package:anotador/backup_and_restore/models/backup_type.dart';
import 'package:anotador/model/permission_action_result.dart';
import 'package:anotador/utils/app_data.dart';
import 'package:anotador/utils/date_helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class BackupAndRestore {
  final String downloadPath = "/storage/emulated/0/Download";
  BackupAndRestore._privateConstructor();

  static final BackupAndRestore _instance =
      BackupAndRestore._privateConstructor();

  static BackupAndRestore get instance => _instance;

  Future<PermissionStatus> _validatePermissions() async {
    // is android
    if (Platform.isAndroid) {
      final androidInfo = await AppData.deviceInfo.androidInfo;

      if (androidInfo.version.sdkInt > 32) {
        return PermissionStatus.granted;
      }
    }

    var status = await Permission.storage.status;
    if (status.isDenied) {
      // We didn't ask for permission yet or the permission has been denied before, but not permanently.
      status = await Permission.storage.request();
    }

    return status;
  }

  String _localBackup(File db) {
    final filename =
        "scoreboard_${DateUtils.instance.getFormattedDate(DateTime.now(), null, "yyyyMMddHHmm")}.db";

    final targetPath = "$downloadPath/$filename";
    // TODO: validate permissions
    db.copySync(targetPath);

    return targetPath;
  }

  Future<PermissionActionResult<String>> backup(BackupType backupType) async {
    final status = await _validatePermissions();

    if (!status.isGranted) {
      return PermissionActionResult(status, null);
    }

    final db = await AppData.database;
    final dbFile = File(db.path);

    switch (backupType) {
      case BackupType.local:
        return PermissionActionResult(status, _localBackup(dbFile));
      default:
        throw Exception("Backup type not implemented");
    }
  }

  Future<void> restore() async {
    FilePickerResult? backupFile = await FilePicker.platform.pickFiles();

    if (backupFile == null ||
        backupFile.files.isEmpty ||
        backupFile.files.single.path?.endsWith("db") != true) {
      throw ArgumentError("Invalid backup file");
    }

    final db = await AppData.database;

    try {
      db.close();
      final file = File(backupFile.files.single.path!);
      file.copySync(db.path);
    } catch (e) {
      throw Exception("Error restoring backup");
    } finally {
      AppData.initDatabase();
    }
  }
}
