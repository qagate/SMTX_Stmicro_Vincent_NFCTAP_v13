//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: st25sdk_ios/ControlTlv.java
//

#include "IOSPrimitiveArray.h"
#include "J2ObjC_source.h"
#include "com/st/st25sdk/ControlTlv.h"
#include "com/st/st25sdk/Helper.h"
#include "com/st/st25sdk/STException.h"
#include "com/st/st25sdk/command/Type2Command.h"
#include "java/io/ByteArrayInputStream.h"
#include "java/lang/Math.h"
#include "java/lang/System.h"

@interface ComStSt25sdkControlTlv () {
 @public
  jbyte mType_;
  jint mLength_;
  IOSByteArray *mValue_;
  jint mTlvSize_;
}

+ (IOSByteArray *)buildTlvBufferWithByte:(jbyte)type
                                 withInt:(jint)length
                           withByteArray:(IOSByteArray *)value;

@end

J2OBJC_FIELD_SETTER(ComStSt25sdkControlTlv, mValue_, IOSByteArray *)

__attribute__((unused)) static IOSByteArray *ComStSt25sdkControlTlv_buildTlvBufferWithByte_withInt_withByteArray_(jbyte type, jint length, IOSByteArray *value);

@implementation ComStSt25sdkControlTlv

+ (jbyte)NULL_TLV {
  return ComStSt25sdkControlTlv_NULL_TLV;
}

+ (jbyte)LOCK_CONTROL_TLV {
  return ComStSt25sdkControlTlv_LOCK_CONTROL_TLV;
}

+ (jbyte)MEMORY_CONTROL_TLV {
  return ComStSt25sdkControlTlv_MEMORY_CONTROL_TLV;
}

+ (jbyte)NDEF_MESSAGE_TLV {
  return ComStSt25sdkControlTlv_NDEF_MESSAGE_TLV;
}

+ (jbyte)PROPRIETARY_TLV {
  return ComStSt25sdkControlTlv_PROPRIETARY_TLV;
}

+ (jbyte)TERMINATOR_TLV {
  return ComStSt25sdkControlTlv_TERMINATOR_TLV;
}

- (instancetype)initWithByteArray:(IOSByteArray *)buffer
                          withInt:(jint)offset {
  ComStSt25sdkControlTlv_initWithByteArray_withInt_(self, buffer, offset);
  return self;
}

- (instancetype)initWithByteArray:(IOSByteArray *)buffer {
  ComStSt25sdkControlTlv_initWithByteArray_(self, buffer);
  return self;
}

- (void)parseWithByteArray:(IOSByteArray *)buffer {
  [self parseWithByteArray:buffer withInt:0];
}

- (void)parseWithByteArray:(IOSByteArray *)buffer
                   withInt:(jint)offset {
  mTlvSize_ = 0;
  if (buffer != nil && buffer->size_ > 0 && offset <= buffer->size_) {
    JavaIoByteArrayInputStream *inputStream = new_JavaIoByteArrayInputStream_initWithByteArray_withInt_withInt_(buffer, offset, buffer->size_ - offset);
    mType_ = (jbyte) [inputStream read];
    if (mType_ == ComStSt25sdkControlTlv_NULL_TLV || mType_ == ComStSt25sdkControlTlv_TERMINATOR_TLV) {
      mLength_ = 0;
      mValue_ = nil;
      mTlvSize_ = 1;
    }
    else if ((mType_ == ComStSt25sdkControlTlv_LOCK_CONTROL_TLV || mType_ == ComStSt25sdkControlTlv_MEMORY_CONTROL_TLV) && [inputStream available] > 3 && [inputStream read] == (jint) 0x03) {
      mLength_ = (jint) 0x03;
      mValue_ = [IOSByteArray newArrayWithLength:mLength_];
      [inputStream readWithByteArray:mValue_ withInt:0 withInt:mLength_];
      mTlvSize_ = 5;
    }
    else if ((mType_ == ComStSt25sdkControlTlv_PROPRIETARY_TLV || mType_ == ComStSt25sdkControlTlv_NDEF_MESSAGE_TLV) && [inputStream available] > 1) {
      jint tmp = [inputStream read];
      if (tmp == 0) {
        mLength_ = tmp;
        mValue_ = nil;
        mTlvSize_ = 2;
      }
      else if ((jbyte) tmp == (jbyte) (jint) 0xFF && [inputStream available] >= 2) {
        mLength_ = (JreLShift32(((jbyte) [inputStream read] & (jint) 0xFF), 8)) + ((jbyte) [inputStream read] & (jint) 0xFF);
        mValue_ = [IOSByteArray newArrayWithLength:mLength_];
        [inputStream readWithByteArray:mValue_ withInt:0 withInt:mLength_];
        mTlvSize_ = mLength_ + 4;
      }
      else if ([inputStream available] >= 1) {
        mLength_ = tmp;
        mValue_ = [IOSByteArray newArrayWithLength:mLength_];
        [inputStream readWithByteArray:mValue_ withInt:0 withInt:mLength_];
        mTlvSize_ = mLength_ + 2;
      }
    }
  }
}

