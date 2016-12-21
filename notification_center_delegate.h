#import <Foundation/Foundation.h>

#include <string>

#include <nan.h>
#include "mac_notification.h"

struct NotificationActivationInfo {
  Nan::Callback *callback;
  bool isReply;
  std::string response;
  std::string id;
};

@interface NotificationCenterDelegate : NSObject<NSUserNotificationCenterDelegate> {
  Nan::Callback *OnActivation;
  NotificationActivationInfo Info;
}

- (id)initWithActivationCallback:(Nan::Callback *)onActivation;

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center
     shouldPresentNotification:(NSUserNotification *)notification;

- (void)userNotificationCenter:(NSUserNotificationCenter *)center
       didActivateNotification:(NSUserNotification *)notification;

@end
