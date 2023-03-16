//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: st25sdk_ios/command/VicinityMemoryCommand.java
//

#include "IOSPrimitiveArray.h"
#include "J2ObjC_source.h"
#include "com/st/st25sdk/Helper.h"
#include "com/st/st25sdk/RFReaderInterface.h"
#include "com/st/st25sdk/STException.h"
#include "com/st/st25sdk/STLog.h"
#include "com/st/st25sdk/command/Iso15693Protocol.h"
#include "com/st/st25sdk/command/VicinityCommand.h"
#include "com/st/st25sdk/command/VicinityMemoryCommand.h"
#include "com/st/st25sdk/type5/ReadBlockResult.h"
#include "com/st/st25sdk/type5/Type5Tag.h"
#include "java/io/ByteArrayOutputStream.h"
#include "java/lang/Math.h"
#include "java/lang/System.h"
#include "java/util/Arrays.h"

@interface ComStSt25sdkCommandVicinityMemoryCommand () {
 @public
  ComStSt25sdkCommandVicinityCommand *mVicinityCommand_;
  jint mTagMaxReadMultipleBlockLength_;
  JavaIoByteArrayOutputStream *mByteArrayOutputStream_;
}

- (void)appendDataToByteArrayOutputStreamWithByteArray:(IOSByteArray *)data
                                               withInt:(jint)offset
                                               withInt:(jint)length;

- (void)raiseExceptionWithIncompleteDataWithComStSt25sdkSTException_STExceptionCode:(ComStSt25sdkSTException_STExceptionCode *)errorCode;

- (jint)getReadMultipleBlockMaxLengthInBlocksWithInt:(jint)blockSize;

- (void)readSingleBlocksWithInt:(jint)blockOffset
                        withInt:(jint)nbrOfBlocks
                       withByte:(jbyte)flag
                  withByteArray:(IOSByteArray *)uid;

- (void)writeSingleBlocksWithInt:(jint)blockOffset
                         withInt:(jint)nbrOfBlocks
                   withByteArray:(IOSByteArray *)buffer
                        withByte:(jbyte)flag
                   withByteArray:(IOSByteArray *)uid;

- (IOSByteArray *)readMultipleBlockWithInt:(jint)blockOffset
                                   withInt:(jint)nbrOfBlocks
                                  withByte:(jbyte)flag
                             withByteArray:(IOSByteArray *)uid;

@end

J2OBJC_FIELD_SETTER(ComStSt25sdkCommandVicinityMemoryCommand, mVicinityCommand_, ComStSt25sdkCommandVicinityCommand *)
J2OBJC_FIELD_SETTER(ComStSt25sdkCommandVicinityMemoryCommand, mByteArrayOutputStream_, JavaIoByteArrayOutputStream *)

__attribute__((unused)) static void ComStSt25sdkCommandVicinityMemoryCommand_appendDataToByteArrayOutputStreamWithByteArray_withInt_withInt_(ComStSt25sdkCommandVicinityMemoryCommand *self, IOSByteArray *data, jint offset, jint length);

__attribute__((unused)) static void ComStSt25sdkCommandVicinityMemoryCommand_raiseExceptionWithIncompleteDataWithComStSt25sdkSTException_STExceptionCode_(ComStSt25sdkCommandVicinityMemoryCommand *self, ComStSt25sdkSTException_STExceptionCode *errorCode);

__attribute__((unused)) static jint ComStSt25sdkCommandVicinityMemoryCommand_getReadMultipleBlockMaxLengthInBlocksWithInt_(ComStSt25sdkCommandVicinityMemoryCommand *self, jint blockSize);

__attribute__((unused)) static void ComStSt25sdkCommandVicinityMemoryCommand_readSingleBlocksWithInt_withInt_withByte_withByteArray_(ComStSt25sdkCommandVicinityMemoryCommand *self, jint blockOffset, jint nbrOfBlocks, jbyte flag, IOSByteArray *uid);

__attribute__((unused)) static void ComStSt25sdkCommandVicinityMemoryCommand_writeSingleBlocksWithInt_withInt_withByteArray_withByte_withByteArray_(ComStSt25sdkCommandVicinityMemoryCommand *self, jint blockOffset, jint nbrOfBlocks, IOSByteArray *buffer, jbyte flag, IOSByteArray *uid);

__attribute__((unused)) static IOSByteArray *ComStSt25sdkCommandVicinityMemoryCommand_readMultipleBlockWithInt_withInt_withByte_withByteArray_(ComStSt25sdkCommandVicinityMemoryCommand *self, jint blockOffset, jint nbrOfBlocks, jbyte flag, IOSByteArray *uid);

@implementation ComStSt25sdkCommandVicinityMemoryCommand

- (instancetype)initWithComStSt25sdkRFReaderInterface:(id<ComStSt25sdkRFReaderInterface>)reader
                                        withByteArray:(IOSByteArray *)uid {
  ComStSt25sdkCommandVicinityMemoryCommand_initWithComStSt25sdkRFReaderInterface_withByteArray_(self, reader, uid);
  return self;
}

