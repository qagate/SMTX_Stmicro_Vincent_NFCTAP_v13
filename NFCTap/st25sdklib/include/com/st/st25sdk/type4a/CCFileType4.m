//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: st25sdk_ios/type4a/CCFileType4.java
//

#include "IOSPrimitiveArray.h"
#include "J2ObjC_source.h"
#include "com/st/st25sdk/Helper.h"
#include "com/st/st25sdk/STException.h"
#include "com/st/st25sdk/command/Type4Command.h"
#include "com/st/st25sdk/type4a/CCFileType4.h"
#include "com/st/st25sdk/type4a/FileControlTlvType4.h"
#include "com/st/st25sdk/type4a/FileType4.h"
#include "com/st/st25sdk/type4a/Type4Tag.h"
#include "java/lang/Exception.h"
#include "java/nio/ByteBuffer.h"
#include "java/util/ArrayList.h"
#include "java/util/Arrays.h"
#include "java/util/List.h"

@interface ComStSt25sdkType4aCCFileType4 ()

- (void)checkCache;

@end

__attribute__((unused)) static void ComStSt25sdkType4aCCFileType4_checkCache(ComStSt25sdkType4aCCFileType4 *self);

@implementation ComStSt25sdkType4aCCFileType4

- (instancetype)initWithComStSt25sdkCommandType4Command:(ComStSt25sdkCommandType4Command *)type4Command {
  ComStSt25sdkType4aCCFileType4_initWithComStSt25sdkCommandType4Command_(self, type4Command);
  return self;
}

- (jint)readLength {
  if (!mCacheActivated_ || mCacheInvalidated_) {
    mLength_ = 0;
    IOSByteArray *buffer;
    jbyte length = (jbyte) (jint) 0x02;
    @synchronized(JreLoadStatic(ComStSt25sdkCommandType4Command, mLock)) {
      (void) [self select];
      buffer = [((ComStSt25sdkCommandType4Command *) nil_chk(mType4Command_)) readBinaryWithByte:(jbyte) (jint) 0x00 withByte:(jbyte) (jint) 0x00 withByte:length];
    }
    if (IOSByteArray_Get(nil_chk(buffer), 0) == (jbyte) (jint) 0x00) {
      mLength_ = (JreLShift32(ComStSt25sdkHelper_convertByteToUnsignedIntWithByte_(IOSByteArray_Get(buffer, 0)), 8)) + ComStSt25sdkHelper_convertByteToUnsignedIntWithByte_(IOSByteArray_Get(buffer, 1));
    }
  }
  return mLength_;
}

- (IOSByteArray *)read {
  if (!mCacheActivated_ || mCacheInvalidated_) {
    IOSByteArray *buffer = nil;
    @try {
      jint sizeInBytes;
      @synchronized(JreLoadStatic(ComStSt25sdkCommandType4Command, mLock)) {
        sizeInBytes = [self readLength];
        if (sizeInBytes > 0) buffer = [((ComStSt25sdkCommandType4Command *) nil_chk(mType4Command_)) readDataWithInt:0 withInt:sizeInBytes];
      }
      if (buffer != nil) return JavaUtilArrays_copyOfRangeWithByteArray_withInt_withInt_(buffer, 0, buffer->size_);
      else return nil;
    }
    @catch (JavaLangException *e) {
      [e printStackTrace];
      @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, CMD_FAILED));
    }
  }
  return mBuffer_;
}

- (void)parseCCFileWithByteArray:(IOSByteArray *)buffer {
  JavaNioByteBuffer *byteBuffer = JavaNioByteBuffer_wrapWithByteArray_(buffer);
  mLength_ = (JreLShift32(ComStSt25sdkHelper_convertByteToUnsignedIntWithByte_([((JavaNioByteBuffer *) nil_chk(byteBuffer)) get]), 8));
  mLength_ += ComStSt25sdkHelper_convertByteToUnsignedIntWithByte_([byteBuffer get]);
  mMappingVersion_ = [byteBuffer get];
  mMaxReadSize_ = (JreLShift32(ComStSt25sdkHelper_convertByteToUnsignedIntWithByte_([byteBuffer get]), 8));
  mMaxReadSize_ += ComStSt25sdkHelper_convertByteToUnsignedIntWithByte_([byteBuffer get]);
  mMaxWriteSize_ = (JreLShift32(ComStSt25sdkHelper_convertByteToUnsignedIntWithByte_([byteBuffer get]), 8));
  mMaxWriteSize_ += ComStSt25sdkHelper_convertByteToUnsignedIntWithByte_([byteBuffer get]);
  if (mTlv_ == nil) {
    mTlv_ = new_JavaUtilArrayList_init();
  }
  [mTlv_ clear];
  IOSByteArray *tlv = [IOSByteArray newArrayWithLength:8];
  while ([byteBuffer limit] - [byteBuffer position] > 7) {
    (void) [byteBuffer getWithByteArray:tlv withInt:0 withInt:8];
    [((id<JavaUtilList>) nil_chk(mTlv_)) addWithId:ComStSt25sdkType4aFileControlTlvType4_newInstanceWithByteArray_(tlv)];
  }
  mBuffer_ = [byteBuffer array];
  mLength_ = ((IOSByteArray *) nil_chk(mBuffer_))->size_;
}

