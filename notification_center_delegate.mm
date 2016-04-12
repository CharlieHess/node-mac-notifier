#include "notification_center_delegate.h"

@implementation NotificationCenterDelegate

uv_loop_t *defaultLoop = uv_default_loop();
uv_async_t async;

static void AsyncSendHandler(uv_async_t *handle) {
  Nan::HandleScope scope;
  NotificationActivationInfo *info = static_cast<NotificationActivationInfo *>(handle->data);

  v8::Local<v8::Value> argv[2] = {
    Nan::New(info->isReply),
    Nan::New(info->response).ToLocalChecked()
  };
  
  info->callback->Call(2, argv);
}

- (id)initWithActivationCallback:(Nan::Callback *)onActivation 
{
  if (self = [super init]) {
    OnActivation = onActivation;
    
    uv_async_init(defaultLoop, &async, (uv_async_cb)AsyncSendHandler);
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
  Info.isReply = notification.activationType == NSUserNotificationActivationTypeReplied;
  Info.callback = OnActivation;
  
  if (Info.isReply) {
    Info.response = notification.response.string.UTF8String;
  } else {
    Info.response = "";
  }
  
  async.data = &Info;
  uv_async_send(&async);
}

@end
