//
//  Focus+Enums.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/30.
//

import UIKit

enum FocusViewControllerSize {
    static let timerViewLength = UIScreen.deviceScreenSize.width * 0.56
}

enum BreathMode {
    static let media = Media(
        id: "",
        name: "Breath",
        explanation: "",
        maxim: "",
        speaker: "",
        color: "",
        mode: 0,
        tag: "",
        thumbnailImageFileName: "",
        videoFileName: "",
        audioFileName: "breath.WAV"
    )
}
