#import <Foundation/Foundation.h>

#include <nan.h>
#include "mac_notification.h"

@interface NotificationCenterDelegate : NSObject<NSUserNotificationCenterDelegate> {
  Nan::Callback *OnActivation;
}

- (id)initWithActivationCallback:(Nan::Callback *)onActivation;

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center
     shouldPresentNotification:(NSUserNotification *)notification;

- (void)userNotificationCenter:(NSUserNotificationCenter *)center
       didActivateNotification:(NSUserNotification *)notification;

@end
