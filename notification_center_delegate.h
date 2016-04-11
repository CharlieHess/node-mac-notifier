#import <Foundation/Foundation.h>

typedef void (^ClickCallback)();
typedef void (^ReplyCallback)(const char *response);

@interface NotificationCenterDelegate : NSObject<NSUserNotificationCenterDelegate>
{
  ClickCallback OnClick;
  ReplyCallback OnReply;
}

- (id)initWithClickCallback:(ClickCallback)onClick
              replyCallback:(ReplyCallback)onReply;

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center
     shouldPresentNotification:(NSUserNotification *)notification;
     
- (void)userNotificationCenter:(NSUserNotificationCenter *)center
       didActivateNotification:(NSUserNotification *)notification;

@end