- (IOSByteArray *)rebuildBufferFromTlv {
  IOSByteArray *buffer = ComStSt25sdkControlTlv_buildTlvBufferWithByte_withInt_withByteArray_(mType_, mLength_, mValue_);
  if (mValue_ != nil) {
    mTlvSize_ = 1 + mLength_ + mValue_->size_;
  }
  else {
    mTlvSize_ = 1 + mLength_;
  }
  return buffer;
}

+ (IOSByteArray *)buildTlvBufferWithByte:(jbyte)type
                                 withInt:(jint)length
                           withByteArray:(IOSByteArray *)value {
  return ComStSt25sdkControlTlv_buildTlvBufferWithByte_withInt_withByteArray_(type, length, value);
}

+ (IOSByteArray *)buildNullTlv {
  return ComStSt25sdkControlTlv_buildNullTlv();
}

+ (IOSByteArray *)buildLockControlTlvWithByteArray:(IOSByteArray *)lockControlBytes {
  return ComStSt25sdkControlTlv_buildLockControlTlvWithByteArray_(lockControlBytes);
}

+ (IOSByteArray *)buildMemoryControlTlvWithByteArray:(IOSByteArray *)memoryControlBytes {
  return ComStSt25sdkControlTlv_buildMemoryControlTlvWithByteArray_(memoryControlBytes);
}

+ (IOSByteArray *)buildNdefTlvWithByteArray:(IOSByteArray *)ndefMsg {
  return ComStSt25sdkControlTlv_buildNdefTlvWithByteArray_(ndefMsg);
}

+ (IOSByteArray *)buildProprietaryTlvWithByteArray:(IOSByteArray *)proprietaryData {
  return ComStSt25sdkControlTlv_buildProprietaryTlvWithByteArray_(proprietaryData);
}

+ (IOSByteArray *)buildTerminatorTlv {
  return ComStSt25sdkControlTlv_buildTerminatorTlv();
}

+ (IOSByteArray *)addNullTlvWithByteArray:(IOSByteArray *)buffer {
  return ComStSt25sdkControlTlv_addNullTlvWithByteArray_(buffer);
}

+ (IOSByteArray *)addLockControlTlvWithByteArray:(IOSByteArray *)buffer
                                   withByteArray:(IOSByteArray *)lockControlBytes {
  return ComStSt25sdkControlTlv_addLockControlTlvWithByteArray_withByteArray_(buffer, lockControlBytes);
}

+ (IOSByteArray *)addMemoryControlTlvWithByteArray:(IOSByteArray *)buffer
                                     withByteArray:(IOSByteArray *)memoryControlBytes {
  return ComStSt25sdkControlTlv_addMemoryControlTlvWithByteArray_withByteArray_(buffer, memoryControlBytes);
}

+ (IOSByteArray *)addLockControlTlvWithByteArray:(IOSByteArray *)buffer
                                         withInt:(jint)firstByteAddress
                                         withInt:(jint)nbrOfBitOfDLA
                                         withInt:(jint)bytesLockedPerLockBit {
  return ComStSt25sdkControlTlv_addLockControlTlvWithByteArray_withInt_withInt_withInt_(buffer, firstByteAddress, nbrOfBitOfDLA, bytesLockedPerLockBit);
}

