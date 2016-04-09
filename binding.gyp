{
  "targets": [{
    "target_name": "Notification",
    "sources": [
      "Notification.cc",
      "mac_notification.mm"
    ],
    "include_dirs": [
      "<!(node -e \"require('nan')\")"
    ],
    "xcode_settings": {
      "OTHER_CPLUSPLUSFLAGS": ["-std=c++11", "-stdlib=libc++", "-mmacosx-version-min=10.8"],
      "OTHER_LDFLAGS": ["-framework CoreFoundation -framework IOKit -framework AppKit"]
    }
  }]
}