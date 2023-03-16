//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: st25sdk_ios/ndef/HandoverMediationRecord.java
//

#include "IOSPrimitiveArray.h"
#include "J2ObjC_source.h"
#include "com/st/st25sdk/ndef/AlternativeCarrierRecord.h"
#include "com/st/st25sdk/ndef/HandoverMediationRecord.h"
#include "com/st/st25sdk/ndef/NDEFRecord.h"
#include "java/io/ByteArrayInputStream.h"
#include "java/io/ByteArrayOutputStream.h"
#include "java/lang/Exception.h"
#include "java/nio/ByteBuffer.h"
#include "java/util/ArrayList.h"
#include "java/util/List.h"

static id (*ComStSt25sdkNdefHandoverMediationRecord_super$_getPayload)(id, SEL);

@interface ComStSt25sdkNdefHandoverMediationRecord () {
 @public
  jbyte mVersionMajorNumber_;
  jbyte mVersionMinorNumber_;
  id<JavaUtilList> mAlternativeCarrierRecords_;
}

- (void)parseWithJavaNioByteBuffer:(JavaNioByteBuffer *)payload;

@end

J2OBJC_FIELD_SETTER(ComStSt25sdkNdefHandoverMediationRecord, mAlternativeCarrierRecords_, id<JavaUtilList>)

__attribute__((unused)) static void ComStSt25sdkNdefHandoverMediationRecord_parseWithJavaNioByteBuffer_(ComStSt25sdkNdefHandoverMediationRecord *self, JavaNioByteBuffer *payload);

J2OBJC_INITIALIZED_DEFN(ComStSt25sdkNdefHandoverMediationRecord)

@implementation ComStSt25sdkNdefHandoverMediationRecord

- (instancetype)initWithByte:(jbyte)versionMajorNumber
                    withByte:(jbyte)versionMinorNumber
            withJavaUtilList:(id<JavaUtilList>)alternativeCarrierRecords {
  ComStSt25sdkNdefHandoverMediationRecord_initWithByte_withByte_withJavaUtilList_(self, versionMajorNumber, versionMinorNumber, alternativeCarrierRecords);
  return self;
}

- (instancetype)initWithJavaIoByteArrayInputStream:(JavaIoByteArrayInputStream *)inputStream {
  ComStSt25sdkNdefHandoverMediationRecord_initWithJavaIoByteArrayInputStream_(self, inputStream);
  return self;
}

- (void)parseWithJavaNioByteBuffer:(JavaNioByteBuffer *)payload {
  ComStSt25sdkNdefHandoverMediationRecord_parseWithJavaNioByteBuffer_(self, payload);
}

- (IOSByteArray *)getPayload {
  JavaIoByteArrayOutputStream *outputStream = new_JavaIoByteArrayOutputStream_init();
  jbyte version_ = (jbyte) ((JreLShift32((mVersionMajorNumber_ & (jint) 0x0F), 4)) | (mVersionMinorNumber_ & (jint) 0x0F));
  [outputStream writeWithInt:version_];
  for (ComStSt25sdkNdefAlternativeCarrierRecord * __strong alternativeCarrierRecord in nil_chk(mAlternativeCarrierRecords_)) {
    [outputStream writeWithByteArray:[((ComStSt25sdkNdefAlternativeCarrierRecord *) nil_chk(alternativeCarrierRecord)) serialize]];
  }
  IOSByteArray *payload = [outputStream toByteArray];
  return payload;
}

- (jbyte)getVersionMajorNumber {
  return mVersionMajorNumber_;
}

- (jbyte)getVersionMinorNumber {
  return mVersionMinorNumber_;
}

- (id<JavaUtilList>)getAlternativeCarrierRecords {
  return mAlternativeCarrierRecords_;
}

- (NSString *)description {
  NSString *recordHeader = [super description];
  NSString *txt = @"Handover Mediation Record:\n";
  (void) JreStrAppendStrong(&txt, "$", recordHeader);
  (void) JreStrAppendStrong(&txt, "$BCBC", @"- Version : ", mVersionMajorNumber_, '.', mVersionMinorNumber_, 0x000a);
  for (ComStSt25sdkNdefAlternativeCarrierRecord * __strong alternativeCarrierRecord in nil_chk(mAlternativeCarrierRecords_)) {
    (void) JreStrAppendStrong(&txt, "$", [((ComStSt25sdkNdefAlternativeCarrierRecord *) nil_chk(alternativeCarrierRecord)) description]);
  }
  return txt;
}

