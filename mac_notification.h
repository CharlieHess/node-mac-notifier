#ifndef NATIVE_EXTENSION_GRAB_H
#define NATIVE_EXTENSION_GRAB_H

#include <nan.h>

using namespace v8;

class MacNotification : public Nan::ObjectWrap {
  public:
    static NAN_MODULE_INIT(Init);

  private:
    explicit MacNotification(Nan::Utf8String *title, Nan::Utf8String *informativeText);
    ~MacNotification();

    static NAN_METHOD(New);
    static NAN_GETTER(GetTitle);
    static Nan::Persistent<Function> constructor;
    
    Nan::Utf8String *_title;
    Nan::Utf8String *_informativeText;
};

#endif
