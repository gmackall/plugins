// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'preview.dart';
import 'process_camera_provider.dart';
import 'camera.dart';
import 'camera_info.dart';
import 'camera_selector.dart';

import 'package:camera_platform_interface/camera_platform_interface.dart';

import 'video_capture.dart';

/// The Android implementation of [CameraPlatform] that uses the CameraX library.
class AndroidCameraCameraX extends CameraPlatform {
  /// Registers this class as the default instance of [CameraPlatform].
  static void registerWith() {
    CameraPlatform.instance = AndroidCameraCameraX();
  }

  // Objects used to access camera functionality:

  /// The [ProcessCameraProvider] instance used to access camera functionality.
  ProcessCameraProvider? processCameraProvider;

  /// The [Camera] instance returned by the [processCameraProvider] when a [UseCase] is
  /// bound to the lifecycle of the camera it manages.
  Camera? camera;

  // Use cases to configure and bind to ProcessCameraProvider instance:

  /// The [Preview] instance that can be instantiated adn configured to present
  /// a live camera preview.
  Preview? preview;

  /// The [VideoCapture] instance that can be instantiated and configured to
  /// handle video recording
  VideoCapture? videoCapture;

  // Objects used for camera configuration:
  CameraSelector? _cameraSelector;


  /// Returns list of all available cameras and their descriptions.
  @override
  Future<List<CameraDescription>> availableCameras() async {
    final List<CameraDescription> cameraDescriptions = <CameraDescription>[];

    ProcessCameraProvider processCameraProvider =
        await ProcessCameraProvider.getInstance();
    final List<CameraInfo> cameraInfos =
        await processCameraProvider!.getAvailableCameraInfos();

    final CameraSelector backCameraSelector =
        CameraSelector.getDefaultBackCamera();
    final CameraSelector frontCameraSelector =
        CameraSelector.getDefaultFrontCamera();

    CameraLensDirection cameraLensDirection;
    int cameraCount = 0;
    int cameraSensorOrientation;
    String cameraName;

    for (final CameraInfo cameraInfo in cameraInfos) {
      // Determine the lens direction by filtering the CameraInfo
      // TODO(gmackall): replace this with call to CameraInfo.getLensFacing when changes containing that method are available
      if ((await backCameraSelector.filter(<CameraInfo>[cameraInfo]))
          .isNotEmpty) {
        cameraLensDirection = CameraLensDirection.back;
      } else if ((await frontCameraSelector.filter(<CameraInfo>[cameraInfo]))
          .isNotEmpty) {
        cameraLensDirection = CameraLensDirection.front;
      } else {
        //Skip this CameraInfo as its lens direction is unknown
        continue;
      }

      cameraSensorOrientation = await cameraInfo.getSensorRotationDegrees();
      cameraName = 'Camera $cameraCount';
      cameraCount++;

      cameraDescriptions.add(CameraDescription(
          name: cameraName,
          lensDirection: cameraLensDirection,
          sensorOrientation: cameraSensorOrientation));
    }

    return cameraDescriptions;
  }

  @override
  Future<void> startVideoRecording(int cameraId, {Duration? maxVideoDuration}) {
    //so if VideoCapture<T> is of type VideoCapture<Recorder>, then this needs to be
    //PendingRecording pendingRecording = videoCapture.getOutput().prepareRecording(~args~) NOTE: file goes in args
    //Recording recording = pendingRecording.start()
    //then return
    return Future.value(null);
  }

  @override
  Future<XFile> stopVideoRecording(int cameraId) {
    //Recording.stop(), then return the file we saved to class level from startVideoRecording
    //probably add asserts here to ensure that this method isn't called before startVideoRecording,
    //or else the saved file variable will not have been initialized
    return Future.value(XFile('/'));
  }

  Future<void> pauseVideoRecording(int cameraId) {
    //Should be as simple as Recording.pause();, with asserts that the recording is initialized
    throw UnimplementedError('pauseVideoRecording() is not implemented.');
  }

  Future<void> _bindVideoRecordingToLifecycle() async {
    assert(processCameraProvider != null);
    assert(_cameraSelector != null);

    // TODO: figure out if binding this singleton list will unbind what has been bound
    // already, and if so handle it by binding them all
    camera = await processCameraProvider!.bindToLifecycle(_cameraSelector!, [videoCapture!]);
  }

  Future<XFile> _unbindVideoRecordingFromLifecycle() async {
    if (videoCapture == null) {
      return XFile('path'); // TODO: fix this case, should it be an error? Or return empty file?
    }

    assert(processCameraProvider != null);
    processCameraProvider!.unbind([videoCapture!]);
    return XFile('path');
  }
}
