//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: st25sdk_ios/CrcModel.java
//

#include "J2ObjC_source.h"
#include "com/st/st25sdk/CrcModel.h"

@implementation ComStSt25sdkCrcModel

J2OBJC_IGNORE_DESIGNATED_BEGIN
- (instancetype)init {
  ComStSt25sdkCrcModel_init(self);
  return self;
}
J2OBJC_IGNORE_DESIGNATED_END

+ (const J2ObjcClassInfo *)__metadata {
  static J2ObjcMethodInfo methods[] = {
    { NULL, NULL, 0x0, -1, -1, -1, -1, -1, -1 },
  };
  #pragma clang diagnostic push
  #pragma clang diagnostic ignored "-Wobjc-multiple-method-names"
  #pragma clang diagnostic ignored "-Wundeclared-selector"
  methods[0].selector = @selector(init);
  #pragma clang diagnostic pop
  static const J2ObjcFieldInfo fields[] = {
    { "width_", "I", .constantValue.asLong = 0, 0x1, -1, -1, -1, -1 },
    { "refin_", "Z", .constantValue.asLong = 0, 0x1, -1, -1, -1, -1 },
    { "refot_", "Z", .constantValue.asLong = 0, 0x1, -1, -1, -1, -1 },
    { "poly_", "J", .constantValue.asLong = 0, 0x1, -1, -1, -1, -1 },
    { "init__", "J", .constantValue.asLong = 0, 0x1, 0, -1, -1, -1 },
    { "xorot_", "J", .constantValue.asLong = 0, 0x1, -1, -1, -1, -1 },
    { "reg_", "J", .constantValue.asLong = 0, 0x1, -1, -1, -1, -1 },
  };
  static const void *ptrTable[] = { "init" };
  static const J2ObjcClassInfo _ComStSt25sdkCrcModel = { "CrcModel", "com.st.st25sdk", ptrTable, methods, fields, 7, 0x0, 1, 7, -1, -1, -1, -1, -1 };
  return &_ComStSt25sdkCrcModel;
}

@end

void ComStSt25sdkCrcModel_init(ComStSt25sdkCrcModel *self) {
  NSObject_init(self);
}

ComStSt25sdkCrcModel *new_ComStSt25sdkCrcModel_init() {
  J2OBJC_NEW_IMPL(ComStSt25sdkCrcModel, init)
}

ComStSt25sdkCrcModel *create_ComStSt25sdkCrcModel_init() {
  J2OBJC_CREATE_IMPL(ComStSt25sdkCrcModel, init)
}

J2OBJC_CLASS_TYPE_LITERAL_SOURCE(ComStSt25sdkCrcModel)