// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/services.dart' show BinaryMessenger;

import 'android_camera_camerax_flutter_api_impls.dart';
import 'camerax_library.g.dart';
import 'instance_manager.dart';
import 'java_object.dart';
import 'recording.dart';

class PendingRecording extends JavaObject {

  PendingRecording.detached({BinaryMessenger? binaryMessenger,
    InstanceManager? instanceManager}) : super.detached(
    binaryMessenger: binaryMessenger,
    instanceManager: instanceManager
  ) {
    _api = PendingRecordingHostApiImpl(binaryMessenger: binaryMessenger,
        instanceManager: instanceManager);
    AndroidCameraXCameraFlutterApis.instance.ensureSetUp();
  }

  Future<Recording> start() { //figure out passing the listener later
    return _api.startFromInstance(this);
  }

  late final PendingRecordingHostApiImpl _api;
}

/// Host API implementation of [PendingRecording]
class PendingRecordingHostApiImpl extends PendingRecordingHostApi {

  /// Constructs a PendingRecordingHostApiImpl
  PendingRecordingHostApiImpl(
  {this.binaryMessenger, InstanceManager? instanceManager})
      : super(binaryMessenger: binaryMessenger) {
    this.instanceManager = instanceManager ?? JavaObject.globalInstanceManager;
  }

  /// Receives binary data across the Flutter platform barrier.
  ///
  /// If it is null, the default BinaryMessenger will be used which routes to
  /// the host platform.
  final BinaryMessenger? binaryMessenger;

  /// Maintains instances stored to communicate with native language objects.
  late final InstanceManager instanceManager;

  Future<Recording> startFromInstance(PendingRecording pendingRecording) async {
    int? instanceId = instanceManager.getIdentifier(pendingRecording);
    instanceId ??= instanceManager.addDartCreatedInstance(pendingRecording,
        onCopy: (PendingRecording original) {
      return PendingRecording.detached(
        binaryMessenger: binaryMessenger,
        instanceManager: instanceManager,
      );
        });
    return instanceManager.getInstanceWithWeakReference(await start(instanceId))! as Recording;
  }
}

class PendingRecordingFlutterApiImpl extends PendingRecordingFlutterApi {
  PendingRecordingFlutterApiImpl({
    this.binaryMessenger,
    InstanceManager? instanceManager,
  }) : instanceManager = instanceManager ?? JavaObject.globalInstanceManager;

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
        PendingRecording.detached(
          binaryMessenger: binaryMessenger,
          instanceManager: instanceManager,
        ),
        identifier,
        onCopy: (PendingRecording original) {
          return PendingRecording.detached(
            binaryMessenger: binaryMessenger,
            instanceManager: instanceManager,
          );
        });
  }
}