+ (IOSByteArray *)addMemoryControlTlvWithByteArray:(IOSByteArray *)buffer
                                           withInt:(jint)firstByteAddress
                                           withInt:(jint)sizeInBytes {
  return ComStSt25sdkControlTlv_addMemoryControlTlvWithByteArray_withInt_withInt_(buffer, firstByteAddress, sizeInBytes);
}

+ (IOSByteArray *)addNdefTlvWithByteArray:(IOSByteArray *)buffer
                            withByteArray:(IOSByteArray *)ndefMsg {
  return ComStSt25sdkControlTlv_addNdefTlvWithByteArray_withByteArray_(buffer, ndefMsg);
}

+ (IOSByteArray *)addProprietaryTlvWithByteArray:(IOSByteArray *)buffer
                                   withByteArray:(IOSByteArray *)proprietaryData {
  return ComStSt25sdkControlTlv_addProprietaryTlvWithByteArray_withByteArray_(buffer, proprietaryData);
}

+ (IOSByteArray *)addTerminatorTlvWithByteArray:(IOSByteArray *)buffer {
  return ComStSt25sdkControlTlv_addTerminatorTlvWithByteArray_(buffer);
}

- (jbyte)getType {
  return mType_;
}

- (jint)getLength {
  return mLength_;
}

- (IOSByteArray *)getValue {
  return mValue_;
}

- (jint)getTlvSize {
  return mTlvSize_;
}

