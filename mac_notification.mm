#include "mac_notification.h"

using namespace v8;

Nan::Persistent<Function> MacNotification::constructor;

NAN_MODULE_INIT(MacNotification::Init) {
  Local<FunctionTemplate> tpl = Nan::New<FunctionTemplate>(New);
  tpl->SetClassName(Nan::New("MacNotification").ToLocalChecked());
  tpl->InstanceTemplate()->SetInternalFieldCount(1);

  Nan::SetPrototypeMethod(tpl, "getTitle", GetTitle);

  constructor.Reset(Nan::GetFunction(tpl).ToLocalChecked());
  Nan::Set(target, Nan::New("MacNotification").ToLocalChecked(), Nan::GetFunction(tpl).ToLocalChecked());
}

MacNotification::MacNotification(std::string title) : title_(title) {
}

MacNotification::~MacNotification() {
}

NAN_METHOD(MacNotification::New) {
  if (info.IsConstructCall()) {
    std::string title = *String::Utf8Value(info[0]);
    MacNotification *notification = new MacNotification(title);
    notification->Wrap(info.This());
    info.GetReturnValue().Set(info.This());
  } else {
    const int argc = 1; 
    Local<Value> argv[argc] = {info[0]};
    Local<Function> cons = Nan::New(constructor);
    info.GetReturnValue().Set(cons->NewInstance(argc, argv));
  }
}

NAN_METHOD(MacNotification::GetTitle) {
  MacNotification* notification = Nan::ObjectWrap::Unwrap<MacNotification>(info.This());
  std::string& title = notification->title_;
  Nan::MaybeLocal<String> result = Nan::New<String>(title.data(), title.size());
  info.GetReturnValue().Set(result.ToLocalChecked());
}
