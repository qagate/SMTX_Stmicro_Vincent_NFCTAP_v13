//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: st25sdk_ios/type5/st25dvpwm/ST25DV02KW2Tag.java
//

#include "IOSPrimitiveArray.h"
#include "J2ObjC_source.h"
#include "com/st/st25sdk/RFReaderInterface.h"
#include "com/st/st25sdk/type5/st25dvpwm/ST25DV02KW2Tag.h"
#include "com/st/st25sdk/type5/st25dvpwm/ST25DVPwmTag.h"

@implementation ComStSt25sdkType5St25dvpwmST25DV02KW2Tag

- (instancetype)initWithComStSt25sdkRFReaderInterface:(id<ComStSt25sdkRFReaderInterface>)readerInterface
                                        withByteArray:(IOSByteArray *)uid {
  ComStSt25sdkType5St25dvpwmST25DV02KW2Tag_initWithComStSt25sdkRFReaderInterface_withByteArray_(self, readerInterface, uid);
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
  static const J2ObjcClassInfo _ComStSt25sdkType5St25dvpwmST25DV02KW2Tag = { "ST25DV02KW2Tag", "com.st.st25sdk.type5.st25dvpwm", ptrTable, methods, NULL, 7, 0x1, 1, 0, -1, -1, -1, -1, -1 };
  return &_ComStSt25sdkType5St25dvpwmST25DV02KW2Tag;
}

@end

void ComStSt25sdkType5St25dvpwmST25DV02KW2Tag_initWithComStSt25sdkRFReaderInterface_withByteArray_(ComStSt25sdkType5St25dvpwmST25DV02KW2Tag *self, id<ComStSt25sdkRFReaderInterface> readerInterface, IOSByteArray *uid) {
  ComStSt25sdkType5St25dvpwmST25DVPwmTag_initWithComStSt25sdkRFReaderInterface_withByteArray_(self, readerInterface, uid);
  self->mName_ = @"ST25DV02K-W2";
  self->mPwmNumber_ = 2;
}

ComStSt25sdkType5St25dvpwmST25DV02KW2Tag *new_ComStSt25sdkType5St25dvpwmST25DV02KW2Tag_initWithComStSt25sdkRFReaderInterface_withByteArray_(id<ComStSt25sdkRFReaderInterface> readerInterface, IOSByteArray *uid) {
  J2OBJC_NEW_IMPL(ComStSt25sdkType5St25dvpwmST25DV02KW2Tag, initWithComStSt25sdkRFReaderInterface_withByteArray_, readerInterface, uid)
}

ComStSt25sdkType5St25dvpwmST25DV02KW2Tag *create_ComStSt25sdkType5St25dvpwmST25DV02KW2Tag_initWithComStSt25sdkRFReaderInterface_withByteArray_(id<ComStSt25sdkRFReaderInterface> readerInterface, IOSByteArray *uid) {
  J2OBJC_CREATE_IMPL(ComStSt25sdkType5St25dvpwmST25DV02KW2Tag, initWithComStSt25sdkRFReaderInterface_withByteArray_, readerInterface, uid)
}

J2OBJC_CLASS_TYPE_LITERAL_SOURCE(ComStSt25sdkType5St25dvpwmST25DV02KW2Tag)