+ (const J2ObjcClassInfo *)__metadata {
  static J2ObjcMethodInfo methods[] = {
    { NULL, NULL, 0x1, -1, 0, -1, -1, -1, -1 },
    { NULL, NULL, 0x1, -1, 1, -1, -1, -1, -1 },
    { NULL, "V", 0x1, 2, 1, -1, -1, -1, -1 },
    { NULL, "V", 0x1, 2, 0, -1, -1, -1, -1 },
    { NULL, "[B", 0x1, -1, -1, -1, -1, -1, -1 },
    { NULL, "[B", 0xa, 3, 4, -1, -1, -1, -1 },
    { NULL, "[B", 0x9, -1, -1, -1, -1, -1, -1 },
    { NULL, "[B", 0x9, 5, 1, 6, -1, -1, -1 },
    { NULL, "[B", 0x9, 7, 1, 6, -1, -1, -1 },
    { NULL, "[B", 0x9, 8, 1, -1, -1, -1, -1 },
    { NULL, "[B", 0x9, 9, 1, -1, -1, -1, -1 },
    { NULL, "[B", 0x9, -1, -1, -1, -1, -1, -1 },
    { NULL, "[B", 0x9, 10, 1, -1, -1, -1, -1 },
    { NULL, "[B", 0x9, 11, 12, 6, -1, -1, -1 },
    { NULL, "[B", 0x9, 13, 12, 6, -1, -1, -1 },
    { NULL, "[B", 0x9, 11, 14, 6, -1, -1, -1 },
    { NULL, "[B", 0x9, 13, 15, 6, -1, -1, -1 },
    { NULL, "[B", 0x9, 16, 12, -1, -1, -1, -1 },
    { NULL, "[B", 0x9, 17, 12, -1, -1, -1, -1 },
    { NULL, "[B", 0x9, 18, 1, -1, -1, -1, -1 },
    { NULL, "B", 0x1, -1, -1, -1, -1, -1, -1 },
    { NULL, "I", 0x1, -1, -1, -1, -1, -1, -1 },
    { NULL, "[B", 0x1, -1, -1, -1, -1, -1, -1 },
    { NULL, "I", 0x1, -1, -1, -1, -1, -1, -1 },
  };
  #pragma clang diagnostic push
  #pragma clang diagnostic ignored "-Wobjc-multiple-method-names"
  #pragma clang diagnostic ignored "-Wundeclared-selector"
  methods[0].selector = @selector(initWithByteArray:withInt:);
  methods[1].selector = @selector(initWithByteArray:);
  methods[2].selector = @selector(parseWithByteArray:);
  methods[3].selector = @selector(parseWithByteArray:withInt:);
  methods[4].selector = @selector(rebuildBufferFromTlv);
  methods[5].selector = @selector(buildTlvBufferWithByte:withInt:withByteArray:);
  methods[6].selector = @selector(buildNullTlv);
  methods[7].selector = @selector(buildLockControlTlvWithByteArray:);
  methods[8].selector = @selector(buildMemoryControlTlvWithByteArray:);
  methods[9].selector = @selector(buildNdefTlvWithByteArray:);
  methods[10].selector = @selector(buildProprietaryTlvWithByteArray:);
  methods[11].selector = @selector(buildTerminatorTlv);
  methods[12].selector = @selector(addNullTlvWithByteArray:);
  methods[13].selector = @selector(addLockControlTlvWithByteArray:withByteArray:);
  methods[14].selector = @selector(addMemoryControlTlvWithByteArray:withByteArray:);
  methods[15].selector = @selector(addLockControlTlvWithByteArray:withInt:withInt:withInt:);
  methods[16].selector = @selector(addMemoryControlTlvWithByteArray:withInt:withInt:);
  methods[17].selector = @selector(addNdefTlvWithByteArray:withByteArray:);
  methods[18].selector = @selector(addProprietaryTlvWithByteArray:withByteArray:);
  methods[19].selector = @selector(addTerminatorTlvWithByteArray:);
  methods[20].selector = @selector(getType);
  methods[21].selector = @selector(getLength);
  methods[22].selector = @selector(getValue);
  methods[23].selector = @selector(getTlvSize);
  #pragma clang diagnostic pop
  static const J2ObjcFieldInfo fields[] = {
    { "mType_", "B", .constantValue.asLong = 0, 0x2, -1, -1, -1, -1 },
    { "mLength_", "I", .constantValue.asLong = 0, 0x2, -1, -1, -1, -1 },
    { "mValue_", "[B", .constantValue.asLong = 0, 0x2, -1, -1, -1, -1 },
    { "mTlvSize_", "I", .constantValue.asLong = 0, 0x2, -1, -1, -1, -1 },
    { "NULL_TLV", "B", .constantValue.asChar = ComStSt25sdkControlTlv_NULL_TLV, 0x19, -1, -1, -1, -1 },
    { "LOCK_CONTROL_TLV", "B", .constantValue.asChar = ComStSt25sdkControlTlv_LOCK_CONTROL_TLV, 0x19, -1, -1, -1, -1 },
    { "MEMORY_CONTROL_TLV", "B", .constantValue.asChar = ComStSt25sdkControlTlv_MEMORY_CONTROL_TLV, 0x19, -1, -1, -1, -1 },
    { "NDEF_MESSAGE_TLV", "B", .constantValue.asChar = ComStSt25sdkControlTlv_NDEF_MESSAGE_TLV, 0x19, -1, -1, -1, -1 },
    { "PROPRIETARY_TLV", "B", .constantValue.asChar = ComStSt25sdkControlTlv_PROPRIETARY_TLV, 0x19, -1, -1, -1, -1 },
    { "TERMINATOR_TLV", "B", .constantValue.asChar = ComStSt25sdkControlTlv_TERMINATOR_TLV, 0x19, -1, -1, -1, -1 },
  };
  static const void *ptrTable[] = { "[BI", "[B", "parse", "buildTlvBuffer", "BI[B", "buildLockControlTlv", "LComStSt25sdkSTException;", "buildMemoryControlTlv", "buildNdefTlv", "buildProprietaryTlv", "addNullTlv", "addLockControlTlv", "[B[B", "addMemoryControlTlv", "[BIII", "[BII", "addNdefTlv", "addProprietaryTlv", "addTerminatorTlv" };
  static const J2ObjcClassInfo _ComStSt25sdkControlTlv = { "ControlTlv", "com.st.st25sdk", ptrTable, methods, fields, 7, 0x1, 24, 10, -1, -1, -1, -1, -1 };
  return &_ComStSt25sdkControlTlv;
}

@end

void ComStSt25sdkControlTlv_initWithByteArray_withInt_(ComStSt25sdkControlTlv *self, IOSByteArray *buffer, jint offset) {
  NSObject_init(self);
  [self parseWithByteArray:buffer withInt:offset];
}