- (instancetype)initWithComStSt25sdkRFReaderInterface:(id<ComStSt25sdkRFReaderInterface>)reader
                                        withByteArray:(IOSByteArray *)uid
                                             withByte:(jbyte)flag {
  ComStSt25sdkCommandVicinityMemoryCommand_initWithComStSt25sdkRFReaderInterface_withByteArray_withByte_(self, reader, uid, flag);
  return self;
}

- (instancetype)initWithComStSt25sdkRFReaderInterface:(id<ComStSt25sdkRFReaderInterface>)reader
                                        withByteArray:(IOSByteArray *)uid
                                              withInt:(jint)nbrOfBytesPerBlock {
  ComStSt25sdkCommandVicinityMemoryCommand_initWithComStSt25sdkRFReaderInterface_withByteArray_withInt_(self, reader, uid, nbrOfBytesPerBlock);
  return self;
}

- (instancetype)initWithComStSt25sdkRFReaderInterface:(id<ComStSt25sdkRFReaderInterface>)reader
                                        withByteArray:(IOSByteArray *)uid
                                             withByte:(jbyte)flag
                                              withInt:(jint)nbrOfBytesPerBlock {
  ComStSt25sdkCommandVicinityMemoryCommand_initWithComStSt25sdkRFReaderInterface_withByteArray_withByte_withInt_(self, reader, uid, flag, nbrOfBytesPerBlock);
  return self;
}

- (void)setTagMaxReadMultipleBlockLengthWithInt:(jint)tagMaxReadMultipleBlockLength {
  mTagMaxReadMultipleBlockLength_ = tagMaxReadMultipleBlockLength;
}

- (ComStSt25sdkType5ReadBlockResult *)readBlocksWithInt:(jint)firstBlockAddress
                                                withInt:(jint)sizeInBlocks {
  return [self readBlocksWithInt:firstBlockAddress withInt:sizeInBlocks withByte:mFlag_ withByteArray:mUid_];
}

- (ComStSt25sdkType5ReadBlockResult *)readBlocksWithInt:(jint)firstBlockAddress
                                                withInt:(jint)sizeInBlocks
                                               withByte:(jbyte)flag
                                          withByteArray:(IOSByteArray *)uid {
  jint nbrOfBlocksRead = 0;
  jint blockSize = mNbrOfBytesPerBlock_;
  if ((flag & ComStSt25sdkCommandIso15693Protocol_OPTION_FLAG) == ComStSt25sdkCommandIso15693Protocol_OPTION_FLAG) {
    blockSize++;
  }
  jint readMultipleBlockMaxLengthInBlocks = ComStSt25sdkCommandVicinityMemoryCommand_getReadMultipleBlockMaxLengthInBlocksWithInt_(self, blockSize);
  [((JavaIoByteArrayOutputStream *) nil_chk(mByteArrayOutputStream_)) reset];
  while (nbrOfBlocksRead < sizeInBlocks) {
    jboolean isReadMultipleSuccessful = false;
    jint blockAddress = firstBlockAddress + nbrOfBlocksRead;
    jint nbrOfRemainingBlocks = sizeInBlocks - nbrOfBlocksRead;
    jint nbrOfBlocksToRead = 1;
    if (nbrOfRemainingBlocks > 1) {
      @try {
        nbrOfBlocksToRead = JavaLangMath_minWithInt_withInt_(readMultipleBlockMaxLengthInBlocks, nbrOfRemainingBlocks);
        nbrOfBlocksToRead = JavaLangMath_minWithInt_withInt_(nbrOfBlocksToRead, 32);
        IOSByteArray *tmpBuf = ComStSt25sdkCommandVicinityMemoryCommand_readMultipleBlockWithInt_withInt_withByte_withByteArray_(self, blockAddress, nbrOfBlocksToRead, flag, uid);
        if (tmpBuf != nil) {
          ComStSt25sdkCommandVicinityMemoryCommand_appendDataToByteArrayOutputStreamWithByteArray_withInt_withInt_(self, tmpBuf, 1, tmpBuf->size_ - 1);
        }
        nbrOfBlocksRead += nbrOfBlocksToRead;
        isReadMultipleSuccessful = true;
      }
      @catch (ComStSt25sdkSTException *e) {
        isReadMultipleSuccessful = false;
      }
    }
    if (!isReadMultipleSuccessful) {
      ComStSt25sdkCommandVicinityMemoryCommand_readSingleBlocksWithInt_withInt_withByte_withByteArray_(self, blockAddress, nbrOfBlocksToRead, flag, uid);
    }
    jint nbrOfBytesRead = [((JavaIoByteArrayOutputStream *) nil_chk(mByteArrayOutputStream_)) size];
    nbrOfBlocksRead = nbrOfBytesRead / blockSize;
  }
  if (nbrOfBlocksRead == 0) {
    @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, CMD_FAILED));
  }
  ComStSt25sdkType5ReadBlockResult *response = new_ComStSt25sdkType5ReadBlockResult_initWithInt_withInt_(nbrOfBlocksRead, mNbrOfBytesPerBlock_);
  IOSByteArray *buffer = [((JavaIoByteArrayOutputStream *) nil_chk(mByteArrayOutputStream_)) toByteArray];
  if ((flag & ComStSt25sdkCommandIso15693Protocol_OPTION_FLAG) == ComStSt25sdkCommandIso15693Protocol_OPTION_FLAG) {
    for (jint blockIndex = 0; blockIndex < nbrOfBlocksRead; blockIndex++) {
      *IOSByteArray_GetRef(nil_chk(response->blockSecurityStatus_), blockIndex) = IOSByteArray_Get(nil_chk(buffer), blockIndex * blockSize);
      JavaLangSystem_arraycopyWithId_withInt_withId_withInt_withInt_(buffer, blockIndex * blockSize + 1, response->data_, blockIndex * mNbrOfBytesPerBlock_, mNbrOfBytesPerBlock_);
    }
  }
  else {
    JavaLangSystem_arraycopyWithId_withInt_withId_withInt_withInt_(buffer, 0, response->data_, 0, ((IOSByteArray *) nil_chk(response->data_))->size_);
  }
  return response;
}

