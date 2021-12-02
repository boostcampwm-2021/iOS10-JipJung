//
//  PushNotificationManager.swift
//  JipJung
//
//  Created by turu on 2021/11/25.
//

import Foundation
import UserNotifications

final class PushNotificationMananger {
    static let shared = PushNotificationMananger()
    private init() {}
    
    enum NotificationTitleType: String {
        case focusFinish = "집중 모드 종료"
        case relaxFinish = "휴식 종료"
    }
    
    func presentFocusStopNotification(title: NotificationTitleType, body: String) {
        UNUserNotificationCenter.current().getNotificationSettings { status in
            if status.authorizationStatus == UNAuthorizationStatus.authorized {
                let content = UNMutableNotificationContent()
                content.badge = 0
                content.title = title.rawValue
                content.body = body
                content.sound = .default
                
                let trigger = UNTimeIntervalNotificationTrigger(
                    timeInterval: 0.2,
                    repeats: false
                )
                let request = UNNotificationRequest(
                    identifier: "stopFocus",
                    content: content,
                    trigger: trigger
                )
                
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print(#function, #line, error)
                    }
                }
            } else {
                print("알림 권한이 없음")
            }
        }
    }
}
