#import <Foundation/Foundation.h>

#include "mac_notification.h"

@interface NotificationCenterDelegate : NSObject<NSUserNotificationCenterDelegate>
{
  MacNotification *Notification;
}

- (id)initWithNotification:(MacNotification *)notification;

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center
     shouldPresentNotification:(NSUserNotification *)notification;
     
- (void)userNotificationCenter:(NSUserNotificationCenter *)center
       didActivateNotification:(NSUserNotification *)notification;

@end