import 'package:permission_handler/permission_handler.dart';

class PermissionActionResult<T> {
  final PermissionStatus status;
  final T? result;

  PermissionActionResult(this.status, this.result);
}
