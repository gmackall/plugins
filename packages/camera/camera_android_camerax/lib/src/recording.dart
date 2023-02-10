// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/services.dart' show BinaryMessenger;

import 'android_camera_camerax_flutter_api_impls.dart';
import 'camerax_library.g.dart';
import 'instance_manager.dart';
import 'java_object.dart';

/// Wraps a CameraX recording class.
/// See https://developer.android.com/reference/androidx/camera/video/Recording
class Recording extends JavaObject {
  /// Constructs a detached [Recording]
  Recording.detached({BinaryMessenger? binaryMessenger,
    InstanceManager? instanceManager}) : super.detached(
    binaryMessenger: binaryMessenger,
    instanceManager: instanceManager,
  ) {
    _api = RecordingHostApiImpl(
        binaryMessenger: binaryMessenger,
        instanceManager: instanceManager);
    AndroidCameraXCameraFlutterApis.instance.ensureSetUp();
  }

  late final RecordingHostApiImpl _api;

  Future<void> close() {
    return _api.closeFromInstance(this);
  }

  Future<void> pause() {
    return _api.pauseFromInstance(this);
  }

  Future<void> resume() {
    return _api.resumeFromInstance(this);
  }

  Future<void> stop() {
    return _api.stopFromInstance(this);
  }
}

class RecordingHostApiImpl extends RecordingHostApi {

  /// Creates a [RecordingHostApiImpl]
  RecordingHostApiImpl(
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

  Future<void> closeFromInstance(Recording recording) async {
    close(instanceManager.getIdentifier(recording)!);
  }

  Future<void> pauseFromInstance(Recording recording) async {
    pause(instanceManager.getIdentifier(recording)!);
  }

  Future<void> resumeFromInstance(Recording recording) async {
    resume(instanceManager.getIdentifier(recording)!);
  }

  Future<void> stopFromInstance(Recording recording) async {
    stop(instanceManager.getIdentifier(recording)!);
  }
}


class RecordingFlutterApiImpl extends RecordingFlutterApi {
  RecordingFlutterApiImpl({
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
        Recording.detached(
          binaryMessenger: binaryMessenger,
          instanceManager: instanceManager,
        ),
        identifier,
        onCopy: (Recording original) {
          return Recording.detached(
            binaryMessenger: binaryMessenger,
            instanceManager: instanceManager,
          );
        });
  }
}
