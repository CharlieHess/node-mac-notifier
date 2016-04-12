#include "notification_center_delegate.h"

@implementation NotificationCenterDelegate

- (id)initWithClickCallback:(Nan::Callback *)onClick
              replyCallback:(Nan::Callback *)onReply
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
    v8::Local<v8::Value> argv[1] = { 
      Nan::New(notification.response.string.UTF8String).ToLocalChecked()
    };
    OnReply->Call(1, argv);
  } else {
    OnClick->Call(0, 0);
  }
}

@end