- (void)appendDataToByteArrayOutputStreamWithByteArray:(IOSByteArray *)data
                                               withInt:(jint)offset
                                               withInt:(jint)length {
  ComStSt25sdkCommandVicinityMemoryCommand_appendDataToByteArrayOutputStreamWithByteArray_withInt_withInt_(self, data, offset, length);
}

- (void)raiseExceptionWithIncompleteDataWithComStSt25sdkSTException_STExceptionCode:(ComStSt25sdkSTException_STExceptionCode *)errorCode {
  ComStSt25sdkCommandVicinityMemoryCommand_raiseExceptionWithIncompleteDataWithComStSt25sdkSTException_STExceptionCode_(self, errorCode);
}

- (jint)getReadMultipleBlockMaxLengthInBlocksWithInt:(jint)blockSize {
  return ComStSt25sdkCommandVicinityMemoryCommand_getReadMultipleBlockMaxLengthInBlocksWithInt_(self, blockSize);
}

- (void)writeBlocksWithInt:(jint)firstBlockAddress
             withByteArray:(IOSByteArray *)data {
  [self writeBlocksWithInt:firstBlockAddress withByteArray:data withByte:mFlag_ withByteArray:mUid_];
}

- (void)writeBlocksWithInt:(jint)firstBlockAddress
             withByteArray:(IOSByteArray *)data
                  withByte:(jbyte)flag
             withByteArray:(IOSByteArray *)uid {
  jint nbrOfBlocksWritten = 0;
  jint nbrOfBlocks = ComStSt25sdkHelper_divisionRoundedUpWithInt_withInt_(((IOSByteArray *) nil_chk(data))->size_, mNbrOfBytesPerBlock_);
  IOSByteArray *buffer = [IOSByteArray newArrayWithLength:nbrOfBlocks * mNbrOfBytesPerBlock_];
  JavaUtilArrays_fillWithByteArray_withByte_(buffer, (jbyte) (jint) 0xFF);
  JavaLangSystem_arraycopyWithId_withInt_withId_withInt_withInt_(data, 0, buffer, 0, data->size_);
  while (nbrOfBlocksWritten < nbrOfBlocks) {
    jint blockAddress = firstBlockAddress + nbrOfBlocksWritten;
    jint nbrOfBlocksToWrite = 1;
    IOSByteArray *tmpBuf = [IOSByteArray newArrayWithLength:nbrOfBlocksToWrite * mNbrOfBytesPerBlock_];
    JavaLangSystem_arraycopyWithId_withInt_withId_withInt_withInt_(buffer, nbrOfBlocksWritten * mNbrOfBytesPerBlock_, tmpBuf, 0, nbrOfBlocksToWrite * mNbrOfBytesPerBlock_);
    ComStSt25sdkCommandVicinityMemoryCommand_writeSingleBlocksWithInt_withInt_withByteArray_withByte_withByteArray_(self, blockAddress, nbrOfBlocksToWrite, tmpBuf, flag, uid);
    nbrOfBlocksWritten += nbrOfBlocksToWrite;
  }
}

- (IOSByteArray *)readBytesWithInt:(jint)byteAddress
                           withInt:(jint)sizeInBytes {
  return [self readBytesWithInt:byteAddress withInt:sizeInBytes withByte:mFlag_ withByteArray:mUid_];
}

