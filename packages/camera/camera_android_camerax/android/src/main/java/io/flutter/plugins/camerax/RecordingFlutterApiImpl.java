package io.flutter.plugins.camerax;

import androidx.camera.video.Recording;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugins.camerax.GeneratedCameraXLibrary.RecordingFlutterApi;

public class RecordingFlutterApiImpl extends RecordingFlutterApi {
    private final InstanceManager instanceManager;

    public RecordingFlutterApiImpl(BinaryMessenger binaryMessenger,
                                   InstanceManager instanceManager) {
        super(binaryMessenger);
        this.instanceManager = instanceManager;
    }

    void create(Recording recording, Reply<Void> reply) {
        create(instanceManager.addHostCreatedInstance(recording), reply);
    }
}
