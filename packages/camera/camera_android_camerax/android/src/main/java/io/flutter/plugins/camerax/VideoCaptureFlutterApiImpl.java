package io.flutter.plugins.camerax;

import androidx.camera.core.Camera;
import androidx.camera.video.Recorder;
import androidx.camera.video.VideoCapture;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugins.camerax.GeneratedCameraXLibrary.VideoCaptureFlutterApi;

public class VideoCaptureFlutterApiImpl extends VideoCaptureFlutterApi {
    public VideoCaptureFlutterApiImpl(BinaryMessenger binaryMessenger, InstanceManager instanceManager) {
        super(binaryMessenger);
        this.instanceManager = instanceManager;
    }

    private final InstanceManager instanceManager;

    void create(VideoCapture<Recorder> videoCapture, Reply<Void> reply) {
        create(instanceManager.addHostCreatedInstance(videoCapture), reply);
    }
}