- (IOSByteArray *)readBytesWithInt:(jint)byteAddress
                           withInt:(jint)sizeInBytes
                          withByte:(jbyte)flag
                     withByteArray:(IOSByteArray *)uid {
  jint nbrOfBlocks;
  jint blockSize = mNbrOfBytesPerBlock_;
  IOSByteArray *result;
  if ((byteAddress < 0) || (sizeInBytes <= 0)) {
    @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, BAD_PARAMETER));
  }
  jint firstBlockAddress = byteAddress / mNbrOfBytesPerBlock_;
  jint nbrOfBytesToSkipInFirstBlock = byteAddress % mNbrOfBytesPerBlock_;
  jint lastByteAddress = byteAddress + sizeInBytes - 1;
  jint lastBlockAddress = lastByteAddress / mNbrOfBytesPerBlock_;
  nbrOfBlocks = lastBlockAddress - firstBlockAddress + 1;
  IOSByteArray *buffer = [IOSByteArray newArrayWithLength:nbrOfBlocks * blockSize];
  JavaUtilArrays_fillWithByteArray_withByte_(buffer, (jbyte) (jint) 0xFF);
  ComStSt25sdkType5ReadBlockResult *tmpBuf = [self readBlocksWithInt:firstBlockAddress withInt:nbrOfBlocks withByte:flag withByteArray:uid];
  if (tmpBuf != nil && tmpBuf->data_ != nil) {
    if (tmpBuf->data_->size_ == nbrOfBlocks * blockSize) {
      result = [IOSByteArray newArrayWithLength:sizeInBytes];
      JavaLangSystem_arraycopyWithId_withInt_withId_withInt_withInt_(tmpBuf->data_, nbrOfBytesToSkipInFirstBlock, result, 0, result->size_);
    }
    else {
      @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_withByteArray_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, CMD_FAILED), tmpBuf->data_);
    }
  }
  else {
    @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, CMD_FAILED));
  }
  return result;
}

- (void)writeBytesWithInt:(jint)byteAddress
            withByteArray:(IOSByteArray *)data {
  [self writeBytesWithInt:byteAddress withByteArray:data withByte:mFlag_ withByteArray:mUid_];
}

- (void)writeBytesWithInt:(jint)byteAddress
            withByteArray:(IOSByteArray *)data
                 withByte:(jbyte)flag
            withByteArray:(IOSByteArray *)uid {
  jint nbrOfBlocks;
  jint sizeInBytes = ((IOSByteArray *) nil_chk(data))->size_;
  if (byteAddress < 0) {
    @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, BAD_PARAMETER));
  }
  jint firstBlockAddress = byteAddress / mNbrOfBytesPerBlock_;
  jint nbrOfBytesToSkipInFirstBlock = byteAddress % mNbrOfBytesPerBlock_;
  jint lastByteAddress = byteAddress + sizeInBytes - 1;
  jint lastBlockAddress = lastByteAddress / mNbrOfBytesPerBlock_;
  jint nbrOfBytesInLastBlock = 1 + (lastByteAddress % mNbrOfBytesPerBlock_);
  nbrOfBlocks = lastBlockAddress - firstBlockAddress + 1;
  IOSByteArray *buffer = [IOSByteArray newArrayWithLength:nbrOfBlocks * mNbrOfBytesPerBlock_];
  JavaUtilArrays_fillWithByteArray_withByte_(buffer, (jbyte) (jint) 0xFF);
  if (nbrOfBytesToSkipInFirstBlock != 0) {
    ComStSt25sdkType5ReadBlockResult *blockContent = [self readBlocksWithInt:firstBlockAddress withInt:1 withByte:flag withByteArray:uid];
    IOSByteArray *firstBlock = ((ComStSt25sdkType5ReadBlockResult *) nil_chk(blockContent))->data_;
    JavaLangSystem_arraycopyWithId_withInt_withId_withInt_withInt_(firstBlock, 0, buffer, 0, mNbrOfBytesPerBlock_);
  }
  if (nbrOfBytesInLastBlock != mNbrOfBytesPerBlock_) {
    ComStSt25sdkType5ReadBlockResult *blockContent = [self readBlocksWithInt:lastBlockAddress withInt:1 withByte:flag withByteArray:uid];
    IOSByteArray *lastBlock = ((ComStSt25sdkType5ReadBlockResult *) nil_chk(blockContent))->data_;
    JavaLangSystem_arraycopyWithId_withInt_withId_withInt_withInt_(lastBlock, 0, buffer, buffer->size_ - mNbrOfBytesPerBlock_, mNbrOfBytesPerBlock_);
  }
  JavaLangSystem_arraycopyWithId_withInt_withId_withInt_withInt_(data, 0, buffer, nbrOfBytesToSkipInFirstBlock, data->size_);
  [self writeBlocksWithInt:firstBlockAddress withByteArray:buffer withByte:flag withByteArray:uid];
}

- (void)readSingleBlocksWithInt:(jint)blockOffset
                        withInt:(jint)nbrOfBlocks
                       withByte:(jbyte)flag
                  withByteArray:(IOSByteArray *)uid {
  ComStSt25sdkCommandVicinityMemoryCommand_readSingleBlocksWithInt_withInt_withByte_withByteArray_(self, blockOffset, nbrOfBlocks, flag, uid);
}

- (void)writeSingleBlocksWithInt:(jint)blockOffset
                         withInt:(jint)nbrOfBlocks
                   withByteArray:(IOSByteArray *)buffer
                        withByte:(jbyte)flag
                   withByteArray:(IOSByteArray *)uid {
  ComStSt25sdkCommandVicinityMemoryCommand_writeSingleBlocksWithInt_withInt_withByteArray_withByte_withByteArray_(self, blockOffset, nbrOfBlocks, buffer, flag, uid);
}

