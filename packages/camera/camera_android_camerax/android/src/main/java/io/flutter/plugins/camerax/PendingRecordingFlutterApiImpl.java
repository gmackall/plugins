// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.camerax;

import androidx.camera.video.PendingRecording;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugins.camerax.GeneratedCameraXLibrary.PendingRecordingFlutterApi;

public class PendingRecordingFlutterApiImpl extends PendingRecordingFlutterApi {
    private final InstanceManager instanceManager;

    public PendingRecordingFlutterApiImpl(BinaryMessenger binaryMessenger,
                                          InstanceManager instanceManager) {
        super(binaryMessenger);
        this.instanceManager = instanceManager;
    }

    void create(PendingRecording pendingRecording, Reply<Void> reply) {
        create(instanceManager.addHostCreatedInstance(pendingRecording), reply);
    }
}
