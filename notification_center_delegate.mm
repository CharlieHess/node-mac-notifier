#include "notification_center_delegate.h"

@implementation NotificationCenterDelegate

- (id)initWithNotification:(MacNotification *)notification
{
  if (self = [super init]) {
    Notification = notification;
  }

  return self;
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center
     shouldPresentNotification:(NSUserNotification *)notification
{
  return YES;
}

- (void)userNotificationCenter:(NSUserNotificationCenter *)center
       didActivateNotification:(NSUserNotification *)notification
{
  if (notification.activationType == NSUserNotificationActivationTypeReplied) {
    Notification->OnReply(notification.response.string.UTF8String);
  } else {
    Notification->OnClick();
  }
}

@end
