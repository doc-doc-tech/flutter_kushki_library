#import "FlutterKushkiLibraryPlugin.h"
#if __has_include(<flutter_kushki_library/flutter_kushki_library-Swift.h>)
#import <flutter_kushki_library/flutter_kushki_library-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_kushki_library-Swift.h"
#endif

@implementation FlutterKushkiLibraryPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterKushkiLibraryPlugin registerWithRegistrar:registrar];
}
@end
