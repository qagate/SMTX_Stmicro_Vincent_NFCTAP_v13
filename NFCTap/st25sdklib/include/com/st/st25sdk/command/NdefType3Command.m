//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: st25sdk_ios/command/NdefType3Command.java
//

#include "IOSPrimitiveArray.h"
#include "J2ObjC_source.h"
#include "com/st/st25sdk/Helper.h"
#include "com/st/st25sdk/RFReaderInterface.h"
#include "com/st/st25sdk/STException.h"
#include "com/st/st25sdk/command/NdefType3Command.h"
#include "com/st/st25sdk/command/Type3Command.h"
#include "com/st/st25sdk/ndef/NDEFMsg.h"
#include "com/st/st25sdk/type3/Type3Tag.h"
#include "java/lang/Exception.h"
#include "java/lang/System.h"

@implementation ComStSt25sdkCommandNdefType3Command

- (instancetype)initWithComStSt25sdkRFReaderInterface:(id<ComStSt25sdkRFReaderInterface>)reader {
  ComStSt25sdkCommandNdefType3Command_initWithComStSt25sdkRFReaderInterface_(self, reader);
  return self;
}

- (void)writeNdefMessageWithByteArray:(IOSByteArray *)nfcId2
          withComStSt25sdkNdefNDEFMsg:(ComStSt25sdkNdefNDEFMsg *)msg {
  IOSByteArray *formattedNdefBuffer;
  @try {
    formattedNdefBuffer = [((ComStSt25sdkNdefNDEFMsg *) nil_chk(msg)) formatType3];
  }
  @catch (JavaLangException *e) {
    @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, INVALID_NDEF_DATA));
  }
  if (((IOSByteArray *) nil_chk(formattedNdefBuffer))->size_ < 1) {
    @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, BAD_PARAMETER));
  }
  IOSByteArray *attributeInfoBuffer = [self readBlockWithByteArray:nfcId2 withInt:ComStSt25sdkType3Type3Tag_T3T_ATTRIBUTE_INFO_BLOCK_ADDRESS];
  *IOSByteArray_GetRef(nil_chk(attributeInfoBuffer), ComStSt25sdkType3Type3Tag_T3T_ATTRIBUTE_INFO_WRITEFLAG_ADDRESS_IN_BYTE) = ComStSt25sdkType3Type3Tag_T3T_ATTRIBUTE_INFO_WRITEFLAG_PROCEDURE_NOT_FINISHED;
  jint calculatedChecksum = 0;
  for (jint i = 0; i < 14; i++) {
    calculatedChecksum += (IOSByteArray_Get(attributeInfoBuffer, i) & (jint) 0xFF);
  }
  IOSByteArray *checksum = ComStSt25sdkHelper_convertIntTo2BytesHexaFormatWithInt_(calculatedChecksum);
  JavaLangSystem_arraycopyWithId_withInt_withId_withInt_withInt_(checksum, 0, attributeInfoBuffer, ComStSt25sdkType3Type3Tag_T3T_ATTRIBUTE_INFO_CHECKSUM_ADDRESS_IN_BYTE, ((IOSByteArray *) nil_chk(checksum))->size_);
  (void) [self writeBlockWithByteArray:nfcId2 withInt:ComStSt25sdkType3Type3Tag_T3T_ATTRIBUTE_INFO_BLOCK_ADDRESS withByteArray:attributeInfoBuffer];
  [self writeBytesWithByteArray:nfcId2 withInt:ComStSt25sdkType3Type3Tag_T3T_NDEF_FIRST_BYTE_ADDRESS withByteArray:formattedNdefBuffer];
  IOSByteArray *lengthNDEFdata = ComStSt25sdkHelper_convertIntTo3BytesHexaFormatWithInt_(formattedNdefBuffer->size_);
  JavaLangSystem_arraycopyWithId_withInt_withId_withInt_withInt_(lengthNDEFdata, 0, attributeInfoBuffer, ComStSt25sdkType3Type3Tag_T3T_ATTRIBUTE_INFO_LN_ADDRESS_IN_BYTE, ((IOSByteArray *) nil_chk(lengthNDEFdata))->size_);
  *IOSByteArray_GetRef(attributeInfoBuffer, ComStSt25sdkType3Type3Tag_T3T_ATTRIBUTE_INFO_WRITEFLAG_ADDRESS_IN_BYTE) = ComStSt25sdkType3Type3Tag_T3T_ATTRIBUTE_INFO_WRITEFLAG_PROCEDURE_FINISHED;
  calculatedChecksum = 0;
  for (jint i = 0; i < 14; i++) {
    calculatedChecksum += (IOSByteArray_Get(attributeInfoBuffer, i) & (jint) 0xFF);
  }
  checksum = ComStSt25sdkHelper_convertIntTo2BytesHexaFormatWithInt_(calculatedChecksum);
  JavaLangSystem_arraycopyWithId_withInt_withId_withInt_withInt_(checksum, 0, attributeInfoBuffer, ComStSt25sdkType3Type3Tag_T3T_ATTRIBUTE_INFO_CHECKSUM_ADDRESS_IN_BYTE, ((IOSByteArray *) nil_chk(checksum))->size_);
  (void) [self writeBlockWithByteArray:nfcId2 withInt:ComStSt25sdkType3Type3Tag_T3T_ATTRIBUTE_INFO_BLOCK_ADDRESS withByteArray:attributeInfoBuffer];
}

