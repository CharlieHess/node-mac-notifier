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

MacNotification::MacNotification(Nan::Utf8String *title, 
  Nan::Utf8String *informativeText,
  Nan::Callback *onClick,
  Nan::Callback *onReply) :
  _title(title),
  _informativeText(informativeText),
  _onClick(onClick),
  _onReply(onReply) {

  NSUserNotificationCenter *center = [NSUserNotificationCenter defaultUserNotificationCenter];
  NotificationCenterDelegate *delegate = [[NotificationCenterDelegate alloc] initWithNotification:this];
  center.delegate = delegate;
  
  NSUserNotification *notification = [[NSUserNotification alloc] init];
  notification.title = [NSString stringWithUTF8String:**title];
  notification.informativeText = [NSString stringWithUTF8String:**informativeText];
  
  [center deliverNotification:notification];
}

MacNotification::~MacNotification() {
  delete _title;
  delete _informativeText;
  delete _onClick;
  delete _onReply;
}

void MacNotification::OnClick() {
  _onClick->Call(0, 0);
}

void MacNotification::OnReply(const char *response) {
  Local<Value> argv[1] = { 
    Nan::New(response).ToLocalChecked()
  };
  _onReply->Call(1, argv);
}

NAN_METHOD(MacNotification::New) {
  if (info.IsConstructCall()) {
    if (info[0]->IsUndefined()) {
      Nan::ThrowError("Title is required");
      return;
    }
    
    Nan::Utf8String *title = new Nan::Utf8String(info[0]);
    MaybeLocal<Object> options = Nan::To<Object>(info[1]);
    
    if (options.IsEmpty()) {
      Nan::ThrowError("Options are required");
      return;
    }
    
    MaybeLocal<Value> maybeBody = Nan::Get(info[1].As<Object>(), Nan::New("body").ToLocalChecked());
    Nan::Utf8String *body = new Nan::Utf8String(maybeBody.ToLocalChecked());
    
    Local<Function> onClickHandle = info[2].As<Function>();
    Nan::Callback *onClick = new Nan::Callback(onClickHandle);
    
    Local<Function> onReplyHandle = info[3].As<Function>();
    Nan::Callback *onReply = new Nan::Callback(onReplyHandle);

    MacNotification *notification = new MacNotification(title, body, onClick, onReply);
    
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
  Nan::MaybeLocal<String> title = Nan::New<String>(**(notification->_title));
  info.GetReturnValue().Set(title.ToLocalChecked());
}
