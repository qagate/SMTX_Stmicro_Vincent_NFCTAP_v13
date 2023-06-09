//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: st25sdk_ios/command/Type2Command.java
//

#include "IOSPrimitiveArray.h"
#include "J2ObjC_source.h"
#include "com/st/st25sdk/Helper.h"
#include "com/st/st25sdk/RFReaderInterface.h"
#include "com/st/st25sdk/STException.h"
#include "com/st/st25sdk/command/Iso14443aCommand.h"
#include "com/st/st25sdk/command/Type2Command.h"
#include "java/lang/Exception.h"
#include "java/lang/Integer.h"
#include "java/lang/System.h"
#include "java/util/ArrayList.h"
#include "java/util/Arrays.h"
#include "java/util/List.h"

@interface ComStSt25sdkCommandType2Command () {
 @public
  id<ComStSt25sdkRFReaderInterface> mReaderInterface_;
  id<JavaUtilList> mOtpBlocksList_;
}

@end

J2OBJC_FIELD_SETTER(ComStSt25sdkCommandType2Command, mReaderInterface_, id<ComStSt25sdkRFReaderInterface>)
J2OBJC_FIELD_SETTER(ComStSt25sdkCommandType2Command, mOtpBlocksList_, id<JavaUtilList>)

@implementation ComStSt25sdkCommandType2Command

+ (jbyte)TYPE2_CMD_READ {
  return ComStSt25sdkCommandType2Command_TYPE2_CMD_READ;
}

+ (jbyte)TYPE2_CMD_WRITE {
  return ComStSt25sdkCommandType2Command_TYPE2_CMD_WRITE;
}

+ (jbyte)TYPE2_CMD_SECTOR_SELECT {
  return ComStSt25sdkCommandType2Command_TYPE2_CMD_SECTOR_SELECT;
}

+ (jint)DEFAULT_NBR_OF_BYTES_PER_BLOCK {
  return ComStSt25sdkCommandType2Command_DEFAULT_NBR_OF_BYTES_PER_BLOCK;
}

+ (jint)DEFAULT_NBR_OF_BLOCKS_PER_READ {
  return ComStSt25sdkCommandType2Command_DEFAULT_NBR_OF_BLOCKS_PER_READ;
}

+ (jint)DEFAULT_NBR_OF_BLOCKS_PER_WRITE {
  return ComStSt25sdkCommandType2Command_DEFAULT_NBR_OF_BLOCKS_PER_WRITE;
}

+ (jint)DEFAULT_SECTOR_SIZE_IN_BLOCKS {
  return ComStSt25sdkCommandType2Command_DEFAULT_SECTOR_SIZE_IN_BLOCKS;
}

+ (jint)NFC_TYPE2_ACK {
  return ComStSt25sdkCommandType2Command_NFC_TYPE2_ACK;
}

- (instancetype)initWithComStSt25sdkRFReaderInterface:(id<ComStSt25sdkRFReaderInterface>)reader {
  ComStSt25sdkCommandType2Command_initWithComStSt25sdkRFReaderInterface_(self, reader);
  return self;
}

- (instancetype)initWithComStSt25sdkRFReaderInterface:(id<ComStSt25sdkRFReaderInterface>)reader
                                              withInt:(jint)blockSize
                                              withInt:(jint)numberOfReadBlocks
                                              withInt:(jint)numberOfWriteBlocks {
  ComStSt25sdkCommandType2Command_initWithComStSt25sdkRFReaderInterface_withInt_withInt_withInt_(self, reader, blockSize, numberOfReadBlocks, numberOfWriteBlocks);
  return self;
}

- (void)setOtpBlocksListWithJavaUtilList:(id<JavaUtilList>)otpBlocksList {
  mOtpBlocksList_ = otpBlocksList;
}

- (jint)getBlockSize {
  return mBlockSizeInBytes_;
}

- (jint)getReadDataSize {
  return mNumberOfReadBlocks_ * mBlockSizeInBytes_;
}

- (jint)getWriteDataSize {
  return mNumberOfWriteBlocks_ * mBlockSizeInBytes_;
}