+ (const J2ObjcClassInfo *)__metadata {
  static J2ObjcMethodInfo methods[] = {
    { NULL, NULL, 0x1, -1, 0, -1, 1, -1, -1 },
    { NULL, NULL, 0x1, -1, 2, 3, -1, -1, -1 },
    { NULL, "V", 0x2, 4, 5, 3, -1, -1, -1 },
    { NULL, "[B", 0x1, -1, -1, 3, -1, -1, -1 },
    { NULL, "B", 0x1, -1, -1, -1, -1, -1, -1 },
    { NULL, "B", 0x1, -1, -1, -1, -1, -1, -1 },
    { NULL, "LJavaUtilList;", 0x1, -1, -1, -1, 6, -1, -1 },
    { NULL, "LNSString;", 0x1, 7, -1, -1, -1, -1, -1 },
  };
  #pragma clang diagnostic push
  #pragma clang diagnostic ignored "-Wobjc-multiple-method-names"
  #pragma clang diagnostic ignored "-Wundeclared-selector"
  methods[0].selector = @selector(initWithByte:withByte:withJavaUtilList:);
  methods[1].selector = @selector(initWithJavaIoByteArrayInputStream:);
  methods[2].selector = @selector(parseWithJavaNioByteBuffer:);
  methods[3].selector = @selector(getPayload);
  methods[4].selector = @selector(getVersionMajorNumber);
  methods[5].selector = @selector(getVersionMinorNumber);
  methods[6].selector = @selector(getAlternativeCarrierRecords);
  methods[7].selector = @selector(description);
  #pragma clang diagnostic pop
  static const J2ObjcFieldInfo fields[] = {
    { "mVersionMajorNumber_", "B", .constantValue.asLong = 0, 0x2, -1, -1, -1, -1 },
    { "mVersionMinorNumber_", "B", .constantValue.asLong = 0, 0x2, -1, -1, -1, -1 },
    { "mAlternativeCarrierRecords_", "LJavaUtilList;", .constantValue.asLong = 0, 0x2, -1, -1, 8, -1 },
  };
  static const void *ptrTable[] = { "BBLJavaUtilList;", "(BBLjava/util/List<Lcom/st/st25sdk/ndef/AlternativeCarrierRecord;>;)V", "LJavaIoByteArrayInputStream;", "LJavaLangException;", "parse", "LJavaNioByteBuffer;", "()Ljava/util/List<Lcom/st/st25sdk/ndef/AlternativeCarrierRecord;>;", "toString", "Ljava/util/List<Lcom/st/st25sdk/ndef/AlternativeCarrierRecord;>;" };
  static const J2ObjcClassInfo _ComStSt25sdkNdefHandoverMediationRecord = { "HandoverMediationRecord", "com.st.st25sdk.ndef", ptrTable, methods, fields, 7, 0x1, 8, 3, -1, -1, -1, -1, -1 };
  return &_ComStSt25sdkNdefHandoverMediationRecord;
}

+ (void)initialize {
  if (self == [ComStSt25sdkNdefHandoverMediationRecord class]) {
    ComStSt25sdkNdefHandoverMediationRecord_super$_getPayload = (id (*)(id, SEL))[ComStSt25sdkNdefNDEFRecord instanceMethodForSelector:@selector(getPayload)];
    J2OBJC_SET_INITIALIZED(ComStSt25sdkNdefHandoverMediationRecord)
  }
}

@end

void ComStSt25sdkNdefHandoverMediationRecord_initWithByte_withByte_withJavaUtilList_(ComStSt25sdkNdefHandoverMediationRecord *self, jbyte versionMajorNumber, jbyte versionMinorNumber, id<JavaUtilList> alternativeCarrierRecords) {
  ComStSt25sdkNdefNDEFRecord_init(self);
  self->mAlternativeCarrierRecords_ = new_JavaUtilArrayList_init();
  [self setTnfWithShort:ComStSt25sdkNdefNDEFRecord_TNF_WELLKNOWN];
  [self setTypeWithByteArray:JreLoadStatic(ComStSt25sdkNdefNDEFRecord, RTD_HANDOVER_MEDIATION)];
  [self setILWithBoolean:false];
  self->mVersionMajorNumber_ = versionMajorNumber;
  self->mVersionMinorNumber_ = versionMinorNumber;
  self->mAlternativeCarrierRecords_ = alternativeCarrierRecords;
  [self setSR];
}

