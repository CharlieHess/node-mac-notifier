#import <objc/runtime.h>

#include "bundle_id_override.h"

@implementation BundleIdentifierOverride

/**
 * This is a little hack to allow our bundle to identify itself as another app.
 * Essentially we swizzle the `NSBundle.bundleIdentifier` method with our own.
 */ 
- (id)initWithBundleId:(NSString *)bundleId
{
  if (self = [super init]) {
    Class nsBundle = objc_getClass("NSBundle");
    
    if (nsBundle) {
      Method originalMethod = class_getInstanceMethod(nsBundle, @selector(bundleIdentifier));
      
      IMP methodOverride = imp_implementationWithBlock(^NSString*(id self, SEL cmd) {
        return bundleId;
      });

      method_setImplementation(originalMethod, methodOverride);
    }
  }
  
  return self;
}

@end