- (IOSByteArray *)readSingleBlockWithInt:(jint)blockOffset
                                withByte:(jbyte)flag
                           withByteArray:(IOSByteArray *)uid {
  IOSByteArray *result;
  if ((blockOffset < 0) || (blockOffset > (jint) 0xFFFF)) {
    @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, BAD_PARAMETER));
  }
  result = [((ComStSt25sdkCommandVicinityCommand *) nil_chk(mVicinityCommand_)) readSingleBlockWithByteArray:ComStSt25sdkHelper_convertIntTo2BytesHexaFormatWithInt_(blockOffset) withByte:flag withByteArray:uid];
  return result;
}

- (IOSByteArray *)readMultipleBlockWithInt:(jint)blockOffset
                                   withInt:(jint)nbrOfBlocks
                                  withByte:(jbyte)flag
                             withByteArray:(IOSByteArray *)uid {
  return ComStSt25sdkCommandVicinityMemoryCommand_readMultipleBlockWithInt_withInt_withByte_withByteArray_(self, blockOffset, nbrOfBlocks, flag, uid);
}

- (jbyte)writeSingleBlockWithInt:(jint)blockOffset
                   withByteArray:(IOSByteArray *)buffer
                        withByte:(jbyte)flag
                   withByteArray:(IOSByteArray *)uid {
  jbyte result;
  if ((blockOffset < 0) || (blockOffset > (jint) 0xFFFF)) {
    @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, BAD_PARAMETER));
  }
  if (blockOffset > (jint) 0xFFFF) {
    @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, BAD_PARAMETER));
  }
  result = [((ComStSt25sdkCommandVicinityCommand *) nil_chk(mVicinityCommand_)) writeSingleBlockWithByteArray:ComStSt25sdkHelper_convertIntTo2BytesHexaFormatWithInt_(blockOffset) withByteArray:buffer withByte:flag withByteArray:uid];
  return result;
}

+ (const J2ObjcClassInfo *)__metadata {
  static J2ObjcMethodInfo methods[] = {
    { NULL, NULL, 0x1, -1, 0, -1, -1, -1, -1 },
    { NULL, NULL, 0x1, -1, 1, -1, -1, -1, -1 },
    { NULL, NULL, 0x1, -1, 2, -1, -1, -1, -1 },
    { NULL, NULL, 0x1, -1, 3, -1, -1, -1, -1 },
    { NULL, "V", 0x1, 4, 5, -1, -1, -1, -1 },
    { NULL, "LComStSt25sdkType5ReadBlockResult;", 0x1, 6, 7, 8, -1, -1, -1 },
    { NULL, "LComStSt25sdkType5ReadBlockResult;", 0x1, 6, 9, 8, -1, -1, -1 },
    { NULL, "V", 0x2, 10, 11, -1, -1, -1, -1 },
    { NULL, "V", 0x2, 12, 13, 8, -1, -1, -1 },
    { NULL, "I", 0x2, 14, 5, -1, -1, -1, -1 },
    { NULL, "V", 0x1, 15, 16, 8, -1, -1, -1 },
    { NULL, "V", 0x1, 15, 17, 8, -1, -1, -1 },
    { NULL, "[B", 0x1, 18, 7, 8, -1, -1, -1 },
    { NULL, "[B", 0x1, 18, 9, 8, -1, -1, -1 },
    { NULL, "V", 0x1, 19, 16, 8, -1, -1, -1 },
    { NULL, "V", 0x1, 19, 17, 8, -1, -1, -1 },
    { NULL, "V", 0x2, 20, 9, 8, -1, -1, -1 },
    { NULL, "V", 0x2, 21, 22, 8, -1, -1, -1 },
    { NULL, "[B", 0x1, 23, 24, 8, -1, -1, -1 },
    { NULL, "[B", 0x2, 25, 9, 8, -1, -1, -1 },
    { NULL, "B", 0x1, 26, 17, 8, -1, -1, -1 },
  };
  #pragma clang diagnostic push
  #pragma clang diagnostic ignored "-Wobjc-multiple-method-names"
  #pragma clang diagnostic ignored "-Wundeclared-selector"
  methods[0].selector = @selector(initWithComStSt25sdkRFReaderInterface:withByteArray:);
  methods[1].selector = @selector(initWithComStSt25sdkRFReaderInterface:withByteArray:withByte:);
  methods[2].selector = @selector(initWithComStSt25sdkRFReaderInterface:withByteArray:withInt:);
  methods[3].selector = @selector(initWithComStSt25sdkRFReaderInterface:withByteArray:withByte:withInt:);
  methods[4].selector = @selector(setTagMaxReadMultipleBlockLengthWithInt:);
  methods[5].selector = @selector(readBlocksWithInt:withInt:);
  methods[6].selector = @selector(readBlocksWithInt:withInt:withByte:withByteArray:);
  methods[7].selector = @selector(appendDataToByteArrayOutputStreamWithByteArray:withInt:withInt:);
  methods[8].selector = @selector(raiseExceptionWithIncompleteDataWithComStSt25sdkSTException_STExceptionCode:);
  methods[9].selector = @selector(getReadMultipleBlockMaxLengthInBlocksWithInt:);
  methods[10].selector = @selector(writeBlocksWithInt:withByteArray:);
  methods[11].selector = @selector(writeBlocksWithInt:withByteArray:withByte:withByteArray:);
  methods[12].selector = @selector(readBytesWithInt:withInt:);
  methods[13].selector = @selector(readBytesWithInt:withInt:withByte:withByteArray:);
  methods[14].selector = @selector(writeBytesWithInt:withByteArray:);
  methods[15].selector = @selector(writeBytesWithInt:withByteArray:withByte:withByteArray:);
  methods[16].selector = @selector(readSingleBlocksWithInt:withInt:withByte:withByteArray:);
  methods[17].selector = @selector(writeSingleBlocksWithInt:withInt:withByteArray:withByte:withByteArray:);
  methods[18].selector = @selector(readSingleBlockWithInt:withByte:withByteArray:);
  methods[19].selector = @selector(readMultipleBlockWithInt:withInt:withByte:withByteArray:);
  methods[20].selector = @selector(writeSingleBlockWithInt:withByteArray:withByte:withByteArray:);
  #pragma clang diagnostic pop
  static const J2ObjcFieldInfo fields[] = {
    { "mVicinityCommand_", "LComStSt25sdkCommandVicinityCommand;", .constantValue.asLong = 0, 0x2, -1, -1, -1, -1 },
    { "mTagMaxReadMultipleBlockLength_", "I", .constantValue.asLong = 0, 0x2, -1, -1, -1, -1 },
    { "mByteArrayOutputStream_", "LJavaIoByteArrayOutputStream;", .constantValue.asLong = 0, 0x2, -1, -1, -1, -1 },
  };
  static const void *ptrTable[] = { "LComStSt25sdkRFReaderInterface;[B", "LComStSt25sdkRFReaderInterface;[BB", "LComStSt25sdkRFReaderInterface;[BI", "LComStSt25sdkRFReaderInterface;[BBI", "setTagMaxReadMultipleBlockLength", "I", "readBlocks", "II", "LComStSt25sdkSTException;", "IIB[B", "appendDataToByteArrayOutputStream", "[BII", "raiseExceptionWithIncompleteData", "LComStSt25sdkSTException_STExceptionCode;", "getReadMultipleBlockMaxLengthInBlocks", "writeBlocks", "I[B", "I[BB[B", "readBytes", "writeBytes", "readSingleBlocks", "writeSingleBlocks", "II[BB[B", "readSingleBlock", "IB[B", "readMultipleBlock", "writeSingleBlock" };
  static const J2ObjcClassInfo _ComStSt25sdkCommandVicinityMemoryCommand = { "VicinityMemoryCommand", "com.st.st25sdk.command", ptrTable, methods, fields, 7, 0x1, 21, 3, -1, -1, -1, -1, -1 };
  return &_ComStSt25sdkCommandVicinityMemoryCommand;
}