ComStSt25sdkControlTlv *new_ComStSt25sdkControlTlv_initWithByteArray_withInt_(IOSByteArray *buffer, jint offset) {
  J2OBJC_NEW_IMPL(ComStSt25sdkControlTlv, initWithByteArray_withInt_, buffer, offset)
}

ComStSt25sdkControlTlv *create_ComStSt25sdkControlTlv_initWithByteArray_withInt_(IOSByteArray *buffer, jint offset) {
  J2OBJC_CREATE_IMPL(ComStSt25sdkControlTlv, initWithByteArray_withInt_, buffer, offset)
}

void ComStSt25sdkControlTlv_initWithByteArray_(ComStSt25sdkControlTlv *self, IOSByteArray *buffer) {
  ComStSt25sdkControlTlv_initWithByteArray_withInt_(self, buffer, 0);
}

ComStSt25sdkControlTlv *new_ComStSt25sdkControlTlv_initWithByteArray_(IOSByteArray *buffer) {
  J2OBJC_NEW_IMPL(ComStSt25sdkControlTlv, initWithByteArray_, buffer)
}

ComStSt25sdkControlTlv *create_ComStSt25sdkControlTlv_initWithByteArray_(IOSByteArray *buffer) {
  J2OBJC_CREATE_IMPL(ComStSt25sdkControlTlv, initWithByteArray_, buffer)
}

IOSByteArray *ComStSt25sdkControlTlv_buildTlvBufferWithByte_withInt_withByteArray_(jbyte type, jint length, IOSByteArray *value) {
  ComStSt25sdkControlTlv_initialize();
  IOSByteArray *buffer;
  if (type == ComStSt25sdkControlTlv_NULL_TLV || type == ComStSt25sdkControlTlv_TERMINATOR_TLV) {
    buffer = [IOSByteArray newArrayWithLength:1];
    *IOSByteArray_GetRef(buffer, 0) = type;
  }
  else if (length == (jint) 0x00) {
    buffer = [IOSByteArray newArrayWithLength:2];
    *IOSByteArray_GetRef(buffer, 0) = type;
    *IOSByteArray_GetRef(buffer, 1) = (jint) 0x00;
  }
  else if (length <= (jint) 0xFE) {
    buffer = [IOSByteArray newArrayWithLength:((IOSByteArray *) nil_chk(value))->size_ + 2];
    *IOSByteArray_GetRef(buffer, 0) = type;
    *IOSByteArray_GetRef(buffer, 1) = (jbyte) length;
    JavaLangSystem_arraycopyWithId_withInt_withId_withInt_withInt_(value, 0, buffer, 2, length);
  }
  else {
    buffer = [IOSByteArray newArrayWithLength:((IOSByteArray *) nil_chk(value))->size_ + 4];
    *IOSByteArray_GetRef(buffer, 0) = type;
    *IOSByteArray_GetRef(buffer, 1) = (jbyte) (jint) 0xFF;
    *IOSByteArray_GetRef(buffer, 2) = (jbyte) (JreRShift32(length, 8));
    *IOSByteArray_GetRef(buffer, 3) = (jbyte) (length & (jint) 0xFF);
    JavaLangSystem_arraycopyWithId_withInt_withId_withInt_withInt_(value, 0, buffer, 4, length);
  }
  return buffer;
}

IOSByteArray *ComStSt25sdkControlTlv_buildNullTlv() {
  ComStSt25sdkControlTlv_initialize();
  return ComStSt25sdkControlTlv_buildTlvBufferWithByte_withInt_withByteArray_(ComStSt25sdkControlTlv_NULL_TLV, (jint) 0x00, nil);
}

IOSByteArray *ComStSt25sdkControlTlv_buildLockControlTlvWithByteArray_(IOSByteArray *lockControlBytes) {
  ComStSt25sdkControlTlv_initialize();
  if (lockControlBytes == nil || lockControlBytes->size_ != 3) {
    @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, BAD_PARAMETER));
  }
  return ComStSt25sdkControlTlv_buildTlvBufferWithByte_withInt_withByteArray_(ComStSt25sdkControlTlv_LOCK_CONTROL_TLV, lockControlBytes->size_, lockControlBytes);
}

