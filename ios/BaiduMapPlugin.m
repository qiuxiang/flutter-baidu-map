#import "BaiduMapPlugin.h"
#if __has_include(<baidu_map/baidu_map-Swift.h>)
#import <baidu_map/baidu_map-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "baidu_map-Swift.h"
#endif

@implementation BaiduMapPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPlugin registerWithRegistrar:registrar];
}
@end