- (jbyte)getCCMappingVersion {
  ComStSt25sdkType4aCCFileType4_checkCache(self);
  return mMappingVersion_;
}

- (jint)getMaxReadSize {
  ComStSt25sdkType4aCCFileType4_checkCache(self);
  return mMaxReadSize_;
}

- (jint)getMaxWriteSize {
  ComStSt25sdkType4aCCFileType4_checkCache(self);
  return mMaxWriteSize_;
}

- (ComStSt25sdkType4aFileControlTlvType4 *)getTlvWithInt:(jint)pos {
  ComStSt25sdkType4aCCFileType4_checkCache(self);
  if (pos >= [((id<JavaUtilList>) nil_chk(mTlv_)) size]) {
    @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, BAD_PARAMETER));
  }
  return [((id<JavaUtilList>) nil_chk(mTlv_)) getWithInt:pos];
}

- (ComStSt25sdkType4aFileControlTlvType4 *)getFileTlvWithInt:(jint)fileId {
  jint nbrOfTlv = [self getNbOfTlv];
  for (jint i = 0; i < nbrOfTlv; i++) {
    ComStSt25sdkType4aFileControlTlvType4 *fileTlv = [((id<JavaUtilList>) nil_chk(mTlv_)) getWithInt:i];
    if ([((ComStSt25sdkType4aFileControlTlvType4 *) nil_chk(fileTlv)) getFileId] == fileId) {
      return fileTlv;
    }
  }
  @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, INVALID_CCFILE));
}

- (jint)getNbOfTlv {
  ComStSt25sdkType4aCCFileType4_checkCache(self);
  return [((id<JavaUtilList>) nil_chk(mTlv_)) size];
}

- (jint)getNdefFileId {
  ComStSt25sdkType4aCCFileType4_checkCache(self);
  if ([((id<JavaUtilList>) nil_chk(mTlv_)) size] <= 0) {
    @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, INVALID_CCFILE));
  }
  return [((ComStSt25sdkType4aFileControlTlvType4 *) nil_chk([self getTlvWithInt:0])) getFileId];
}

- (void)invalidateCache {
  mCacheInvalidated_ = true;
}

- (void)validateCache {
  mCacheInvalidated_ = false;
}

- (void)activateCache {
  mCacheActivated_ = true;
  mCacheInvalidated_ = true;
}

- (void)deactivateCache {
  mCacheActivated_ = false;
}

- (void)updateCache {
  if ([self isCacheActivated]) {
    [self invalidateCache];
    IOSByteArray *buffer = [self read];
    if (buffer != nil) {
      [self parseCCFileWithByteArray:buffer];
      mCacheInvalidated_ = false;
    }
  }
}

- (jboolean)isCacheValid {
  return !mCacheInvalidated_;
}

- (jboolean)isCacheActivated {
  return mCacheActivated_;
}

- (void)checkCache {
  ComStSt25sdkType4aCCFileType4_checkCache(self);
}

