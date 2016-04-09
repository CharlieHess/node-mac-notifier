#include "mac_notification.h"

using v8::FunctionTemplate;

// NativeExtension.cc represents the top level of the module.
// C++ constructs that are exposed to javascript are exported here

NODE_MODULE(Notification, MacNotification::Init)
