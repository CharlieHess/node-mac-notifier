#include "mac_notification.h"

// Notification.cc represents the top level of the module.
// C++ constructs that are exposed to javascript are exported here

#if NODE_MAJOR_VERSION >= 10
NAN_MODULE_WORKER_ENABLED(Notification, MacNotification::Init)
#else
NODE_MODULE(Notification, MacNotification::Init)
#endif
