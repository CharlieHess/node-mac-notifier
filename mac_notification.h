#ifndef NATIVE_EXTENSION_GRAB_H
#define NATIVE_EXTENSION_GRAB_H

#include <nan.h>

using namespace v8;

class MacNotification : public Nan::ObjectWrap {
  public:
    static NAN_MODULE_INIT(Init);

  private:
    explicit MacNotification(const char* title, const char* informativeText);
    ~MacNotification();

    static NAN_METHOD(New);
    static NAN_GETTER(GetTitle);
    static Nan::Persistent<Function> constructor;
    
    const char* _title;
    const char* _informativeText;
};

#endif