- (IOSByteArray *)readWithByte:(jbyte)blockNumber {
  NSString *commandName = @"type2_read";
  IOSByteArray *response;
  IOSByteArray *frame = [IOSByteArray newArrayWithLength:2];
  *IOSByteArray_GetRef(frame, 0) = ComStSt25sdkCommandType2Command_TYPE2_CMD_READ;
  *IOSByteArray_GetRef(frame, 1) = blockNumber;
  @try {
    response = [self transceiveWithNSString:commandName withByteArray:frame];
    return response;
  }
  @catch (JavaLangException *e) {
    [e printStackTrace];
    @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, CMD_FAILED));
  }
}

- (IOSByteArray *)writeWithByte:(jbyte)blockNumber
                  withByteArray:(IOSByteArray *)data {
  return [self writeWithByte:blockNumber withByteArray:data withBoolean:false];
}

- (IOSByteArray *)writeWithByte:(jbyte)blockNumber
                  withByteArray:(IOSByteArray *)data
                    withBoolean:(jboolean)allowWriteOfOtpBlocks {
  NSString *commandName = @"type2_write";
  if (((IOSByteArray *) nil_chk(data))->size_ != mNumberOfWriteBlocks_ * mBlockSizeInBytes_) {
    @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, BAD_PARAMETER));
  }
  if (!allowWriteOfOtpBlocks) {
    if ((mOtpBlocksList_ != nil) && [((id<JavaUtilList>) nil_chk(mOtpBlocksList_)) containsWithId:JavaLangInteger_valueOfWithInt_((jint) blockNumber)]) {
      @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, OTP_MEMORY));
    }
  }
  IOSByteArray *response;
  IOSByteArray *frame = [IOSByteArray newArrayWithLength:data->size_ + 2];
  *IOSByteArray_GetRef(frame, 0) = ComStSt25sdkCommandType2Command_TYPE2_CMD_WRITE;
  *IOSByteArray_GetRef(frame, 1) = blockNumber;
  JavaLangSystem_arraycopyWithId_withInt_withId_withInt_withInt_(data, 0, frame, 2, data->size_);
  @try {
    response = [self transceiveWithNSString:commandName withByteArray:frame];
    return response;
  }
  @catch (JavaLangException *e) {
    [e printStackTrace];
    @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, CMD_FAILED));
  }
}

- (IOSByteArray *)sectorSelectCmdPacket1 {
  NSString *commandName = @"type2_sectorSelectCmdPacket1";
  IOSByteArray *response;
  IOSByteArray *frame = [IOSByteArray newArrayWithLength:2];
  *IOSByteArray_GetRef(frame, 0) = ComStSt25sdkCommandType2Command_TYPE2_CMD_SECTOR_SELECT;
  *IOSByteArray_GetRef(frame, 1) = (jbyte) (jint) 0xFF;
  @try {
    response = [self transceiveWithNSString:commandName withByteArray:frame];
    return response;
  }
  @catch (JavaLangException *e) {
    [e printStackTrace];
    @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, CMD_FAILED));
  }
}

- (IOSByteArray *)sectorSelectCmdPacket2WithByte:(jbyte)sectorNumber {
  NSString *commandName = @"type2_sectorSelectCmdPacket2";
  IOSByteArray *response;
  IOSByteArray *frame = [IOSByteArray newArrayWithLength:4];
  *IOSByteArray_GetRef(frame, 0) = sectorNumber;
  *IOSByteArray_GetRef(frame, 1) = (jbyte) (jint) 0x00;
  *IOSByteArray_GetRef(frame, 2) = (jbyte) (jint) 0x00;
  *IOSByteArray_GetRef(frame, 3) = (jbyte) (jint) 0x00;
  @try {
    response = [self transceiveWithNSString:commandName withByteArray:frame];
    return response;
  }
  @catch (ComStSt25sdkSTException *e) {
    if (([e getError] != JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, RFREADER_NO_RESPONSE)) && ([e getError] != JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, TAG_NOT_IN_THE_FIELD))) {
      [e printStackTrace];
      @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, CMD_FAILED));
    }
  }
  return nil;
}

- (IOSByteArray *)sectorSelectWithByte:(jbyte)sectorNumber {
  (void) [self sectorSelectCmdPacket1];
  return [self sectorSelectCmdPacket2WithByte:sectorNumber];
}