@end

void ComStSt25sdkCommandVicinityMemoryCommand_initWithComStSt25sdkRFReaderInterface_withByteArray_(ComStSt25sdkCommandVicinityMemoryCommand *self, id<ComStSt25sdkRFReaderInterface> reader, IOSByteArray *uid) {
  ComStSt25sdkCommandVicinityMemoryCommand_initWithComStSt25sdkRFReaderInterface_withByteArray_withByte_withInt_(self, reader, uid, ComStSt25sdkCommandIso15693Protocol_DEFAULT_VICINITY_FLAG, ComStSt25sdkType5Type5Tag_DEFAULT_NBR_OF_BYTES_PER_BLOCK);
}

ComStSt25sdkCommandVicinityMemoryCommand *new_ComStSt25sdkCommandVicinityMemoryCommand_initWithComStSt25sdkRFReaderInterface_withByteArray_(id<ComStSt25sdkRFReaderInterface> reader, IOSByteArray *uid) {
  J2OBJC_NEW_IMPL(ComStSt25sdkCommandVicinityMemoryCommand, initWithComStSt25sdkRFReaderInterface_withByteArray_, reader, uid)
}

ComStSt25sdkCommandVicinityMemoryCommand *create_ComStSt25sdkCommandVicinityMemoryCommand_initWithComStSt25sdkRFReaderInterface_withByteArray_(id<ComStSt25sdkRFReaderInterface> reader, IOSByteArray *uid) {
  J2OBJC_CREATE_IMPL(ComStSt25sdkCommandVicinityMemoryCommand, initWithComStSt25sdkRFReaderInterface_withByteArray_, reader, uid)
}

void ComStSt25sdkCommandVicinityMemoryCommand_initWithComStSt25sdkRFReaderInterface_withByteArray_withByte_(ComStSt25sdkCommandVicinityMemoryCommand *self, id<ComStSt25sdkRFReaderInterface> reader, IOSByteArray *uid, jbyte flag) {
  ComStSt25sdkCommandVicinityMemoryCommand_initWithComStSt25sdkRFReaderInterface_withByteArray_withByte_withInt_(self, reader, uid, flag, ComStSt25sdkType5Type5Tag_DEFAULT_NBR_OF_BYTES_PER_BLOCK);
}

ComStSt25sdkCommandVicinityMemoryCommand *new_ComStSt25sdkCommandVicinityMemoryCommand_initWithComStSt25sdkRFReaderInterface_withByteArray_withByte_(id<ComStSt25sdkRFReaderInterface> reader, IOSByteArray *uid, jbyte flag) {
  J2OBJC_NEW_IMPL(ComStSt25sdkCommandVicinityMemoryCommand, initWithComStSt25sdkRFReaderInterface_withByteArray_withByte_, reader, uid, flag)
}

