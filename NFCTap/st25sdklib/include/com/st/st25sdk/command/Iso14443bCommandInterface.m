//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: st25sdk_ios/command/Iso14443bCommandInterface.java
//

#include "J2ObjC_source.h"
#include "com/st/st25sdk/command/Iso14443bCommandInterface.h"

@interface ComStSt25sdkCommandIso14443bCommandInterface : NSObject

@end

@implementation ComStSt25sdkCommandIso14443bCommandInterface

+ (const J2ObjcClassInfo *)__metadata {
  static J2ObjcMethodInfo methods[] = {
    { NULL, "[B", 0x401, 0, 1, 2, -1, -1, -1 },
    { NULL, "[B", 0x401, 3, 1, 2, -1, -1, -1 },
    { NULL, "V", 0x401, 4, 5, 2, -1, -1, -1 },
    { NULL, "[B", 0x401, 6, 7, 2, -1, -1, -1 },
    { NULL, "[B", 0x401, 8, 5, 2, -1, -1, -1 },
    { NULL, "[B", 0x401, -1, -1, 2, -1, -1, -1 },
    { NULL, "LJavaUtilList;", 0x401, -1, -1, 2, 9, -1, -1 },
  };
  #pragma clang diagnostic push
  #pragma clang diagnostic ignored "-Wobjc-multiple-method-names"
  #pragma clang diagnostic ignored "-Wundeclared-selector"
  methods[0].selector = @selector(reqBWithByte:withByte:);
  methods[1].selector = @selector(wupBWithByte:withByte:);
  methods[2].selector = @selector(hltBWithByteArray:);
  methods[3].selector = @selector(slotMarkerWithByte:);
  methods[4].selector = @selector(attriBWithByteArray:);
  methods[5].selector = @selector(deselect);
  methods[6].selector = @selector(anticollision_iso14443b);
  #pragma clang diagnostic pop
  static const void *ptrTable[] = { "reqB", "BB", "LComStSt25sdkSTException;", "wupB", "hltB", "[B", "slotMarker", "B", "attriB", "()Ljava/util/List<Ljava/lang/String;>;" };
  static const J2ObjcClassInfo _ComStSt25sdkCommandIso14443bCommandInterface = { "Iso14443bCommandInterface", "com.st.st25sdk.command", ptrTable, methods, NULL, 7, 0x609, 7, 0, -1, -1, -1, -1, -1 };
  return &_ComStSt25sdkCommandIso14443bCommandInterface;
}

@end

J2OBJC_INTERFACE_TYPE_LITERAL_SOURCE(ComStSt25sdkCommandIso14443bCommandInterface)