#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

#include "mac_notification.h"
#include "notification_center_delegate.h"
#include "bundle_id_override.h"

using namespace v8;

Nan::Persistent<Function> MacNotification::constructor;

NAN_MODULE_INIT(MacNotification::Init) {
  Local<FunctionTemplate> tpl = Nan::New<FunctionTemplate>(New);
  tpl->SetClassName(Nan::New("MacNotification").ToLocalChecked());
  tpl->InstanceTemplate()->SetInternalFieldCount(8);

  Nan::SetMethod(tpl->InstanceTemplate(), "close", Close);
  Nan::SetAccessor(tpl->InstanceTemplate(), Nan::New("id").ToLocalChecked(), GetId);
  Nan::SetAccessor(tpl->InstanceTemplate(), Nan::New("title").ToLocalChecked(), GetTitle);
  Nan::SetAccessor(tpl->InstanceTemplate(), Nan::New("subtitle").ToLocalChecked(), GetSubtitle);
  Nan::SetAccessor(tpl->InstanceTemplate(), Nan::New("body").ToLocalChecked(), GetBody);
  Nan::SetAccessor(tpl->InstanceTemplate(), Nan::New("icon").ToLocalChecked(), GetIcon);
  Nan::SetAccessor(tpl->InstanceTemplate(), Nan::New("soundName").ToLocalChecked(), GetSoundName);
  Nan::SetAccessor(tpl->InstanceTemplate(), Nan::New("canReply").ToLocalChecked(), GetCanReply);
  Nan::SetAccessor(tpl->InstanceTemplate(), Nan::New("otherButtonTitle").ToLocalChecked(), GetOtherButtonTitle);
  Nan::SetAccessor(tpl->InstanceTemplate(), Nan::New("bundleId").ToLocalChecked(), GetBundleId);

  constructor.Reset(Nan::GetFunction(tpl).ToLocalChecked());
  Nan::Set(target, Nan::New("MacNotification").ToLocalChecked(), Nan::GetFunction(tpl).ToLocalChecked());
}

MacNotification::MacNotification(Nan::Utf8String *id,
  Nan::Utf8String *title,
  Nan::Utf8String *subtitle,
  Nan::Utf8String *body,
  Nan::Utf8String *icon,
  Nan::Utf8String *soundName,
  bool canReply,
  Nan::Utf8String *otherButtonTitle)
  : _id(id), _title(title), _subtitle(subtitle), _body(body), _icon(icon), _soundName(soundName), _otherButtonTitle(otherButtonTitle), _canReply(canReply) {

  NSUserNotification *notification = [[NSUserNotification alloc] init];

  if (id != nullptr) notification.identifier = [NSString stringWithUTF8String:**id];
  if (title != nullptr) notification.title = [NSString stringWithUTF8String:**title];
  if (subtitle != nullptr) notification.subtitle = [NSString stringWithUTF8String:**subtitle];
  if (body != nullptr) notification.informativeText = [NSString stringWithUTF8String:**body];
  if (otherButtonTitle != nullptr) notification.otherButtonTitle = [NSString stringWithUTF8String:**otherButtonTitle];

  if (icon != nullptr) {
    NSString *iconString = [NSString stringWithUTF8String:**icon];
    NSURL *iconUrl = [NSURL URLWithString:iconString];
    notification.contentImage = [[NSImage alloc] initWithContentsOfURL:iconUrl];
  }

  if (soundName != nullptr) {
    NSString *soundString = [NSString stringWithUTF8String:**soundName];
    notification.soundName = [soundString isEqualToString:@"default"] ?
      NSUserNotificationDefaultSoundName :
      soundString;
  }

  notification.hasReplyButton = canReply;

  NSUserNotificationCenter *center = [NSUserNotificationCenter defaultUserNotificationCenter];
  [center deliverNotification:notification];
}

MacNotification::~MacNotification() {
  delete _id;
  delete _title;
  delete _subtitle;
  delete _body;
  delete _icon;
  delete _soundName;
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
    Nan::Utf8String *subtitle = StringFromObjectOrNull(options, "subtitle");
    Nan::Utf8String *body = StringFromObjectOrNull(options, "body");
    Nan::Utf8String *icon = StringFromObjectOrNull(options, "icon");
    Nan::Utf8String *soundName = StringFromObjectOrNull(options, "soundName");
    Nan::Utf8String *otherButtonTitle = StringFromObjectOrNull(options, "otherButtonTitle");

    MaybeLocal<Value> canReplyHandle = Nan::Get(options, Nan::New("canReply").ToLocalChecked());
    bool canReply = Nan::To<bool>(canReplyHandle.ToLocalChecked()).FromJust();

    RegisterDelegateFromOptions(options);

    MacNotification *notification = new MacNotification(id, title, subtitle, body, icon, soundName, canReply, otherButtonTitle);
    notification->Wrap(info.This());
    info.GetReturnValue().Set(info.This());
  } else {
    const int argc = 1;
    Local<Value> argv[argc] = {info[0]};
    Local<Function> cons = Nan::New(constructor);
    info.GetReturnValue().Set(Nan::NewInstance(cons, argc, argv).ToLocalChecked());
  }
}

