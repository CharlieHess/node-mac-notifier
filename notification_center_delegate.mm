#include "notification_center_delegate.h"

#include <string>

struct NotificationActivationInfo {
  Nan::Callback *callback;
  bool isReply;
  std::string response;
  std::string id;
};

@implementation NotificationCenterDelegate

static void DeleteAsyncHandle(uv_handle_t *handle) {
  delete (uv_async_t *)handle;
}

/**
 * This handler runs in the V8 context as a result of `uv_async_send`. Here we
 * retrieve our event information and invoke the saved callback.
 */
static void AsyncSendHandler(uv_async_t *handle) {
  Nan::HandleScope scope;

  auto *info = static_cast<NotificationActivationInfo *>(handle->data);

  NSLog(@"Invoked notification with id: %s", info->id.c_str());

  v8::Local<v8::Value> argv[3] = {
    Nan::New(info->isReply),
    Nan::New(info->response).ToLocalChecked(),
    Nan::New(info->id).ToLocalChecked()
  };

  info->callback->Call(3, argv);

  delete info;
  info = nullptr;
  handle->data = nullptr;

  uv_close((uv_handle_t *)handle, DeleteAsyncHandle);
}

/**
 * We save off the JavaScript callback here and initialize the libuv event
 * loop, which is needed in order to invoke the callback.
 */
- (id)initWithActivationCallback:(Nan::Callback *)onActivation
{
  if (self = [super init]) {
    OnActivation = onActivation;
  }

  return self;
}

/**
 * Occurs when the user activates a notification by clicking it or replying.
 */
- (void)userNotificationCenter:(NSUserNotificationCenter *)center
       didActivateNotification:(NSUserNotification *)notification
{
  auto *info = new NotificationActivationInfo();
  info->isReply = notification.activationType == NSUserNotificationActivationTypeReplied;
  info->id = notification.identifier.UTF8String;
  info->callback = OnActivation;

  if (info->isReply) {
    info->response = notification.response.string.UTF8String;
  }

  auto *async = new uv_async_t();
  async->data = info;
  uv_async_init(uv_default_loop(), async, (uv_async_cb)AsyncSendHandler);
  uv_async_send(async);
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center
     shouldPresentNotification:(NSUserNotification *)notification
{
  return YES;
}

@end