ComStSt25sdkNdefHandoverMediationRecord *new_ComStSt25sdkNdefHandoverMediationRecord_initWithByte_withByte_withJavaUtilList_(jbyte versionMajorNumber, jbyte versionMinorNumber, id<JavaUtilList> alternativeCarrierRecords) {
  J2OBJC_NEW_IMPL(ComStSt25sdkNdefHandoverMediationRecord, initWithByte_withByte_withJavaUtilList_, versionMajorNumber, versionMinorNumber, alternativeCarrierRecords)
}

ComStSt25sdkNdefHandoverMediationRecord *create_ComStSt25sdkNdefHandoverMediationRecord_initWithByte_withByte_withJavaUtilList_(jbyte versionMajorNumber, jbyte versionMinorNumber, id<JavaUtilList> alternativeCarrierRecords) {
  J2OBJC_CREATE_IMPL(ComStSt25sdkNdefHandoverMediationRecord, initWithByte_withByte_withJavaUtilList_, versionMajorNumber, versionMinorNumber, alternativeCarrierRecords)
}

void ComStSt25sdkNdefHandoverMediationRecord_initWithJavaIoByteArrayInputStream_(ComStSt25sdkNdefHandoverMediationRecord *self, JavaIoByteArrayInputStream *inputStream) {
  ComStSt25sdkNdefNDEFRecord_initWithJavaIoByteArrayInputStream_(self, inputStream);
  self->mAlternativeCarrierRecords_ = new_JavaUtilArrayList_init();
  IOSByteArray *payload = ComStSt25sdkNdefHandoverMediationRecord_super$_getPayload(self, @selector(getPayload));
  if (payload == nil) {
    @throw new_JavaLangException_initWithNSString_(@"Invalid ndef data");
  }
  [self setTnfWithShort:ComStSt25sdkNdefNDEFRecord_TNF_WELLKNOWN];
  [self setTypeWithByteArray:JreLoadStatic(ComStSt25sdkNdefNDEFRecord, RTD_HANDOVER_MEDIATION)];
  ComStSt25sdkNdefHandoverMediationRecord_parseWithJavaNioByteBuffer_(self, JavaNioByteBuffer_wrapWithByteArray_(payload));
  if (JreLoadStatic(ComStSt25sdkNdefNDEFRecord, DBG_NDEF_RECORD)) {
    [self dbgCheckNdefRecordContentWithByteArray:payload];
  }
}

ComStSt25sdkNdefHandoverMediationRecord *new_ComStSt25sdkNdefHandoverMediationRecord_initWithJavaIoByteArrayInputStream_(JavaIoByteArrayInputStream *inputStream) {
  J2OBJC_NEW_IMPL(ComStSt25sdkNdefHandoverMediationRecord, initWithJavaIoByteArrayInputStream_, inputStream)
}

ComStSt25sdkNdefHandoverMediationRecord *create_ComStSt25sdkNdefHandoverMediationRecord_initWithJavaIoByteArrayInputStream_(JavaIoByteArrayInputStream *inputStream) {
  J2OBJC_CREATE_IMPL(ComStSt25sdkNdefHandoverMediationRecord, initWithJavaIoByteArrayInputStream_, inputStream)
}

void ComStSt25sdkNdefHandoverMediationRecord_parseWithJavaNioByteBuffer_(ComStSt25sdkNdefHandoverMediationRecord *self, JavaNioByteBuffer *payload) {
  jbyte tnepVersion = [((JavaNioByteBuffer *) nil_chk(payload)) get];
  self->mVersionMajorNumber_ = (jbyte) ((JreRShift32((tnepVersion & (jint) 0xF0), 4)) & (jint) 0xFF);
  self->mVersionMinorNumber_ = (jbyte) (tnepVersion & (jint) 0x0F);
  JavaIoByteArrayInputStream *byteArrayInputStream = new_JavaIoByteArrayInputStream_initWithByteArray_withInt_withInt_([payload array], [payload position], [payload limit]);
  while ([byteArrayInputStream available] > 0) {
    ComStSt25sdkNdefAlternativeCarrierRecord *alternativeCarrierRecord = new_ComStSt25sdkNdefAlternativeCarrierRecord_initWithJavaIoByteArrayInputStream_(byteArrayInputStream);
    [((id<JavaUtilList>) nil_chk(self->mAlternativeCarrierRecords_)) addWithId:alternativeCarrierRecord];
  }
}

J2OBJC_CLASS_TYPE_LITERAL_SOURCE(ComStSt25sdkNdefHandoverMediationRecord)