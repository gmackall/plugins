import 'package:flutter/services.dart';

import 'android_camera_camerax_flutter_api_impls.dart';
import 'camerax_library.pigeon.dart';
import 'instance_manager.dart';
import 'java_object.dart';

class Recorder extends JavaObject {
  /// Creates a Recorder. TODO: figure out correct comment style
  Recorder({BinaryMessenger? binaryMessenger,
    InstanceManager? instanceManager,
    this.aspectRatio,
    this.bitRate})
      : super.detached(
      binaryMessenger: binaryMessenger, instanceManager: instanceManager) {
    AndroidCameraXCameraFlutterApis.instance.ensureSetUp();
    _api = RecorderHostApiImpl(binaryMessenger: binaryMessenger, instanceManager: instanceManager);
  }

  Recorder.detached(
      {BinaryMessenger? binaryMessenger, InstanceManager? instanceManager, this.aspectRatio, this.bitRate})
      : super.detached(
      binaryMessenger: binaryMessenger, instanceManager: instanceManager) {
    _api = RecorderHostApiImpl(
        binaryMessenger: binaryMessenger, instanceManager: instanceManager);
    AndroidCameraXCameraFlutterApis.instance.ensureSetUp();
  }

  int? aspectRatio;
  int? bitRate;
  late final RecorderHostApiImpl _api;
}

class RecorderHostApiImpl extends RecorderHostApi {
  ///Creates a RecorderHostApiImpl
  RecorderHostApiImpl(
      {this.binaryMessenger, InstanceManager? instanceManager}) {
    this.instanceManager = instanceManager ?? JavaObject.globalInstanceManager;
  }

  final BinaryMessenger? binaryMessenger;

  late final InstanceManager instanceManager;

  void createFromInstance(Recorder instance, int? aspectRatio, int? bitRate) {
    int? identifier = instanceManager.getIdentifier(instance);
    identifier ??= instanceManager.addDartCreatedInstance(instance,
        onCopy: (Recorder original) {
          return Recorder.detached(binaryMessenger: binaryMessenger,
              instanceManager: instanceManager,
              aspectRatio: aspectRatio,
              bitRate: bitRate);
        });
    create(identifier, aspectRatio, bitRate);
  }
}

class RecorderFlutterApiImpl extends RecorderFlutterApi {

  RecorderFlutterApiImpl(
      {this.binaryMessenger, InstanceManager? instanceManager,
      }) : this.instanceManager = instanceManager ??
      JavaObject.globalInstanceManager;

  final BinaryMessenger? binaryMessenger;
  final InstanceManager instanceManager;

  @override
  void create(int identifier, int? aspectRatio, int? bitRate) {
    instanceManager.addHostCreatedInstance(Recorder.detached(
      binaryMessenger: binaryMessenger,
      instanceManager: instanceManager,
      aspectRatio: aspectRatio,
      bitRate: bitRate,
    ), identifier, onCopy: (Recorder original) {
      return Recorder.detached(
        binaryMessenger: binaryMessenger,
        instanceManager: instanceManager,
        aspectRatio: aspectRatio,
        bitRate: bitRate,
      );
    });
  }
}