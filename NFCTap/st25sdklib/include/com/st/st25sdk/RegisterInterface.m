//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: st25sdk_ios/RegisterInterface.java
//

#include "J2ObjC_source.h"
#include "com/st/st25sdk/RegisterInterface.h"

@interface ComStSt25sdkRegisterInterface : NSObject

@end

@implementation ComStSt25sdkRegisterInterface

+ (const J2ObjcClassInfo *)__metadata {
  static J2ObjcMethodInfo methods[] = {
    { NULL, "LJavaUtilList;", 0x401, -1, -1, -1, 0, -1, -1 },
    { NULL, "LJavaUtilList;", 0x401, -1, -1, -1, 0, -1, -1 },
    { NULL, "LComStSt25sdkSTRegister;", 0x401, 1, 2, -1, -1, -1, -1 },
  };
  #pragma clang diagnostic push
  #pragma clang diagnostic ignored "-Wobjc-multiple-method-names"
  #pragma clang diagnostic ignored "-Wundeclared-selector"
  methods[0].selector = @selector(getRegisterList);
  methods[1].selector = @selector(getDynamicRegisterList);
  methods[2].selector = @selector(getRegisterWithInt:);
  #pragma clang diagnostic pop
  static const void *ptrTable[] = { "()Ljava/util/List<Lcom/st/st25sdk/STRegister;>;", "getRegister", "I" };
  static const J2ObjcClassInfo _ComStSt25sdkRegisterInterface = { "RegisterInterface", "com.st.st25sdk", ptrTable, methods, NULL, 7, 0x609, 3, 0, -1, -1, -1, -1, -1 };
  return &_ComStSt25sdkRegisterInterface;
}

@end

J2OBJC_INTERFACE_TYPE_LITERAL_SOURCE(ComStSt25sdkRegisterInterface)