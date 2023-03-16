//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: st25sdk_ios/iso14443sr/SRi4KTag.java
//

#include "IOSPrimitiveArray.h"
#include "J2ObjC_source.h"
#include "com/st/st25sdk/RFReaderInterface.h"
#include "com/st/st25sdk/iso14443sr/SRi4KTag.h"
#include "com/st/st25sdk/iso14443sr/STIso14443SRTag.h"

@implementation ComStSt25sdkIso14443srSRi4KTag

- (instancetype)initWithComStSt25sdkRFReaderInterface:(id<ComStSt25sdkRFReaderInterface>)readerInterface
                                        withByteArray:(IOSByteArray *)uid {
  ComStSt25sdkIso14443srSRi4KTag_initWithComStSt25sdkRFReaderInterface_withByteArray_(self, readerInterface, uid);
  return self;
}

+ (const J2ObjcClassInfo *)__metadata {
  static J2ObjcMethodInfo methods[] = {
    { NULL, NULL, 0x1, -1, 0, 1, -1, -1, -1 },
  };
  #pragma clang diagnostic push
  #pragma clang diagnostic ignored "-Wobjc-multiple-method-names"
  #pragma clang diagnostic ignored "-Wundeclared-selector"
  methods[0].selector = @selector(initWithComStSt25sdkRFReaderInterface:withByteArray:);
  #pragma clang diagnostic pop
  static const void *ptrTable[] = { "LComStSt25sdkRFReaderInterface;[B", "LComStSt25sdkSTException;" };
  static const J2ObjcClassInfo _ComStSt25sdkIso14443srSRi4KTag = { "SRi4KTag", "com.st.st25sdk.iso14443sr", ptrTable, methods, NULL, 7, 0x1, 1, 0, -1, -1, -1, -1, -1 };
  return &_ComStSt25sdkIso14443srSRi4KTag;
}

@end

void ComStSt25sdkIso14443srSRi4KTag_initWithComStSt25sdkRFReaderInterface_withByteArray_(ComStSt25sdkIso14443srSRi4KTag *self, id<ComStSt25sdkRFReaderInterface> readerInterface, IOSByteArray *uid) {
  ComStSt25sdkIso14443srSTIso14443SRTag_initWithComStSt25sdkRFReaderInterface_withByteArray_(self, readerInterface, uid);
  self->mName_ = @"SRi4K";
  self->mMemSize_ = 512;
}

ComStSt25sdkIso14443srSRi4KTag *new_ComStSt25sdkIso14443srSRi4KTag_initWithComStSt25sdkRFReaderInterface_withByteArray_(id<ComStSt25sdkRFReaderInterface> readerInterface, IOSByteArray *uid) {
  J2OBJC_NEW_IMPL(ComStSt25sdkIso14443srSRi4KTag, initWithComStSt25sdkRFReaderInterface_withByteArray_, readerInterface, uid)
}

ComStSt25sdkIso14443srSRi4KTag *create_ComStSt25sdkIso14443srSRi4KTag_initWithComStSt25sdkRFReaderInterface_withByteArray_(id<ComStSt25sdkRFReaderInterface> readerInterface, IOSByteArray *uid) {
  J2OBJC_CREATE_IMPL(ComStSt25sdkIso14443srSRi4KTag, initWithComStSt25sdkRFReaderInterface_withByteArray_, readerInterface, uid)
}

J2OBJC_CLASS_TYPE_LITERAL_SOURCE(ComStSt25sdkIso14443srSRi4KTag)