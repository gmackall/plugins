import 'package:flutter/services.dart';

import 'android_camera_camerax_flutter_api_impls.dart';
import 'camerax_library.pigeon.dart';
import 'instance_manager.dart';
import 'java_object.dart';
import 'use_case.dart';

class VideoCapture extends UseCase {
  //Creates a that is not automatically attached to a native object.
  VideoCapture.detached({BinaryMessenger? binaryMessenger,
    InstanceManager? instanceManager})
      : super.detached(
      binaryMessenger: binaryMessenger,
      instanceManager: instanceManager) {
    _api = VideoCaptureHostApiImpl(
        binaryMessenger: binaryMessenger, instanceManager: instanceManager);
    AndroidCameraXCameraFlutterApis.instance.ensureSetUp();
  }

  //Creates a VideoCapture.
  VideoCapture({BinaryMessenger? binaryMessenger,
    InstanceManager? instanceManager})
      : super.detached(
      binaryMessenger: binaryMessenger,
      instanceManager: instanceManager) {
    _api = VideoCaptureHostApiImpl(
        binaryMessenger: binaryMessenger, instanceManager: instanceManager);
    AndroidCameraXCameraFlutterApis.instance.ensureSetUp();
    _api.createFromInstance(this);
  }

  late final VideoCaptureHostApiImpl _api;
}


class VideoCaptureHostApiImpl extends VideoCaptureHostApi {
  VideoCaptureHostApiImpl({this.binaryMessenger,
    InstanceManager? instanceManager}) {
    this.instanceManager = instanceManager ?? JavaObject.globalInstanceManager;
  }

  /// Receives binary data across the Flutter platform barrier.
  ///
  /// If it is null, the default BinaryMessenger will be used which routes to
  /// the host platform.
  final BinaryMessenger? binaryMessenger;

  /// Maintains instances stored to communicate with native language objects.
  late final InstanceManager instanceManager;

  void createFromInstance(VideoCapture instance) {
    int? identifier = instanceManager.getIdentifier(instance);
    identifier ??= instanceManager.addDartCreatedInstance(
        instance,
        onCopy: (VideoCapture original) {
          return VideoCapture(binaryMessenger: binaryMessenger,
              instanceManager: instanceManager);
        });
    create(identifier);
  }
}


class VideoCaptureFlutterApiImpl implements VideoCaptureFlutterApi {
  VideoCaptureFlutterApiImpl(
      {this.binaryMessenger, InstanceManager? instanceManager,
      })
      : instanceManager = instanceManager ?? JavaObject.globalInstanceManager;

  /// Receives binary data across the Flutter platform barrier.
  ///
  /// If it is null, the default BinaryMessenger will be used which routes to
  /// the host platform.
  final BinaryMessenger? binaryMessenger;

  /// Maintains instances stored to communicate with native language objects.
  final InstanceManager instanceManager;

  @override
  void create(int identifier) {
    instanceManager.addHostCreatedInstance(
        VideoCapture.detached(
          binaryMessenger: binaryMessenger,
          instanceManager: instanceManager,
        ),
        identifier,
        onCopy: (VideoCapture original) {
          return VideoCapture.detached(
            binaryMessenger: binaryMessenger,
            instanceManager: instanceManager,
          )
        })
  }
}