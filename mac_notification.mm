#import <Foundation/Foundation.h>

#include "mac_notification.h"
#include "notification_center_delegate.h"

using namespace v8;

Nan::Persistent<Function> MacNotification::constructor;

NAN_MODULE_INIT(MacNotification::Init) {
  Local<FunctionTemplate> tpl = Nan::New<FunctionTemplate>(New);
  tpl->SetClassName(Nan::New("MacNotification").ToLocalChecked());
  tpl->InstanceTemplate()->SetInternalFieldCount(2);

  Nan::SetAccessor(tpl->InstanceTemplate(), Nan::New("title").ToLocalChecked(), GetTitle);

  constructor.Reset(Nan::GetFunction(tpl).ToLocalChecked());
  Nan::Set(target, Nan::New("MacNotification").ToLocalChecked(), Nan::GetFunction(tpl).ToLocalChecked());
}

MacNotification::MacNotification(const char* title, const char* informativeText) :
  _title(title),
  _informativeText(informativeText) {
    
  NSUserNotificationCenter *center = [NSUserNotificationCenter defaultUserNotificationCenter];
  NotificationCenterDelegate *delegate = [[NotificationCenterDelegate alloc] init];
  center.delegate = delegate;
  
  NSUserNotification *notification = [[NSUserNotification alloc] init];
  notification.title = [NSString stringWithUTF8String:title];
  notification.informativeText = [NSString stringWithUTF8String:informativeText];
  
  [center deliverNotification:notification];
}

MacNotification::~MacNotification() {
}

NAN_METHOD(MacNotification::New) {
  if (info.IsConstructCall()) {
    std::string title = *String::Utf8Value(info[0]);
    
    MaybeLocal<Object> options = Nan::To<Object>(info[1]);
    if (options.IsEmpty()) {
      Nan::ThrowError("Notification options are required");
      return;
    }
    
    MaybeLocal<Value> maybeBody = Nan::Get(options.ToLocalChecked(), Nan::New("body").ToLocalChecked());
    Local<String> bodyOrEmptyString = maybeBody.IsEmpty() ?
      Nan::New("").ToLocalChecked() :
      Nan::To<String>(maybeBody.ToLocalChecked()).ToLocalChecked();

    std::string body = *String::Utf8Value(bodyOrEmptyString);
    
    MacNotification *notification = new MacNotification(title.c_str(), body.c_str());
    
    notification->Wrap(info.This());
    info.GetReturnValue().Set(info.This());
  } else {
    const int argc = 2; 
    Local<Value> argv[argc] = {info[0], info[1]};
    Local<Function> cons = Nan::New(constructor);
    info.GetReturnValue().Set(cons->NewInstance(argc, argv));
  }
}

NAN_GETTER(MacNotification::GetTitle) {
  MacNotification* notification = Nan::ObjectWrap::Unwrap<MacNotification>(info.This());
  Nan::MaybeLocal<String> result = Nan::New<String>(notification->_title);
  info.GetReturnValue().Set(result.ToLocalChecked());
}