- (ComStSt25sdkNdefNDEFMsg *)readNdefMessageWithByteArray:(IOSByteArray *)nfcId2 {
  IOSByteArray *attributeData;
  IOSByteArray *msg;
  jint sizeInBytes;
  attributeData = [self readBlockWithByteArray:nfcId2 withInt:0];
  if (((IOSByteArray *) nil_chk(attributeData))->size_ != 16) {
    @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, INVALID_DATA));
  }
  if (IOSByteArray_Get(attributeData, 9) == ComStSt25sdkType3Type3Tag_T3T_ATTRIBUTE_INFO_WRITEFLAG_PROCEDURE_NOT_FINISHED) {
    @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, NFC_TYPE3_NDEF_WRITE_NOT_FINISHED));
  }
  IOSByteArray *lnData = [IOSByteArray newArrayWithLength:3];
  JavaLangSystem_arraycopyWithId_withInt_withId_withInt_withInt_(attributeData, 11, lnData, 0, 3);
  sizeInBytes = ComStSt25sdkHelper_convert3BytesHexaFormatToIntWithByteArray_(lnData);
  msg = [self readBytesWithByteArray:nfcId2 withInt:ComStSt25sdkType3Type3Tag_T3T_NDEF_FIRST_BYTE_ADDRESS withInt:sizeInBytes];
  ComStSt25sdkNdefNDEFMsg *ndefmsg;
  @try {
    ndefmsg = new_ComStSt25sdkNdefNDEFMsg_initWithByteArray_(msg);
  }
  @catch (JavaLangException *e) {
    @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, INVALID_NDEF_DATA));
  }
  return ndefmsg;
}

+ (const J2ObjcClassInfo *)__metadata {
  static J2ObjcMethodInfo methods[] = {
    { NULL, NULL, 0x1, -1, 0, -1, -1, -1, -1 },
    { NULL, "V", 0x1, 1, 2, 3, -1, -1, -1 },
    { NULL, "LComStSt25sdkNdefNDEFMsg;", 0x1, 4, 5, 3, -1, -1, -1 },
  };
  #pragma clang diagnostic push
  #pragma clang diagnostic ignored "-Wobjc-multiple-method-names"
  #pragma clang diagnostic ignored "-Wundeclared-selector"
  methods[0].selector = @selector(initWithComStSt25sdkRFReaderInterface:);
  methods[1].selector = @selector(writeNdefMessageWithByteArray:withComStSt25sdkNdefNDEFMsg:);
  methods[2].selector = @selector(readNdefMessageWithByteArray:);
  #pragma clang diagnostic pop
  static const void *ptrTable[] = { "LComStSt25sdkRFReaderInterface;", "writeNdefMessage", "[BLComStSt25sdkNdefNDEFMsg;", "LComStSt25sdkSTException;", "readNdefMessage", "[B" };
  static const J2ObjcClassInfo _ComStSt25sdkCommandNdefType3Command = { "NdefType3Command", "com.st.st25sdk.command", ptrTable, methods, NULL, 7, 0x1, 3, 0, -1, -1, -1, -1, -1 };
  return &_ComStSt25sdkCommandNdefType3Command;
}

@end

void ComStSt25sdkCommandNdefType3Command_initWithComStSt25sdkRFReaderInterface_(ComStSt25sdkCommandNdefType3Command *self, id<ComStSt25sdkRFReaderInterface> reader) {
  ComStSt25sdkCommandType3Command_initWithComStSt25sdkRFReaderInterface_(self, reader);
}

ComStSt25sdkCommandNdefType3Command *new_ComStSt25sdkCommandNdefType3Command_initWithComStSt25sdkRFReaderInterface_(id<ComStSt25sdkRFReaderInterface> reader) {
  J2OBJC_NEW_IMPL(ComStSt25sdkCommandNdefType3Command, initWithComStSt25sdkRFReaderInterface_, reader)
}

ComStSt25sdkCommandNdefType3Command *create_ComStSt25sdkCommandNdefType3Command_initWithComStSt25sdkRFReaderInterface_(id<ComStSt25sdkRFReaderInterface> reader) {
  J2OBJC_CREATE_IMPL(ComStSt25sdkCommandNdefType3Command, initWithComStSt25sdkRFReaderInterface_, reader)
}

J2OBJC_CLASS_TYPE_LITERAL_SOURCE(ComStSt25sdkCommandNdefType3Command)