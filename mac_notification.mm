#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

#include "mac_notification.h"
#include "notification_center_delegate.h"

using namespace v8;

Nan::Persistent<Function> MacNotification::constructor;

NAN_MODULE_INIT(MacNotification::Init) {
  Local<FunctionTemplate> tpl = Nan::New<FunctionTemplate>(New);
  tpl->SetClassName(Nan::New("MacNotification").ToLocalChecked());
  tpl->InstanceTemplate()->SetInternalFieldCount(5);

  Nan::SetMethod(tpl->InstanceTemplate(), "close", Close);
  Nan::SetAccessor(tpl->InstanceTemplate(), Nan::New("id").ToLocalChecked(), GetId);
  Nan::SetAccessor(tpl->InstanceTemplate(), Nan::New("title").ToLocalChecked(), GetTitle);
  Nan::SetAccessor(tpl->InstanceTemplate(), Nan::New("body").ToLocalChecked(), GetBody);
  Nan::SetAccessor(tpl->InstanceTemplate(), Nan::New("icon").ToLocalChecked(), GetIcon);
  Nan::SetAccessor(tpl->InstanceTemplate(), Nan::New("canReply").ToLocalChecked(), GetCanReply);

  constructor.Reset(Nan::GetFunction(tpl).ToLocalChecked());
  Nan::Set(target, Nan::New("MacNotification").ToLocalChecked(), Nan::GetFunction(tpl).ToLocalChecked());
}

MacNotification::MacNotification(Nan::Utf8String *id,
  Nan::Utf8String *title, 
  Nan::Utf8String *body, 
  Nan::Utf8String *icon,
  bool canReply)
  : _id(id), _title(title), _body(body), _icon(icon), _canReply(canReply) {

  NSUserNotification *notification = [[NSUserNotification alloc] init];
  
  if (id != nullptr) notification.identifier = [NSString stringWithUTF8String:**id];
  if (title != nullptr) notification.title = [NSString stringWithUTF8String:**title];
  if (body != nullptr) notification.informativeText = [NSString stringWithUTF8String:**body];
  
  if (icon != nullptr) {
    NSString *iconString = [NSString stringWithUTF8String:**icon];
    NSURL *iconUrl = [NSURL URLWithString:iconString];
    notification.contentImage = [[NSImage alloc] initWithContentsOfURL:iconUrl];
  }
  
  notification.hasReplyButton = canReply;
  
  NSUserNotificationCenter *center = [NSUserNotificationCenter defaultUserNotificationCenter];
  [center deliverNotification:notification];
}

MacNotification::~MacNotification() {
  delete _id;
  delete _title;
  delete _body;
  delete _icon;
}

NAN_METHOD(MacNotification::New) {
  if (info.IsConstructCall()) {
    if (info[0]->IsUndefined()) {
      Nan::ThrowError("Options are required");
      return;
    }
    
    Local<Object> options = info[0].As<Object>();
    
    Nan::Utf8String *id = StringFromObjectOrNull(options, "id");
    Nan::Utf8String *title = StringFromObjectOrNull(options, "title");
    Nan::Utf8String *body = StringFromObjectOrNull(options, "body");
    Nan::Utf8String *icon = StringFromObjectOrNull(options, "icon");
    
    MaybeLocal<Value> canReplyHandle = Nan::Get(options, Nan::New("canReply").ToLocalChecked());
    bool canReply = Nan::To<bool>(canReplyHandle.ToLocalChecked()).FromJust();

    MaybeLocal<Value> activatedHandle = Nan::Get(options, Nan::New("activated").ToLocalChecked());
    Nan::Callback *activated = new Nan::Callback(activatedHandle.ToLocalChecked().As<Function>());

    RegisterDelegate(activated);
    
    MacNotification *notification = new MacNotification(id, title, body, icon, canReply);
    notification->Wrap(info.This());
    info.GetReturnValue().Set(info.This());
  } else {
    const int argc = 1;
    Local<Value> argv[argc] = {info[0]};
    Local<Function> cons = Nan::New(constructor);
    info.GetReturnValue().Set(cons->NewInstance(argc, argv));
  }
}

void MacNotification::RegisterDelegate(Nan::Callback *activated) {
  NotificationCenterDelegate *delegate = [[NotificationCenterDelegate alloc] initWithActivationCallback:activated];
  NSUserNotificationCenter *center = [NSUserNotificationCenter defaultUserNotificationCenter];
  center.delegate = delegate;
}

Nan::Utf8String* MacNotification::StringFromObjectOrNull(Local<Object> object, const char *key) {
  Local<String> keyHandle = Nan::New(key).ToLocalChecked();
  Local<Value> handle = Nan::Get(object, keyHandle).ToLocalChecked();

  return handle->IsUndefined() ?
    nullptr :
    new Nan::Utf8String(handle);
}

NAN_METHOD(MacNotification::Close) {
  MacNotification* notification = Nan::ObjectWrap::Unwrap<MacNotification>(info.This());
  NSString *identifier = [NSString stringWithUTF8String:**(notification->_id)];
  
  NSUserNotificationCenter *center = [NSUserNotificationCenter defaultUserNotificationCenter];
  center.delegate = nil;
  
  for (NSUserNotification *notification in center.deliveredNotifications) {
    if ([notification.identifier isEqualToString:identifier]) {
      [center removeDeliveredNotification:notification];
    }
  }
  
  info.GetReturnValue().SetUndefined();
}

NAN_GETTER(MacNotification::GetId) {
  MacNotification* notification = Nan::ObjectWrap::Unwrap<MacNotification>(info.This());
  Nan::MaybeLocal<String> id = Nan::New(**(notification->_id));
  info.GetReturnValue().Set(id.ToLocalChecked());
}

NAN_GETTER(MacNotification::GetTitle) {
  MacNotification* notification = Nan::ObjectWrap::Unwrap<MacNotification>(info.This());
  Nan::MaybeLocal<String> title = Nan::New(**(notification->_title));
  info.GetReturnValue().Set(title.ToLocalChecked());
}

NAN_GETTER(MacNotification::GetBody) {
  MacNotification* notification = Nan::ObjectWrap::Unwrap<MacNotification>(info.This());
  Nan::MaybeLocal<String> title = Nan::New(**(notification->_body));
  info.GetReturnValue().Set(title.ToLocalChecked());
}

NAN_GETTER(MacNotification::GetIcon) {
  MacNotification* notification = Nan::ObjectWrap::Unwrap<MacNotification>(info.This());
  Nan::MaybeLocal<String> icon = Nan::New(**(notification->_icon));
  info.GetReturnValue().Set(icon.ToLocalChecked());
}

NAN_GETTER(MacNotification::GetCanReply) {
  MacNotification* notification = Nan::ObjectWrap::Unwrap<MacNotification>(info.This());
  info.GetReturnValue().Set(notification->_canReply);
}