- (IOSByteArray *)readBlocksWithInt:(jint)firstBlockAddress
                            withInt:(jint)sizeInBlocks {
  jint nbrOfBlocksRead = 0;
  jint nbrOfBlocksToRead = mNumberOfReadBlocks_;
  jint blockSize = mBlockSizeInBytes_;
  IOSByteArray *buffer = [IOSByteArray newArrayWithLength:sizeInBlocks * blockSize];
  JavaUtilArrays_fillWithByteArray_withByte_(buffer, (jbyte) (jint) 0xFF);
  while (nbrOfBlocksRead < sizeInBlocks) {
    if ((sizeInBlocks - nbrOfBlocksRead) < mNumberOfReadBlocks_) {
      nbrOfBlocksToRead = sizeInBlocks - nbrOfBlocksRead;
    }
    jint blAddr = firstBlockAddress + nbrOfBlocksRead;
    jbyte blNo = (jbyte) (blAddr % ComStSt25sdkCommandType2Command_DEFAULT_SECTOR_SIZE_IN_BLOCKS);
    jbyte secNo = (jbyte) (blAddr / ComStSt25sdkCommandType2Command_DEFAULT_SECTOR_SIZE_IN_BLOCKS);
    if (secNo > 0) {
      (void) [self sectorSelectWithByte:secNo];
    }
    IOSByteArray *tmpBuf = [self readWithByte:blNo];
    if (tmpBuf != nil) {
      if (tmpBuf->size_ != mNumberOfReadBlocks_ * blockSize) {
        @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_withByteArray_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, CMD_FAILED), tmpBuf);
      }
      JavaLangSystem_arraycopyWithId_withInt_withId_withInt_withInt_(tmpBuf, 0, buffer, nbrOfBlocksRead * blockSize, nbrOfBlocksToRead * blockSize);
      nbrOfBlocksRead += nbrOfBlocksToRead;
    }
    else {
      @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, CMD_FAILED));
    }
  }
  if (nbrOfBlocksRead == 0) {
    @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, CMD_FAILED));
  }
  return buffer;
}

- (IOSByteArray *)readBytesWithInt:(jint)byteAddress
                           withInt:(jint)nbOfBytesToRead {
  jint nbrOfBlocks;
  jint blockSize = mBlockSizeInBytes_;
  IOSByteArray *result;
  if ((byteAddress < 0) || (nbOfBytesToRead <= 0)) {
    @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, BAD_PARAMETER));
  }
  jint firstBlAddr = byteAddress / blockSize;
  jint nbrOfBytesToSkipInFirstBlock = byteAddress % blockSize;
  jint lastByteAddr = byteAddress + nbOfBytesToRead - 1;
  jint lastBlAddr = lastByteAddr / blockSize;
  nbrOfBlocks = lastBlAddr - firstBlAddr + 1;
  IOSByteArray *buffer = [IOSByteArray newArrayWithLength:nbrOfBlocks * blockSize];
  JavaUtilArrays_fillWithByteArray_withByte_(buffer, (jbyte) (jint) 0xFF);
  IOSByteArray *tmpBuf = [self readBlocksWithInt:firstBlAddr withInt:nbrOfBlocks];
  if (tmpBuf != nil) {
    if (tmpBuf->size_ == nbrOfBlocks * blockSize) {
      result = [IOSByteArray newArrayWithLength:nbOfBytesToRead];
      JavaLangSystem_arraycopyWithId_withInt_withId_withInt_withInt_(tmpBuf, nbrOfBytesToSkipInFirstBlock, result, 0, result->size_);
    }
    else {
      @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_withByteArray_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, CMD_FAILED), tmpBuf);
    }
  }
  else {
    @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, CMD_FAILED));
  }
  return result;
}

- (void)writeBlocksWithInt:(jint)firstBlockAddress
             withByteArray:(IOSByteArray *)data {
  [self writeBlocksWithInt:firstBlockAddress withByteArray:data withBoolean:false];
}

