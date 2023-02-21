// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.camerax;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.camera.video.Recorder;
import androidx.camera.video.VideoCapture;
import androidx.core.content.ContextCompat;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugins.camerax.GeneratedCameraXLibrary.VideoCaptureHostApi;

public class VideoCaptureHostApiImpl implements VideoCaptureHostApi {
    private final BinaryMessenger binaryMessenger;
    private final InstanceManager instanceManager;
    private Context context;

    public VideoCaptureHostApiImpl(
            BinaryMessenger binaryMessenger, InstanceManager instanceManager, Context context) {
        this.binaryMessenger = binaryMessenger;
        this.instanceManager = instanceManager;
        this.context = context;
    }

    @Override
    public void create(@NonNull Long identifier) {
        //TODO: implement or delete
    }

    public void setContext(Context context) {
        this.context = context;
    }

    @Override
    @NonNull
    public Long withOutput(@NonNull Long videoOutputId) {
        System.out.println("At start of withOutput");
        //TODO: allow configuration here, maybe other implementations of VideoOutput interface
        //Recorder recorder = (Recorder) Objects.requireNonNull(instanceManager.getInstance(videoOutputId));
        Recorder recorder = new Recorder.Builder()
                .setExecutor(ContextCompat.getMainExecutor(context))
                .build();

        RecorderFlutterApiImpl recorderFlutterApi = new RecorderFlutterApiImpl(
                binaryMessenger, instanceManager);
        recorderFlutterApi.create(recorder, 1L, 1L, result -> {});
        VideoCapture<Recorder> videoCapture = VideoCapture.withOutput(recorder);
        final VideoCaptureFlutterApiImpl videoCaptureFlutterApi =
                new VideoCaptureFlutterApiImpl(binaryMessenger, instanceManager);
        //if (!instanceManager.containsInstance(videoCapture)) {
        videoCaptureFlutterApi.create(videoCapture, result -> {});
        //}
        System.out.println("id is");
        System.out.println(instanceManager.getIdentifierForStrongReference(videoCapture));
        return instanceManager.getIdentifierForStrongReference(videoCapture);
    }

    @Override
    @NonNull
    public Long getOutput(Long identifier) {
        VideoCapture<Recorder> videoCapture = instanceManager.getInstance(identifier);
        Recorder recorder = videoCapture.getOutput();
        Long recorderId = instanceManager.getIdentifierForStrongReference(recorder);
        return recorderId;
    }
}
