// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.camerax;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.camera.video.FileOutputOptions;
import androidx.camera.video.PendingRecording;
import androidx.camera.video.Quality;
import androidx.camera.video.QualitySelector;
import androidx.camera.video.Recorder;

import java.io.File;
import java.util.Objects;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugins.camerax.GeneratedCameraXLibrary.RecorderHostApi;

public class RecorderHostApiImpl implements RecorderHostApi {
    private final BinaryMessenger binaryMessenger;
    private final InstanceManager instanceManager;
    private Context context;

    public RecorderHostApiImpl(
            BinaryMessenger binaryMessenger,
            @NonNull InstanceManager instanceManager,
            Context context) {
        this.binaryMessenger = binaryMessenger;
        this.instanceManager = instanceManager;
        this.context = context;
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

    public void setContext(Context context) {
        this.context = context;
    }

    @NonNull
    @Override
    public Long getAspectRatio(@NonNull Long identifier) {
        Recorder recorder = getRecorderFromInstanceId(identifier);
        return Long.valueOf(recorder.getAspectRatio());
    }

    @NonNull
    @Override
    public Long getTargetVideoEncodingBitRate(@NonNull Long identifier) {
        Recorder recorder = getRecorderFromInstanceId(identifier);
        return Long.valueOf(recorder.getTargetVideoEncodingBitRate());
    }

    @NonNull
    @Override
    public Long prepareRecording(@NonNull Long identifier) {
        Recorder recorder = getRecorderFromInstanceId(identifier);
        //TODO: figure out the proper way for output location to be configured, this is just for
        // local testing
        File file = new File("/Users/mackall/development/cameraTestOutput/test.mp4");
        FileOutputOptions fileOutputOptions = new FileOutputOptions.Builder(file).build();
        PendingRecording pendingRecording = recorder.prepareRecording(context, fileOutputOptions);
        //TODO: should this be initialized elsewhere?

        // Add the pendingRecording to the instance manager and return its id
        PendingRecordingFlutterApiImpl pendingRecordingFlutterApiImpl
                = new PendingRecordingFlutterApiImpl(binaryMessenger, instanceManager);
        pendingRecordingFlutterApiImpl.create(pendingRecording, result -> {});
        return Objects.requireNonNull(
                instanceManager.getIdentifierForStrongReference(pendingRecording));
    }

    private Recorder getRecorderFromInstanceId(Long instanceId) {
        return (Recorder) Objects.requireNonNull(instanceManager.getInstance(instanceId));
    }
}