- (void)writeBlocksWithInt:(jint)firstBlockAddress
             withByteArray:(IOSByteArray *)data
               withBoolean:(jboolean)allowWriteOfOtpBlocks {
  jint nbrOfBlocksWritten = 0;
  jint bytesNumberWrite = mNumberOfWriteBlocks_ * mBlockSizeInBytes_;
  jint nbrOfBlocks = ComStSt25sdkHelper_divisionRoundedUpWithInt_withInt_(((IOSByteArray *) nil_chk(data))->size_, bytesNumberWrite);
  IOSByteArray *buffer = [IOSByteArray newArrayWithLength:nbrOfBlocks * bytesNumberWrite];
  JavaUtilArrays_fillWithByteArray_withByte_(buffer, (jbyte) (jint) 0xFF);
  JavaLangSystem_arraycopyWithId_withInt_withId_withInt_withInt_(data, 0, buffer, 0, data->size_);
  while (nbrOfBlocksWritten < nbrOfBlocks) {
    jint blAddr = firstBlockAddress + nbrOfBlocksWritten;
    jint nbrOfBlocksToWrite = 1;
    IOSByteArray *tmpBuf = [IOSByteArray newArrayWithLength:nbrOfBlocksToWrite * bytesNumberWrite];
    JavaLangSystem_arraycopyWithId_withInt_withId_withInt_withInt_(buffer, nbrOfBlocksWritten * bytesNumberWrite, tmpBuf, 0, nbrOfBlocksToWrite * bytesNumberWrite);
    jbyte blNo = (jbyte) (blAddr % ComStSt25sdkCommandType2Command_DEFAULT_SECTOR_SIZE_IN_BLOCKS);
    jbyte secNo = (jbyte) (blAddr / ComStSt25sdkCommandType2Command_DEFAULT_SECTOR_SIZE_IN_BLOCKS);
    if (secNo > 0) {
      (void) [self sectorSelectWithByte:secNo];
    }
    (void) [self writeWithByte:blNo withByteArray:tmpBuf withBoolean:allowWriteOfOtpBlocks];
    nbrOfBlocksWritten += nbrOfBlocksToWrite;
  }
}

- (void)writeBytesWithInt:(jint)byteAddress
            withByteArray:(IOSByteArray *)data {
  [self writeBytesWithInt:byteAddress withByteArray:data withBoolean:false];
}

- (void)writeBytesWithInt:(jint)byteAddress
            withByteArray:(IOSByteArray *)data
              withBoolean:(jboolean)allowWriteOfOtpBlocks {
  jint nbrOfBlocks;
  jint bytesNumberWrite = mNumberOfWriteBlocks_ * mBlockSizeInBytes_;
  jint sizeInBytes = ((IOSByteArray *) nil_chk(data))->size_;
  if (byteAddress < 0) {
    @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, BAD_PARAMETER));
  }
  jint firstBlAddr = byteAddress / bytesNumberWrite;
  jint nbrOfBytesToSkipInFirstBlock = byteAddress % bytesNumberWrite;
  jint lastByteAddr = byteAddress + sizeInBytes - 1;
  jint lastBlAddr = lastByteAddr / bytesNumberWrite;
  jint nbrOfBytesInLastBlock = 1 + (lastByteAddr % bytesNumberWrite);
  nbrOfBlocks = lastBlAddr - firstBlAddr + 1;
  IOSByteArray *buffer = [IOSByteArray newArrayWithLength:nbrOfBlocks * bytesNumberWrite];
  JavaUtilArrays_fillWithByteArray_withByte_(buffer, (jbyte) (jint) 0xFF);
  if (nbrOfBytesToSkipInFirstBlock != 0) {
    IOSByteArray *firstBlock = [self readBlocksWithInt:firstBlAddr withInt:1];
    JavaLangSystem_arraycopyWithId_withInt_withId_withInt_withInt_(firstBlock, 0, buffer, 0, bytesNumberWrite);
  }
  if (nbrOfBytesInLastBlock != bytesNumberWrite) {
    IOSByteArray *lastBlock = [self readBlocksWithInt:lastBlAddr withInt:1];
    JavaLangSystem_arraycopyWithId_withInt_withId_withInt_withInt_(lastBlock, 0, buffer, buffer->size_ - bytesNumberWrite, bytesNumberWrite);
  }
  JavaLangSystem_arraycopyWithId_withInt_withId_withInt_withInt_(data, 0, buffer, nbrOfBytesToSkipInFirstBlock, data->size_);
  [self writeBlocksWithInt:firstBlAddr withByteArray:buffer withBoolean:allowWriteOfOtpBlocks];
}

