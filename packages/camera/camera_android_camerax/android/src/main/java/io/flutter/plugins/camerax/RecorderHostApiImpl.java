package io.flutter.plugins.camerax;

import androidx.annotation.NonNull;
import androidx.camera.video.Quality;
import androidx.camera.video.QualitySelector;
import androidx.camera.video.Recorder;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugins.camerax.GeneratedCameraXLibrary.RecorderHostApi;

public class RecorderHostApiImpl implements RecorderHostApi {
    private final BinaryMessenger binaryMessenger;
    private final InstanceManager instanceManager;

    public RecorderHostApiImpl(BinaryMessenger binaryMessenger, @NonNull InstanceManager instanceManager) {
        this.binaryMessenger = binaryMessenger;
        this.instanceManager = instanceManager;
    }

    @Override
    public void create(@NonNull Long instanceId, Long aspectRatio, Long bitRate) {
        //TODO: Aspect ratio and bitrate setters are only exposed in the most recent camerax
        //release, so these are useless for now. Also, fix hardcoded quality.
        Recorder.Builder recorderBuilder = new Recorder.Builder();
        Recorder recorder = recorderBuilder
                .setQualitySelector(QualitySelector.from(Quality.SD))
                .build();
        instanceManager.addDartCreatedInstance(recorder, instanceId);
    }

    //TODO: add the rest of the Recorder methods
}
