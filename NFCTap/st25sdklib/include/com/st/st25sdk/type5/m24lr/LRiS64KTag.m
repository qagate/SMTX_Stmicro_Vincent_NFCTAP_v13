//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: st25sdk_ios/type5/m24lr/LRiS64KTag.java
//

#include "IOSPrimitiveArray.h"
#include "J2ObjC_source.h"
#include "com/st/st25sdk/NFCTag.h"
#include "com/st/st25sdk/RFReaderInterface.h"
#include "com/st/st25sdk/type5/STVicinityTag.h"
#include "com/st/st25sdk/type5/m24lr/LRiS64KTag.h"

@implementation ComStSt25sdkType5M24lrLRiS64KTag

- (instancetype)initWithComStSt25sdkRFReaderInterface:(id<ComStSt25sdkRFReaderInterface>)readerInterface
                                        withByteArray:(IOSByteArray *)uid {
  ComStSt25sdkType5M24lrLRiS64KTag_initWithComStSt25sdkRFReaderInterface_withByteArray_(self, readerInterface, uid);
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
  static const J2ObjcClassInfo _ComStSt25sdkType5M24lrLRiS64KTag = { "LRiS64KTag", "com.st.st25sdk.type5.m24lr", ptrTable, methods, NULL, 7, 0x1, 1, 0, -1, -1, -1, -1, -1 };
  return &_ComStSt25sdkType5M24lrLRiS64KTag;
}

@end

void ComStSt25sdkType5M24lrLRiS64KTag_initWithComStSt25sdkRFReaderInterface_withByteArray_(ComStSt25sdkType5M24lrLRiS64KTag *self, id<ComStSt25sdkRFReaderInterface> readerInterface, IOSByteArray *uid) {
  ComStSt25sdkType5STVicinityTag_initWithComStSt25sdkRFReaderInterface_withByteArray_withInt_withInt_(self, readerInterface, uid, 64, 32);
  self->mName_ = @"LRiS64K";
  self->mTypeDescription_ = JreLoadStatic(ComStSt25sdkNFCTag, NFC_RFID_TAG);
  self->mMemSize_ = 8192;
  [self setMaxReadMultipleBlocksReturnedWithInt:32];
}

ComStSt25sdkType5M24lrLRiS64KTag *new_ComStSt25sdkType5M24lrLRiS64KTag_initWithComStSt25sdkRFReaderInterface_withByteArray_(id<ComStSt25sdkRFReaderInterface> readerInterface, IOSByteArray *uid) {
  J2OBJC_NEW_IMPL(ComStSt25sdkType5M24lrLRiS64KTag, initWithComStSt25sdkRFReaderInterface_withByteArray_, readerInterface, uid)
}

ComStSt25sdkType5M24lrLRiS64KTag *create_ComStSt25sdkType5M24lrLRiS64KTag_initWithComStSt25sdkRFReaderInterface_withByteArray_(id<ComStSt25sdkRFReaderInterface> readerInterface, IOSByteArray *uid) {
  J2OBJC_CREATE_IMPL(ComStSt25sdkType5M24lrLRiS64KTag, initWithComStSt25sdkRFReaderInterface_withByteArray_, readerInterface, uid)
}

J2OBJC_CLASS_TYPE_LITERAL_SOURCE(ComStSt25sdkType5M24lrLRiS64KTag)