IOSByteArray *ComStSt25sdkControlTlv_buildMemoryControlTlvWithByteArray_(IOSByteArray *memoryControlBytes) {
  ComStSt25sdkControlTlv_initialize();
  if (memoryControlBytes == nil || memoryControlBytes->size_ != 3) {
    @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, BAD_PARAMETER));
  }
  return ComStSt25sdkControlTlv_buildTlvBufferWithByte_withInt_withByteArray_(ComStSt25sdkControlTlv_MEMORY_CONTROL_TLV, memoryControlBytes->size_, memoryControlBytes);
}

IOSByteArray *ComStSt25sdkControlTlv_buildNdefTlvWithByteArray_(IOSByteArray *ndefMsg) {
  ComStSt25sdkControlTlv_initialize();
  if (ndefMsg == nil) {
    return ComStSt25sdkControlTlv_buildTlvBufferWithByte_withInt_withByteArray_(ComStSt25sdkControlTlv_NDEF_MESSAGE_TLV, (jint) 0x00, nil);
  }
  else {
    return ComStSt25sdkControlTlv_buildTlvBufferWithByte_withInt_withByteArray_(ComStSt25sdkControlTlv_NDEF_MESSAGE_TLV, ndefMsg->size_, ndefMsg);
  }
}

IOSByteArray *ComStSt25sdkControlTlv_buildProprietaryTlvWithByteArray_(IOSByteArray *proprietaryData) {
  ComStSt25sdkControlTlv_initialize();
  if (proprietaryData == nil) {
    return ComStSt25sdkControlTlv_buildTlvBufferWithByte_withInt_withByteArray_(ComStSt25sdkControlTlv_PROPRIETARY_TLV, (jint) 0x00, nil);
  }
  else {
    return ComStSt25sdkControlTlv_buildTlvBufferWithByte_withInt_withByteArray_(ComStSt25sdkControlTlv_PROPRIETARY_TLV, proprietaryData->size_, proprietaryData);
  }
}

IOSByteArray *ComStSt25sdkControlTlv_buildTerminatorTlv() {
  ComStSt25sdkControlTlv_initialize();
  return ComStSt25sdkControlTlv_buildTlvBufferWithByte_withInt_withByteArray_(ComStSt25sdkControlTlv_TERMINATOR_TLV, (jint) 0x00, nil);
}

IOSByteArray *ComStSt25sdkControlTlv_addNullTlvWithByteArray_(IOSByteArray *buffer) {
  ComStSt25sdkControlTlv_initialize();
  return ComStSt25sdkHelper_concatenateByteArraysWithByteArray_withByteArray_(buffer, ComStSt25sdkControlTlv_buildNullTlv());
}

IOSByteArray *ComStSt25sdkControlTlv_addLockControlTlvWithByteArray_withByteArray_(IOSByteArray *buffer, IOSByteArray *lockControlBytes) {
  ComStSt25sdkControlTlv_initialize();
  return ComStSt25sdkHelper_concatenateByteArraysWithByteArray_withByteArray_(buffer, ComStSt25sdkControlTlv_buildLockControlTlvWithByteArray_(lockControlBytes));
}

IOSByteArray *ComStSt25sdkControlTlv_addMemoryControlTlvWithByteArray_withByteArray_(IOSByteArray *buffer, IOSByteArray *memoryControlBytes) {
  ComStSt25sdkControlTlv_initialize();
  return ComStSt25sdkHelper_concatenateByteArraysWithByteArray_withByteArray_(buffer, ComStSt25sdkControlTlv_buildMemoryControlTlvWithByteArray_(memoryControlBytes));
}

