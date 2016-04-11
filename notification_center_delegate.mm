#include "notification_center_delegate.h"

@implementation NotificationCenterDelegate

- (id)initWithClickCallback:(ClickCallback)onClick
              replyCallback:(ReplyCallback)onReply
{
  if (self = [super init]) {
    OnClick = onClick;
    OnReply = onReply;
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
    OnReply(notification.response.string.UTF8String);
  } else {
    OnClick();
  }
}

@end
