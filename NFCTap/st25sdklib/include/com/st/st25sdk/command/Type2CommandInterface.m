//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: st25sdk_ios/command/Type2CommandInterface.java
//

#include "J2ObjC_source.h"
#include "com/st/st25sdk/command/Type2CommandInterface.h"

@interface ComStSt25sdkCommandType2CommandInterface : NSObject

@end

@implementation ComStSt25sdkCommandType2CommandInterface

+ (const J2ObjcClassInfo *)__metadata {
  static J2ObjcMethodInfo methods[] = {
    { NULL, "[B", 0x401, 0, 1, 2, -1, -1, -1 },
    { NULL, "[B", 0x401, 3, 4, 2, -1, -1, -1 },
    { NULL, "[B", 0x401, -1, -1, 2, -1, -1, -1 },
    { NULL, "[B", 0x401, 5, 1, 2, -1, -1, -1 },
    { NULL, "[B", 0x401, 6, 1, 2, -1, -1, -1 },
  };
  #pragma clang diagnostic push
  #pragma clang diagnostic ignored "-Wobjc-multiple-method-names"
  #pragma clang diagnostic ignored "-Wundeclared-selector"
  methods[0].selector = @selector(readWithByte:);
  methods[1].selector = @selector(writeWithByte:withByteArray:);
  methods[2].selector = @selector(sectorSelectCmdPacket1);
  methods[3].selector = @selector(sectorSelectCmdPacket2WithByte:);
  methods[4].selector = @selector(sectorSelectWithByte:);
  #pragma clang diagnostic pop
  static const void *ptrTable[] = { "read", "B", "LComStSt25sdkSTException;", "write", "B[B", "sectorSelectCmdPacket2", "sectorSelect" };
  static const J2ObjcClassInfo _ComStSt25sdkCommandType2CommandInterface = { "Type2CommandInterface", "com.st.st25sdk.command", ptrTable, methods, NULL, 7, 0x609, 5, 0, -1, -1, -1, -1, -1 };
  return &_ComStSt25sdkCommandType2CommandInterface;
}

@end

J2OBJC_INTERFACE_TYPE_LITERAL_SOURCE(ComStSt25sdkCommandType2CommandInterface)