IOSByteArray *ComStSt25sdkControlTlv_addLockControlTlvWithByteArray_withInt_withInt_withInt_(IOSByteArray *buffer, jint firstByteAddress, jint nbrOfBitOfDLA, jint bytesLockedPerLockBit) {
  ComStSt25sdkControlTlv_initialize();
  if ((firstByteAddress % ComStSt25sdkCommandType2Command_DEFAULT_NBR_OF_BYTES_PER_BLOCK) != 0) {
    @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, BAD_PARAMETER));
  }
  if (!ComStSt25sdkHelper_isPowerOfTwoWithInt_(bytesLockedPerLockBit)) {
    @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, BAD_PARAMETER));
  }
  for (jint mosDla = 2; mosDla < 16; mosDla++) {
    jint BLPLB_Index = JreFpToInt((JavaLangMath_logWithDouble_(bytesLockedPerLockBit) / JavaLangMath_logWithDouble_(2)));
    if ((BLPLB_Index < 2) || (BLPLB_Index > 10)) {
      @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, BAD_PARAMETER));
    }
    jint majorOffsetSizeDLA = JreFpToInt(JavaLangMath_powWithDouble_withDouble_(2, mosDla));
    jint majorOffset = firstByteAddress / majorOffsetSizeDLA;
    jint minorOffset = firstByteAddress % majorOffsetSizeDLA;
    if ((majorOffset < 16) && (minorOffset < 16)) {
      IOSByteArray *tlv = [IOSByteArray newArrayWithBytes:(jbyte[]){ ComStSt25sdkControlTlv_LOCK_CONTROL_TLV, (jint) 0x03, (jbyte) ((JreLShift32(majorOffset, 4)) | minorOffset), (jbyte) (nbrOfBitOfDLA & (jint) 0xFF), (jbyte) ((JreLShift32(BLPLB_Index, 4)) | mosDla) } count:5];
      return ComStSt25sdkHelper_concatenateByteArraysWithByteArray_withByteArray_(buffer, tlv);
    }
  }
  @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, CMD_FAILED));
}

IOSByteArray *ComStSt25sdkControlTlv_addMemoryControlTlvWithByteArray_withInt_withInt_(IOSByteArray *buffer, jint firstByteAddress, jint sizeInBytes) {
  ComStSt25sdkControlTlv_initialize();
  for (jint mosRa = 2; mosRa < 16; mosRa++) {
    jint majorOffsetSizeReservedArea = JreFpToInt(JavaLangMath_powWithDouble_withDouble_(2, mosRa));
    jint majorOffset = firstByteAddress / majorOffsetSizeReservedArea;
    jint minorOffset = firstByteAddress % majorOffsetSizeReservedArea;
    if ((majorOffset < 16) && (minorOffset < 16)) {
      IOSByteArray *tlv = [IOSByteArray newArrayWithBytes:(jbyte[]){ ComStSt25sdkControlTlv_MEMORY_CONTROL_TLV, (jint) 0x03, (jbyte) ((JreLShift32(majorOffset, 4)) | minorOffset), (jbyte) (sizeInBytes & (jint) 0xFF), (jbyte) mosRa } count:5];
      return ComStSt25sdkHelper_concatenateByteArraysWithByteArray_withByteArray_(buffer, tlv);
    }
  }
  @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, CMD_FAILED));
}

IOSByteArray *ComStSt25sdkControlTlv_addNdefTlvWithByteArray_withByteArray_(IOSByteArray *buffer, IOSByteArray *ndefMsg) {
  ComStSt25sdkControlTlv_initialize();
  return ComStSt25sdkHelper_concatenateByteArraysWithByteArray_withByteArray_(buffer, ComStSt25sdkControlTlv_buildNdefTlvWithByteArray_(ndefMsg));
}

IOSByteArray *ComStSt25sdkControlTlv_addProprietaryTlvWithByteArray_withByteArray_(IOSByteArray *buffer, IOSByteArray *proprietaryData) {
  ComStSt25sdkControlTlv_initialize();
  return ComStSt25sdkHelper_concatenateByteArraysWithByteArray_withByteArray_(buffer, ComStSt25sdkControlTlv_buildProprietaryTlvWithByteArray_(proprietaryData));
}

IOSByteArray *ComStSt25sdkControlTlv_addTerminatorTlvWithByteArray_(IOSByteArray *buffer) {
  ComStSt25sdkControlTlv_initialize();
  return ComStSt25sdkHelper_concatenateByteArraysWithByteArray_withByteArray_(buffer, ComStSt25sdkControlTlv_buildTerminatorTlv());
}

J2OBJC_CLASS_TYPE_LITERAL_SOURCE(ComStSt25sdkControlTlv)
