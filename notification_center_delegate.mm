#include "notification_center_delegate.h"

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
  NotificationActivationInfo *info = static_cast<NotificationActivationInfo *>(handle->data);

  NSLog(@"Invoked notification with id: %s", info->id);

  v8::Local<v8::Value> argv[3] = {
    Nan::New(info->isReply),
    Nan::New(info->response).ToLocalChecked(),
    Nan::New(info->id).ToLocalChecked()
  };

  info->callback->Call(3, argv);

  uv_close((uv_handle_t *)handle, DeleteAsyncHandle);
  handle = nullptr;
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
  Info.isReply = notification.activationType == NSUserNotificationActivationTypeReplied;
  Info.id = strdup(notification.identifier.UTF8String);
  Info.callback = OnActivation;

  if (Info.isReply) {
    Info.response = strdup(notification.response.string.UTF8String);
  } else {
    Info.response = "";
  }

  auto *async = new uv_async_t();
  uv_async_init(uv_default_loop(), async, (uv_async_cb)AsyncSendHandler);

  // Stash a pointer to the activation information and push it onto the libuv
  // event loop. Note that the info must be class-local otherwise it'll be
  // garbage collected before the event is handled.
  async->data = &Info;
  uv_async_send(async);
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center
     shouldPresentNotification:(NSUserNotification *)notification
{
  return YES;
}

@end
