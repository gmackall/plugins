package io.flutter.plugins.camerax;

import androidx.annotation.NonNull;
import androidx.camera.video.Recording;

import java.util.Objects;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugins.camerax.GeneratedCameraXLibrary.RecordingHostApi;

public class RecordingHostApiImpl implements RecordingHostApi {
    private final BinaryMessenger binaryMessenger;
    private final InstanceManager instanceManager;

    public RecordingHostApiImpl(
            BinaryMessenger binaryMessenger,
            @NonNull InstanceManager instanceManager) {
        this.binaryMessenger = binaryMessenger;
        this.instanceManager = instanceManager;
    }

    @Override
    public void close(@NonNull Long identifier) {
        Recording recording = getRecordingFromInstanceId(identifier);
        recording.close();
    }

    @Override
    public void pause(@NonNull Long identifier) {
        Recording recording = getRecordingFromInstanceId(identifier);
        recording.pause();
    }

    @Override
    public void resume(@NonNull Long identifier) {
        Recording recording = getRecordingFromInstanceId(identifier);
        recording.resume();
    }

    @Override
    public void stop(@NonNull Long identifier) {
        Recording recording = getRecordingFromInstanceId(identifier);
        recording.stop();
    }

    private Recording getRecordingFromInstanceId(Long instanceId) {
        return (Recording) Objects.requireNonNull(instanceManager.getInstance(instanceId));
    }
}
