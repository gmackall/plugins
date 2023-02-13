// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'camera.dart';
import 'camera_info.dart';
import 'camera_selector.dart';
import 'camerax_library.g.dart';
import 'java_object.dart';
import 'pending_recording.dart';
import 'process_camera_provider.dart';
import 'recorder.dart';
import 'recording.dart';
import 'system_services.dart';
import 'video_capture.dart';

/// Handles initialization of Flutter APIs for the Android CameraX library.
class AndroidCameraXCameraFlutterApis {
  /// Creates a [AndroidCameraXCameraFlutterApis].
  AndroidCameraXCameraFlutterApis({
    JavaObjectFlutterApiImpl? javaObjectFlutterApi,
    CameraFlutterApiImpl? cameraFlutterApi,
    CameraInfoFlutterApiImpl? cameraInfoFlutterApi,
    CameraSelectorFlutterApiImpl? cameraSelectorFlutterApi,
    ProcessCameraProviderFlutterApiImpl? processCameraProviderFlutterApi,
    SystemServicesFlutterApiImpl? systemServicesFlutterApi,
    PendingRecordingFlutterApiImpl? pendingRecordingFlutterApi,
    RecordingFlutterApiImpl? recordingFlutterApi,
    RecorderFlutterApiImpl? recorderFlutterApi,
    VideoCaptureFlutterApiImpl? videoCaptureFlutterApi,
  }) {
    this.javaObjectFlutterApi =
        javaObjectFlutterApi ?? JavaObjectFlutterApiImpl();
    this.cameraInfoFlutterApi =
        cameraInfoFlutterApi ?? CameraInfoFlutterApiImpl();
    this.cameraSelectorFlutterApi =
        cameraSelectorFlutterApi ?? CameraSelectorFlutterApiImpl();
    this.processCameraProviderFlutterApi = processCameraProviderFlutterApi ??
        ProcessCameraProviderFlutterApiImpl();
    this.cameraFlutterApi = cameraFlutterApi ?? CameraFlutterApiImpl();
    this.systemServicesFlutterApi =
        systemServicesFlutterApi ?? SystemServicesFlutterApiImpl();
    this.pendingRecordingFlutterApi =
        pendingRecordingFlutterApi ?? PendingRecordingFlutterApiImpl();
    this.recordingFlutterApi =
        recordingFlutterApi ?? RecordingFlutterApiImpl();
    this.recorderFlutterApi =
        recorderFlutterApi ?? RecorderFlutterApiImpl();
    this.videoCaptureFlutterApi =
        videoCaptureFlutterApi ?? VideoCaptureFlutterApiImpl();
  }

  static bool _haveBeenSetUp = false;

  /// Mutable instance containing all Flutter Apis for Android CameraX Camera.
  ///
  /// This should only be changed for testing purposes.
  static AndroidCameraXCameraFlutterApis instance =
      AndroidCameraXCameraFlutterApis();

  /// Handles callbacks methods for the native Java Object class.
  late final JavaObjectFlutterApi javaObjectFlutterApi;

  /// Flutter Api for [CameraInfo].
  late final CameraInfoFlutterApiImpl cameraInfoFlutterApi;

  /// Flutter Api for [CameraSelector].
  late final CameraSelectorFlutterApiImpl cameraSelectorFlutterApi;

  /// Flutter Api for [ProcessCameraProvider].
  late final ProcessCameraProviderFlutterApiImpl
      processCameraProviderFlutterApi;

  /// Flutter Api for [Camera].
  late final CameraFlutterApiImpl cameraFlutterApi;

  /// Flutter Api for [SystemServices].
  late final SystemServicesFlutterApiImpl systemServicesFlutterApi;

  /// Flutter api for [PendingRecording].
  late final PendingRecordingFlutterApiImpl pendingRecordingFlutterApi;

  /// Flutter api for [Recording]
  late final RecordingFlutterApiImpl recordingFlutterApi;

  /// Flutter api for [Recorder]
  late final RecorderFlutterApiImpl recorderFlutterApi;

  /// Flutter api for [VideoCapture]
  late final VideoCaptureFlutterApiImpl videoCaptureFlutterApi;

  /// Ensures all the Flutter APIs have been setup to receive calls from native code.
  void ensureSetUp() {
    if (!_haveBeenSetUp) {
      JavaObjectFlutterApi.setup(javaObjectFlutterApi);
      CameraInfoFlutterApi.setup(cameraInfoFlutterApi);
      CameraSelectorFlutterApi.setup(cameraSelectorFlutterApi);
      ProcessCameraProviderFlutterApi.setup(processCameraProviderFlutterApi);
      CameraFlutterApi.setup(cameraFlutterApi);
      SystemServicesFlutterApi.setup(systemServicesFlutterApi);
      PendingRecordingFlutterApi.setup(pendingRecordingFlutterApi);
      RecordingFlutterApi.setup(recordingFlutterApi);
      RecorderFlutterApi.setup(recorderFlutterApi);
      VideoCaptureFlutterApi.setup(videoCaptureFlutterApi);
      _haveBeenSetUp = true;
    }
  }
}
