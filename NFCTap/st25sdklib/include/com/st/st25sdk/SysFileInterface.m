//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: st25sdk_ios/SysFileInterface.java
//

#include "J2ObjC_source.h"
#include "com/st/st25sdk/SysFileInterface.h"

@interface ComStSt25sdkSysFileInterface : NSObject

@end

@implementation ComStSt25sdkSysFileInterface

+ (const J2ObjcClassInfo *)__metadata {
  static J2ObjcMethodInfo methods[] = {
    { NULL, "I", 0x401, -1, -1, 0, -1, -1, -1 },
    { NULL, "[B", 0x401, -1, -1, 0, -1, -1, -1 },
    { NULL, "V", 0x401, -1, -1, 0, -1, -1, -1 },
  };
  #pragma clang diagnostic push
  #pragma clang diagnostic ignored "-Wobjc-multiple-method-names"
  #pragma clang diagnostic ignored "-Wundeclared-selector"
  methods[0].selector = @selector(getSysFileLength);
  methods[1].selector = @selector(readSysFile);
  methods[2].selector = @selector(selectSysFile);
  #pragma clang diagnostic pop
  static const void *ptrTable[] = { "LComStSt25sdkSTException;" };
  static const J2ObjcClassInfo _ComStSt25sdkSysFileInterface = { "SysFileInterface", "com.st.st25sdk", ptrTable, methods, NULL, 7, 0x609, 3, 0, -1, -1, -1, -1, -1 };
  return &_ComStSt25sdkSysFileInterface;
}

@end

J2OBJC_INTERFACE_TYPE_LITERAL_SOURCE(ComStSt25sdkSysFileInterface)
