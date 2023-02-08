package io.flutter.plugins.camerax;

import androidx.annotation.NonNull;
import androidx.camera.video.Recorder;
import androidx.camera.video.VideoCapture;

import java.util.Objects;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugins.camerax.GeneratedCameraXLibrary.VideoCaptureHostApi;

public class VideoCaptureHostApiImpl implements VideoCaptureHostApi {
    private final BinaryMessenger binaryMessenger;
    private final InstanceManager instanceManager;

    public VideoCaptureHostApiImpl(
            BinaryMessenger binaryMessenger, InstanceManager instanceManager) {
        this.binaryMessenger = binaryMessenger;
        this.instanceManager = instanceManager;
    }

    @Override
    public void create(@NonNull Long identifier) {
        //TODO: implement or delete
    }

    @Override
    @NonNull
    public Long withOutput(@NonNull Long identifier, @NonNull Long videoOutputId) {
        //TODO: allow configuration here, maybe other implementations of VideoOutput interface
        Recorder recorder = (Recorder) Objects.requireNonNull(instanceManager.getInstance(videoOutputId));
        VideoCapture<Recorder> videoCapture = VideoCapture.withOutput(recorder);
        final VideoCaptureFlutterApiImpl videoCaptureFlutterApi =
                new VideoCaptureFlutterApiImpl(binaryMessenger, instanceManager);
        if (!instanceManager.containsInstance(videoCapture)) {
            videoCaptureFlutterApi.create(videoCapture, result -> {});
        }
        return instanceManager.getIdentifierForStrongReference(videoCapture);
    }
}