NAN_METHOD(MacNotification::Close) {
  MacNotification* notification = Nan::ObjectWrap::Unwrap<MacNotification>(info.This());
  NSString *identifier = [NSString stringWithUTF8String:**(notification->_id)];

  NSUserNotificationCenter *center = [NSUserNotificationCenter defaultUserNotificationCenter];

  for (NSUserNotification *notification in center.deliveredNotifications) {
    if ([notification.identifier isEqualToString:identifier]) {
      [center removeDeliveredNotification:notification];
    }
  }

  info.GetReturnValue().SetUndefined();
}

NAN_GETTER(MacNotification::GetId) {
  auto noti = Nan::ObjectWrap::Unwrap<MacNotification>(info.This());
  SetStringOrUndefined(info.GetReturnValue(), noti->_id);
}

NAN_GETTER(MacNotification::GetTitle) {
  auto noti = Nan::ObjectWrap::Unwrap<MacNotification>(info.This());
  SetStringOrUndefined(info.GetReturnValue(), noti->_title);
}

NAN_GETTER(MacNotification::GetSubtitle) {
  auto noti = Nan::ObjectWrap::Unwrap<MacNotification>(info.This());
  SetStringOrUndefined(info.GetReturnValue(), noti->_subtitle);
}

NAN_GETTER(MacNotification::GetBody) {
  auto noti = Nan::ObjectWrap::Unwrap<MacNotification>(info.This());
  SetStringOrUndefined(info.GetReturnValue(), noti->_body);
}

NAN_GETTER(MacNotification::GetIcon) {
  auto noti = Nan::ObjectWrap::Unwrap<MacNotification>(info.This());
  SetStringOrUndefined(info.GetReturnValue(), noti->_icon);
}

NAN_GETTER(MacNotification::GetSoundName) {
  auto noti = Nan::ObjectWrap::Unwrap<MacNotification>(info.This());
  SetStringOrUndefined(info.GetReturnValue(), noti->_soundName);
}

NAN_GETTER(MacNotification::GetCanReply) {
  MacNotification* notification = Nan::ObjectWrap::Unwrap<MacNotification>(info.This());
  info.GetReturnValue().Set(notification->_canReply);
}

NAN_GETTER(MacNotification::GetOtherButtonTitle) {
  auto noti = Nan::ObjectWrap::Unwrap<MacNotification>(info.This());
  SetStringOrUndefined(info.GetReturnValue(), noti->_otherButtonTitle);
}

NAN_GETTER(MacNotification::GetBundleId) {
  NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
  if (bundleId) {
    Nan::MaybeLocal<String> bundleString = Nan::New(bundleId.UTF8String);
    info.GetReturnValue().Set(bundleString.ToLocalChecked());
  } else {
    info.GetReturnValue().Set(Nan::Null());
  }
}

void MacNotification::RegisterDelegateFromOptions(Local<Object> options) {
  MaybeLocal<Value> activatedHandle = Nan::Get(options, Nan::New("activated").ToLocalChecked());
  Nan::Callback *activated = new Nan::Callback(activatedHandle.ToLocalChecked().As<Function>());

  Nan::Utf8String *bundleId = StringFromObjectOrNull(options, "bundleId");
  if (bundleId != nullptr) {
    [[BundleIdentifierOverride alloc] initWithBundleId:[NSString stringWithUTF8String:**bundleId]];
  }

  NotificationCenterDelegate *delegate = [[NotificationCenterDelegate alloc] initWithActivationCallback:activated];
  NSUserNotificationCenter *center = [NSUserNotificationCenter defaultUserNotificationCenter];
  center.delegate = delegate;
}

Nan::Utf8String* MacNotification::StringFromObjectOrNull(Local<Object> object, const char *key) {
  Local<String> keyHandle = Nan::New(key).ToLocalChecked();
  MaybeLocal<Value> handle = Nan::Get(object, keyHandle);

  if (handle.IsEmpty()) return nullptr;
  if (Nan::Equals(handle.ToLocalChecked(), Nan::Undefined()).FromJust()) return nullptr;

  return new Nan::Utf8String(handle.ToLocalChecked());
}

void MacNotification::SetStringOrUndefined(Nan::ReturnValue<Value> ret, Nan::Utf8String *prop) {
  if (prop != nullptr) {
    ret.Set(Nan::New(**prop).ToLocalChecked());
  } else {
    ret.SetUndefined();
  }
}