- (void)checkType2ResponseWithByteArray:(IOSByteArray *)response {
  if (response == nil) {
    @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, CMD_FAILED));
  }
  else {
    if ((response->size_ == 1) && (IOSByteArray_Get(response, 0) != ComStSt25sdkCommandType2Command_NFC_TYPE2_ACK)) {
      [self generateNackExceptionWithByteArray:response];
    }
  }
}

- (void)generateNackExceptionWithByteArray:(IOSByteArray *)response {
  switch (IOSByteArray_Get(nil_chk(response), 0)) {
    case (jint) 0x00:
    case (jint) 0x01:
    case (jint) 0x04:
    case (jint) 0x05:
    @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_withByteArray_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, NFC_TYPE2_NACK), response);
    default:
    @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_withByteArray_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, NFC_TYPE2_WRONG_ACK_NACK), response);
  }
}

- (IOSByteArray *)transceiveWithNSString:(NSString *)commandName
                           withByteArray:(IOSByteArray *)data {
  IOSByteArray *response = [((id<ComStSt25sdkRFReaderInterface>) nil_chk(mReaderInterface_)) transceiveWithId:JreLoadEnum(ComStSt25sdkCommandIso14443aCommand_iso14443aFrameMode, ISO14443A_STANDARD_FRAME) withNSString:commandName withByteArray:data];
  if ([((id<ComStSt25sdkRFReaderInterface>) nil_chk(mReaderInterface_)) getTransceiveMode] != JreLoadEnum(ComStSt25sdkRFReaderInterface_TransceiveMode, ISO14443A_TRANSPARENT)) {
    [self checkType2ResponseWithByteArray:response];
  }
  return response;
}

