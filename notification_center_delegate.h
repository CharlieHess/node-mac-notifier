#import <Foundation/Foundation.h>

@interface NotificationCenterDelegate : NSObject<NSUserNotificationCenterDelegate> 

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center
     shouldPresentNotification:(NSUserNotification *)notification;
     
- (void)userNotificationCenter:(NSUserNotificationCenter *)center
       didActivateNotification:(NSUserNotification *)notification;

@end