ComStSt25sdkCommandVicinityMemoryCommand *create_ComStSt25sdkCommandVicinityMemoryCommand_initWithComStSt25sdkRFReaderInterface_withByteArray_withByte_(id<ComStSt25sdkRFReaderInterface> reader, IOSByteArray *uid, jbyte flag) {
  J2OBJC_CREATE_IMPL(ComStSt25sdkCommandVicinityMemoryCommand, initWithComStSt25sdkRFReaderInterface_withByteArray_withByte_, reader, uid, flag)
}

void ComStSt25sdkCommandVicinityMemoryCommand_initWithComStSt25sdkRFReaderInterface_withByteArray_withInt_(ComStSt25sdkCommandVicinityMemoryCommand *self, id<ComStSt25sdkRFReaderInterface> reader, IOSByteArray *uid, jint nbrOfBytesPerBlock) {
  ComStSt25sdkCommandVicinityMemoryCommand_initWithComStSt25sdkRFReaderInterface_withByteArray_withByte_withInt_(self, reader, uid, ComStSt25sdkCommandIso15693Protocol_DEFAULT_VICINITY_FLAG, nbrOfBytesPerBlock);
}

ComStSt25sdkCommandVicinityMemoryCommand *new_ComStSt25sdkCommandVicinityMemoryCommand_initWithComStSt25sdkRFReaderInterface_withByteArray_withInt_(id<ComStSt25sdkRFReaderInterface> reader, IOSByteArray *uid, jint nbrOfBytesPerBlock) {
  J2OBJC_NEW_IMPL(ComStSt25sdkCommandVicinityMemoryCommand, initWithComStSt25sdkRFReaderInterface_withByteArray_withInt_, reader, uid, nbrOfBytesPerBlock)
}

ComStSt25sdkCommandVicinityMemoryCommand *create_ComStSt25sdkCommandVicinityMemoryCommand_initWithComStSt25sdkRFReaderInterface_withByteArray_withInt_(id<ComStSt25sdkRFReaderInterface> reader, IOSByteArray *uid, jint nbrOfBytesPerBlock) {
  J2OBJC_CREATE_IMPL(ComStSt25sdkCommandVicinityMemoryCommand, initWithComStSt25sdkRFReaderInterface_withByteArray_withInt_, reader, uid, nbrOfBytesPerBlock)
}

void ComStSt25sdkCommandVicinityMemoryCommand_initWithComStSt25sdkRFReaderInterface_withByteArray_withByte_withInt_(ComStSt25sdkCommandVicinityMemoryCommand *self, id<ComStSt25sdkRFReaderInterface> reader, IOSByteArray *uid, jbyte flag, jint nbrOfBytesPerBlock) {
  ComStSt25sdkCommandIso15693Protocol_initWithComStSt25sdkRFReaderInterface_withByteArray_withByte_withInt_(self, reader, uid, flag, nbrOfBytesPerBlock);
  self->mTagMaxReadMultipleBlockLength_ = ComStSt25sdkCommandIso15693Protocol_DEFAULT_READ_MULTIPLE_MAX_NBR_OF_BLOCKS;
  if ((flag & ComStSt25sdkCommandIso15693Protocol_PROTOCOL_FORMAT_EXTENSION) == 0) {
    ComStSt25sdkSTLog_eWithNSString_(@"Error! Flag PROTOCOL_FORMAT_EXTENSION is mandatory for this class");
  }
  self->mVicinityCommand_ = new_ComStSt25sdkCommandVicinityCommand_initWithComStSt25sdkRFReaderInterface_withByteArray_withByte_withInt_(reader, uid, flag, nbrOfBytesPerBlock);
  self->mByteArrayOutputStream_ = new_JavaIoByteArrayOutputStream_init();
}

ComStSt25sdkCommandVicinityMemoryCommand *new_ComStSt25sdkCommandVicinityMemoryCommand_initWithComStSt25sdkRFReaderInterface_withByteArray_withByte_withInt_(id<ComStSt25sdkRFReaderInterface> reader, IOSByteArray *uid, jbyte flag, jint nbrOfBytesPerBlock) {
  J2OBJC_NEW_IMPL(ComStSt25sdkCommandVicinityMemoryCommand, initWithComStSt25sdkRFReaderInterface_withByteArray_withByte_withInt_, reader, uid, flag, nbrOfBytesPerBlock)
}

ComStSt25sdkCommandVicinityMemoryCommand *create_ComStSt25sdkCommandVicinityMemoryCommand_initWithComStSt25sdkRFReaderInterface_withByteArray_withByte_withInt_(id<ComStSt25sdkRFReaderInterface> reader, IOSByteArray *uid, jbyte flag, jint nbrOfBytesPerBlock) {
  J2OBJC_CREATE_IMPL(ComStSt25sdkCommandVicinityMemoryCommand, initWithComStSt25sdkRFReaderInterface_withByteArray_withByte_withInt_, reader, uid, flag, nbrOfBytesPerBlock)
}