+ (const J2ObjcClassInfo *)__metadata {
  static J2ObjcMethodInfo methods[] = {
    { NULL, NULL, 0x1, -1, 0, -1, -1, -1, -1 },
    { NULL, NULL, 0x1, -1, 1, -1, -1, -1, -1 },
    { NULL, "V", 0x1, 2, 3, -1, 4, -1, -1 },
    { NULL, "I", 0x1, -1, -1, -1, -1, -1, -1 },
    { NULL, "I", 0x1, -1, -1, -1, -1, -1, -1 },
    { NULL, "I", 0x1, -1, -1, -1, -1, -1, -1 },
    { NULL, "[B", 0x1, 5, 6, 7, -1, -1, -1 },
    { NULL, "[B", 0x1, 8, 9, 7, -1, -1, -1 },
    { NULL, "[B", 0x1, 8, 10, 7, -1, -1, -1 },
    { NULL, "[B", 0x1, -1, -1, 7, -1, -1, -1 },
    { NULL, "[B", 0x1, 11, 6, 7, -1, -1, -1 },
    { NULL, "[B", 0x1, 12, 6, 7, -1, -1, -1 },
    { NULL, "[B", 0x1, 13, 14, 7, -1, -1, -1 },
    { NULL, "[B", 0x1, 15, 14, 7, -1, -1, -1 },
    { NULL, "V", 0x1, 16, 17, 7, -1, -1, -1 },
    { NULL, "V", 0x1, 16, 18, 7, -1, -1, -1 },
    { NULL, "V", 0x1, 19, 17, 7, -1, -1, -1 },
    { NULL, "V", 0x1, 19, 18, 7, -1, -1, -1 },
    { NULL, "V", 0x4, 20, 21, 7, -1, -1, -1 },
    { NULL, "V", 0x4, 22, 21, 7, -1, -1, -1 },
    { NULL, "[B", 0x1, 23, 24, 7, -1, -1, -1 },
  };
  #pragma clang diagnostic push
  #pragma clang diagnostic ignored "-Wobjc-multiple-method-names"
  #pragma clang diagnostic ignored "-Wundeclared-selector"
  methods[0].selector = @selector(initWithComStSt25sdkRFReaderInterface:);
  methods[1].selector = @selector(initWithComStSt25sdkRFReaderInterface:withInt:withInt:withInt:);
  methods[2].selector = @selector(setOtpBlocksListWithJavaUtilList:);
  methods[3].selector = @selector(getBlockSize);
  methods[4].selector = @selector(getReadDataSize);
  methods[5].selector = @selector(getWriteDataSize);
  methods[6].selector = @selector(readWithByte:);
  methods[7].selector = @selector(writeWithByte:withByteArray:);
  methods[8].selector = @selector(writeWithByte:withByteArray:withBoolean:);
  methods[9].selector = @selector(sectorSelectCmdPacket1);
  methods[10].selector = @selector(sectorSelectCmdPacket2WithByte:);
  methods[11].selector = @selector(sectorSelectWithByte:);
  methods[12].selector = @selector(readBlocksWithInt:withInt:);
  methods[13].selector = @selector(readBytesWithInt:withInt:);
  methods[14].selector = @selector(writeBlocksWithInt:withByteArray:);
  methods[15].selector = @selector(writeBlocksWithInt:withByteArray:withBoolean:);
  methods[16].selector = @selector(writeBytesWithInt:withByteArray:);
  methods[17].selector = @selector(writeBytesWithInt:withByteArray:withBoolean:);
  methods[18].selector = @selector(checkType2ResponseWithByteArray:);
  methods[19].selector = @selector(generateNackExceptionWithByteArray:);
  methods[20].selector = @selector(transceiveWithNSString:withByteArray:);
  #pragma clang diagnostic pop
  static const J2ObjcFieldInfo fields[] = {
    { "mReaderInterface_", "LComStSt25sdkRFReaderInterface;", .constantValue.asLong = 0, 0x2, -1, -1, -1, -1 },
    { "transceiveMode_", "LComStSt25sdkRFReaderInterface_TransceiveMode;", .constantValue.asLong = 0, 0x4, -1, -1, -1, -1 },
    { "mOtpBlocksList_", "LJavaUtilList;", .constantValue.asLong = 0, 0x2, -1, -1, 25, -1 },
    { "TYPE2_CMD_READ", "B", .constantValue.asChar = ComStSt25sdkCommandType2Command_TYPE2_CMD_READ, 0x19, -1, -1, -1, -1 },
    { "TYPE2_CMD_WRITE", "B", .constantValue.asChar = ComStSt25sdkCommandType2Command_TYPE2_CMD_WRITE, 0x19, -1, -1, -1, -1 },
    { "TYPE2_CMD_SECTOR_SELECT", "B", .constantValue.asChar = ComStSt25sdkCommandType2Command_TYPE2_CMD_SECTOR_SELECT, 0x19, -1, -1, -1, -1 },
    { "DEFAULT_NBR_OF_BYTES_PER_BLOCK", "I", .constantValue.asInt = ComStSt25sdkCommandType2Command_DEFAULT_NBR_OF_BYTES_PER_BLOCK, 0x19, -1, -1, -1, -1 },
    { "DEFAULT_NBR_OF_BLOCKS_PER_READ", "I", .constantValue.asInt = ComStSt25sdkCommandType2Command_DEFAULT_NBR_OF_BLOCKS_PER_READ, 0x19, -1, -1, -1, -1 },
    { "DEFAULT_NBR_OF_BLOCKS_PER_WRITE", "I", .constantValue.asInt = ComStSt25sdkCommandType2Command_DEFAULT_NBR_OF_BLOCKS_PER_WRITE, 0x19, -1, -1, -1, -1 },
    { "DEFAULT_SECTOR_SIZE_IN_BLOCKS", "I", .constantValue.asInt = ComStSt25sdkCommandType2Command_DEFAULT_SECTOR_SIZE_IN_BLOCKS, 0x19, -1, -1, -1, -1 },
    { "NFC_TYPE2_ACK", "I", .constantValue.asInt = ComStSt25sdkCommandType2Command_NFC_TYPE2_ACK, 0x19, -1, -1, -1, -1 },
    { "mBlockSizeInBytes_", "I", .constantValue.asLong = 0, 0x4, -1, -1, -1, -1 },
    { "mNumberOfReadBlocks_", "I", .constantValue.asLong = 0, 0x4, -1, -1, -1, -1 },
    { "mNumberOfWriteBlocks_", "I", .constantValue.asLong = 0, 0x4, -1, -1, -1, -1 },
  };
  static const void *ptrTable[] = { "LComStSt25sdkRFReaderInterface;", "LComStSt25sdkRFReaderInterface;III", "setOtpBlocksList", "LJavaUtilList;", "(Ljava/util/List<Ljava/lang/Integer;>;)V", "read", "B", "LComStSt25sdkSTException;", "write", "B[B", "B[BZ", "sectorSelectCmdPacket2", "sectorSelect", "readBlocks", "II", "readBytes", "writeBlocks", "I[B", "I[BZ", "writeBytes", "checkType2Response", "[B", "generateNackException", "transceive", "LNSString;[B", "Ljava/util/List<Ljava/lang/Integer;>;" };
  static const J2ObjcClassInfo _ComStSt25sdkCommandType2Command = { "Type2Command", "com.st.st25sdk.command", ptrTable, methods, fields, 7, 0x1, 21, 14, -1, -1, -1, -1, -1 };
  return &_ComStSt25sdkCommandType2Command;
}