+ (const J2ObjcClassInfo *)__metadata {
  static J2ObjcMethodInfo methods[] = {
    { NULL, NULL, 0x1, -1, 0, -1, -1, -1, -1 },
    { NULL, "I", 0x1, -1, -1, 1, -1, -1, -1 },
    { NULL, "[B", 0x1, -1, -1, 1, -1, -1, -1 },
    { NULL, "V", 0x4, 2, 3, -1, -1, -1, -1 },
    { NULL, "B", 0x1, -1, -1, 1, -1, -1, -1 },
    { NULL, "I", 0x1, -1, -1, 1, -1, -1, -1 },
    { NULL, "I", 0x1, -1, -1, 1, -1, -1, -1 },
    { NULL, "LComStSt25sdkType4aFileControlTlvType4;", 0x1, 4, 5, 1, -1, -1, -1 },
    { NULL, "LComStSt25sdkType4aFileControlTlvType4;", 0x1, 6, 5, 1, -1, -1, -1 },
    { NULL, "I", 0x1, -1, -1, 1, -1, -1, -1 },
    { NULL, "I", 0x1, -1, -1, 1, -1, -1, -1 },
    { NULL, "V", 0x1, -1, -1, -1, -1, -1, -1 },
    { NULL, "V", 0x1, -1, -1, -1, -1, -1, -1 },
    { NULL, "V", 0x1, -1, -1, -1, -1, -1, -1 },
    { NULL, "V", 0x1, -1, -1, -1, -1, -1, -1 },
    { NULL, "V", 0x1, -1, -1, 1, -1, -1, -1 },
    { NULL, "Z", 0x1, -1, -1, -1, -1, -1, -1 },
    { NULL, "Z", 0x1, -1, -1, -1, -1, -1, -1 },
    { NULL, "V", 0x2, -1, -1, 1, -1, -1, -1 },
  };
  #pragma clang diagnostic push
  #pragma clang diagnostic ignored "-Wobjc-multiple-method-names"
  #pragma clang diagnostic ignored "-Wundeclared-selector"
  methods[0].selector = @selector(initWithComStSt25sdkCommandType4Command:);
  methods[1].selector = @selector(readLength);
  methods[2].selector = @selector(read);
  methods[3].selector = @selector(parseCCFileWithByteArray:);
  methods[4].selector = @selector(getCCMappingVersion);
  methods[5].selector = @selector(getMaxReadSize);
  methods[6].selector = @selector(getMaxWriteSize);
  methods[7].selector = @selector(getTlvWithInt:);
  methods[8].selector = @selector(getFileTlvWithInt:);
  methods[9].selector = @selector(getNbOfTlv);
  methods[10].selector = @selector(getNdefFileId);
  methods[11].selector = @selector(invalidateCache);
  methods[12].selector = @selector(validateCache);
  methods[13].selector = @selector(activateCache);
  methods[14].selector = @selector(deactivateCache);
  methods[15].selector = @selector(updateCache);
  methods[16].selector = @selector(isCacheValid);
  methods[17].selector = @selector(isCacheActivated);
  methods[18].selector = @selector(checkCache);
  #pragma clang diagnostic pop
  static const J2ObjcFieldInfo fields[] = {
    { "mLength_", "I", .constantValue.asLong = 0, 0x4, -1, -1, -1, -1 },
    { "mMappingVersion_", "B", .constantValue.asLong = 0, 0x4, -1, -1, -1, -1 },
    { "mMaxReadSize_", "I", .constantValue.asLong = 0, 0x4, -1, -1, -1, -1 },
    { "mMaxWriteSize_", "I", .constantValue.asLong = 0, 0x4, -1, -1, -1, -1 },
    { "mTlv_", "LJavaUtilList;", .constantValue.asLong = 0, 0x4, -1, -1, 7, -1 },
    { "mBuffer_", "[B", .constantValue.asLong = 0, 0x4, -1, -1, -1, -1 },
    { "mCacheActivated_", "Z", .constantValue.asLong = 0, 0x4, -1, -1, -1, -1 },
    { "mCacheInvalidated_", "Z", .constantValue.asLong = 0, 0x4, -1, -1, -1, -1 },
  };
  static const void *ptrTable[] = { "LComStSt25sdkCommandType4Command;", "LComStSt25sdkSTException;", "parseCCFile", "[B", "getTlv", "I", "getFileTlv", "Ljava/util/List<Lcom/st/st25sdk/type4a/FileControlTlvType4;>;" };
  static const J2ObjcClassInfo _ComStSt25sdkType4aCCFileType4 = { "CCFileType4", "com.st.st25sdk.type4a", ptrTable, methods, fields, 7, 0x1, 19, 8, -1, -1, -1, -1, -1 };
  return &_ComStSt25sdkType4aCCFileType4;
}

@end

void ComStSt25sdkType4aCCFileType4_initWithComStSt25sdkCommandType4Command_(ComStSt25sdkType4aCCFileType4 *self, ComStSt25sdkCommandType4Command *type4Command) {
  ComStSt25sdkType4aFileType4_initWithComStSt25sdkCommandType4Command_withInt_(self, type4Command, ComStSt25sdkType4aType4Tag_TYPE4_CC_FILE_IDENTIFIER);
  self->mCacheActivated_ = true;
  self->mCacheInvalidated_ = true;
}

ComStSt25sdkType4aCCFileType4 *new_ComStSt25sdkType4aCCFileType4_initWithComStSt25sdkCommandType4Command_(ComStSt25sdkCommandType4Command *type4Command) {
  J2OBJC_NEW_IMPL(ComStSt25sdkType4aCCFileType4, initWithComStSt25sdkCommandType4Command_, type4Command)
}

ComStSt25sdkType4aCCFileType4 *create_ComStSt25sdkType4aCCFileType4_initWithComStSt25sdkCommandType4Command_(ComStSt25sdkCommandType4Command *type4Command) {
  J2OBJC_CREATE_IMPL(ComStSt25sdkType4aCCFileType4, initWithComStSt25sdkCommandType4Command_, type4Command)
}

void ComStSt25sdkType4aCCFileType4_checkCache(ComStSt25sdkType4aCCFileType4 *self) {
  if (![self isCacheActivated]) {
    IOSByteArray *buffer = [self read];
    [self parseCCFileWithByteArray:buffer];
  }
  else if (![self isCacheValid]) [self updateCache];
}

J2OBJC_CLASS_TYPE_LITERAL_SOURCE(ComStSt25sdkType4aCCFileType4)