void ComStSt25sdkCommandVicinityMemoryCommand_appendDataToByteArrayOutputStreamWithByteArray_withInt_withInt_(ComStSt25sdkCommandVicinityMemoryCommand *self, IOSByteArray *data, jint offset, jint length) {
  if ((self->mByteArrayOutputStream_ != nil) && (data != nil)) {
    [((JavaIoByteArrayOutputStream *) nil_chk(self->mByteArrayOutputStream_)) writeWithByteArray:data withInt:offset withInt:length];
  }
}

void ComStSt25sdkCommandVicinityMemoryCommand_raiseExceptionWithIncompleteDataWithComStSt25sdkSTException_STExceptionCode_(ComStSt25sdkCommandVicinityMemoryCommand *self, ComStSt25sdkSTException_STExceptionCode *errorCode) {
  IOSByteArray *data = nil;
  if (self->mByteArrayOutputStream_ != nil) {
    data = [self->mByteArrayOutputStream_ toByteArray];
  }
  @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_withByteArray_(errorCode, data);
}

jint ComStSt25sdkCommandVicinityMemoryCommand_getReadMultipleBlockMaxLengthInBlocksWithInt_(ComStSt25sdkCommandVicinityMemoryCommand *self, jint blockSize) {
  jint maxReceiveLengthInBytes = [((id<ComStSt25sdkRFReaderInterface>) nil_chk(self->mReaderInterface_)) getMaxReceiveLengthInBytes];
  jint maxDataLengthInBytes = maxReceiveLengthInBytes - 3;
  jint readerMaxReadMultipleBlockLength = maxDataLengthInBytes / blockSize;
  jint maxNbrOfBlocks = JavaLangMath_minWithInt_withInt_(readerMaxReadMultipleBlockLength, self->mTagMaxReadMultipleBlockLength_);
  return maxNbrOfBlocks;
}

void ComStSt25sdkCommandVicinityMemoryCommand_readSingleBlocksWithInt_withInt_withByte_withByteArray_(ComStSt25sdkCommandVicinityMemoryCommand *self, jint blockOffset, jint nbrOfBlocks, jbyte flag, IOSByteArray *uid) {
  for (jint block = 0; block < nbrOfBlocks; block++) {
    jint blockAddress = blockOffset + block;
    @try {
      IOSByteArray *tmpBuf = [self readSingleBlockWithInt:blockAddress withByte:flag withByteArray:uid];
      if (tmpBuf != nil) {
        ComStSt25sdkCommandVicinityMemoryCommand_appendDataToByteArrayOutputStreamWithByteArray_withInt_withInt_(self, tmpBuf, 1, tmpBuf->size_ - 1);
      }
    }
    @catch (ComStSt25sdkSTException *e) {
      ComStSt25sdkCommandVicinityMemoryCommand_raiseExceptionWithIncompleteDataWithComStSt25sdkSTException_STExceptionCode_(self, [e getError]);
    }
  }
}

void ComStSt25sdkCommandVicinityMemoryCommand_writeSingleBlocksWithInt_withInt_withByteArray_withByte_withByteArray_(ComStSt25sdkCommandVicinityMemoryCommand *self, jint blockOffset, jint nbrOfBlocks, IOSByteArray *buffer, jbyte flag, IOSByteArray *uid) {
  for (jint block = 0; block < nbrOfBlocks; block++) {
    jint blockAddress = blockOffset + block;
    IOSByteArray *tmpBuf = [IOSByteArray newArrayWithLength:self->mNbrOfBytesPerBlock_];
    JavaLangSystem_arraycopyWithId_withInt_withId_withInt_withInt_(buffer, block * self->mNbrOfBytesPerBlock_, tmpBuf, 0, self->mNbrOfBytesPerBlock_);
    [self writeSingleBlockWithInt:blockAddress withByteArray:tmpBuf withByte:flag withByteArray:uid];
  }
}

IOSByteArray *ComStSt25sdkCommandVicinityMemoryCommand_readMultipleBlockWithInt_withInt_withByte_withByteArray_(ComStSt25sdkCommandVicinityMemoryCommand *self, jint blockOffset, jint nbrOfBlocks, jbyte flag, IOSByteArray *uid) {
  IOSByteArray *result;
  if ((nbrOfBlocks <= 0) || (blockOffset < 0)) {
    @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, BAD_PARAMETER));
  }
  if (blockOffset + nbrOfBlocks > (jint) 0xFFFF) {
    @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, BAD_PARAMETER));
  }
  jbyte nbrOfBlocksToRead = (jbyte) ((nbrOfBlocks - 1) & (jint) 0xFF);
  result = [((ComStSt25sdkCommandVicinityCommand *) nil_chk(self->mVicinityCommand_)) readMultipleBlockWithByteArray:ComStSt25sdkHelper_convertIntTo2BytesHexaFormatWithInt_(blockOffset) withByte:nbrOfBlocksToRead withByte:flag withByteArray:uid];
  return result;
}

J2OBJC_CLASS_TYPE_LITERAL_SOURCE(ComStSt25sdkCommandVicinityMemoryCommand)
