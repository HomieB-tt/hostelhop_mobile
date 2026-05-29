import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static final PermissionService _instance = PermissionService._internal();
  factory PermissionService() => _instance;
  PermissionService._internal();

  Future<bool> isLocationGranted() async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  Future<LocationPermission> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission;
  }

  Future<bool> isCameraGranted() async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }

  Future<PermissionStatus> requestCameraPermission() async {
    final status = await Permission.camera.status;
    if (!status.isGranted) {
      return Permission.camera.request();
    }
    return status;
  }

  Future<bool> isStorageGranted() async {
    final status = await Permission.storage.status;
    return status.isGranted;
  }

  Future<PermissionStatus> requestStoragePermission() async {
    final status = await Permission.storage.status;
    if (!status.isGranted) {
      return Permission.storage.request();
    }
    return status;
  }

  Future<bool> isSmsGranted() async {
    final status = await Permission.sms.status;
    return status.isGranted;
  }

  Future<PermissionStatus> requestSmsPermission() async {
    final status = await Permission.sms.status;
    if (!status.isGranted) {
      return Permission.sms.request();
    }
    return status;
  }

  Future<Map<Permission, PermissionStatus>> requestAllPermissions() async {
    final Map<Permission, PermissionStatus> statuses = {};

    final locationPermission = await requestLocationPermission();
    statuses[Permission.location] =
        locationPermission == LocationPermission.whileInUse ||
            locationPermission == LocationPermission.always
        ? PermissionStatus.granted
        : PermissionStatus.denied;

    final cameraStatus = await requestCameraPermission();
    statuses[Permission.camera] = cameraStatus;

    final storageStatus = await requestStoragePermission();
    statuses[Permission.storage] = storageStatus;

    statuses[Permission.sms] = await requestSmsPermission();

    return statuses;
  }

  Future<bool> openAppSettings() async {
    return openAppSettings();
  }
}
