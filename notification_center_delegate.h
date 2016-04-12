#import <Foundation/Foundation.h>

#include <nan.h>
#include "mac_notification.h"

@interface NotificationCenterDelegate : NSObject<NSUserNotificationCenterDelegate>
{
  Nan::Callback *OnClick;
  Nan::Callback *OnReply;
}

- (id)initWithClickCallback:(Nan::Callback *)onClick
              replyCallback:(Nan::Callback *)onReply;
              
- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center
     shouldPresentNotification:(NSUserNotification *)notification;
     
- (void)userNotificationCenter:(NSUserNotificationCenter *)center
       didActivateNotification:(NSUserNotification *)notification;

@end