@end

void ComStSt25sdkCommandType2Command_initWithComStSt25sdkRFReaderInterface_(ComStSt25sdkCommandType2Command *self, id<ComStSt25sdkRFReaderInterface> reader) {
  ComStSt25sdkCommandType2Command_initWithComStSt25sdkRFReaderInterface_withInt_withInt_withInt_(self, reader, ComStSt25sdkCommandType2Command_DEFAULT_NBR_OF_BYTES_PER_BLOCK, ComStSt25sdkCommandType2Command_DEFAULT_NBR_OF_BLOCKS_PER_READ, ComStSt25sdkCommandType2Command_DEFAULT_NBR_OF_BLOCKS_PER_WRITE);
}

ComStSt25sdkCommandType2Command *new_ComStSt25sdkCommandType2Command_initWithComStSt25sdkRFReaderInterface_(id<ComStSt25sdkRFReaderInterface> reader) {
  J2OBJC_NEW_IMPL(ComStSt25sdkCommandType2Command, initWithComStSt25sdkRFReaderInterface_, reader)
}

ComStSt25sdkCommandType2Command *create_ComStSt25sdkCommandType2Command_initWithComStSt25sdkRFReaderInterface_(id<ComStSt25sdkRFReaderInterface> reader) {
  J2OBJC_CREATE_IMPL(ComStSt25sdkCommandType2Command, initWithComStSt25sdkRFReaderInterface_, reader)
}

void ComStSt25sdkCommandType2Command_initWithComStSt25sdkRFReaderInterface_withInt_withInt_withInt_(ComStSt25sdkCommandType2Command *self, id<ComStSt25sdkRFReaderInterface> reader, jint blockSize, jint numberOfReadBlocks, jint numberOfWriteBlocks) {
  NSObject_init(self);
  self->mOtpBlocksList_ = new_JavaUtilArrayList_init();
  self->mReaderInterface_ = reader;
  self->mBlockSizeInBytes_ = blockSize;
  self->mNumberOfReadBlocks_ = numberOfReadBlocks;
  self->mNumberOfWriteBlocks_ = numberOfWriteBlocks;
}

ComStSt25sdkCommandType2Command *new_ComStSt25sdkCommandType2Command_initWithComStSt25sdkRFReaderInterface_withInt_withInt_withInt_(id<ComStSt25sdkRFReaderInterface> reader, jint blockSize, jint numberOfReadBlocks, jint numberOfWriteBlocks) {
  J2OBJC_NEW_IMPL(ComStSt25sdkCommandType2Command, initWithComStSt25sdkRFReaderInterface_withInt_withInt_withInt_, reader, blockSize, numberOfReadBlocks, numberOfWriteBlocks)
}

ComStSt25sdkCommandType2Command *create_ComStSt25sdkCommandType2Command_initWithComStSt25sdkRFReaderInterface_withInt_withInt_withInt_(id<ComStSt25sdkRFReaderInterface> reader, jint blockSize, jint numberOfReadBlocks, jint numberOfWriteBlocks) {
  J2OBJC_CREATE_IMPL(ComStSt25sdkCommandType2Command, initWithComStSt25sdkRFReaderInterface_withInt_withInt_withInt_, reader, blockSize, numberOfReadBlocks, numberOfWriteBlocks)
}

J2OBJC_CLASS_TYPE_LITERAL_SOURCE(ComStSt25sdkCommandType2Command)
