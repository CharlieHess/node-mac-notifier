#ifndef NATIVE_EXTENSION_GRAB_H
#define NATIVE_EXTENSION_GRAB_H

#include <nan.h>

using namespace v8;

class MacNotification : public Nan::ObjectWrap {
  public:
    static NAN_MODULE_INIT(Init);

  private:
    explicit MacNotification(std::string title);
    ~MacNotification();

    static NAN_METHOD(New);
    static NAN_METHOD(GetTitle);
    static Nan::Persistent<Function> constructor;
    std::string title_;
};

#endif
