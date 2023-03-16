//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: st25sdk_ios/ftmprotocol/FtmCommands.java
//

#include "IOSClass.h"
#include "IOSObjectArray.h"
#include "IOSPrimitiveArray.h"
#include "J2ObjC_source.h"
#include "com/st/st25sdk/Helper.h"
#include "com/st/st25sdk/STException.h"
#include "com/st/st25sdk/STLog.h"
#include "com/st/st25sdk/command/Iso15693Protocol.h"
#include "com/st/st25sdk/ftmprotocol/FtmCommands.h"
#include "com/st/st25sdk/ftmprotocol/FtmProtocol.h"
#include "com/st/st25sdk/type5/st25dv/ST25DVTag.h"
#include "java/lang/Byte.h"
#include "java/lang/Deprecated.h"
#include "java/lang/Integer.h"
#include "java/lang/System.h"
#include "java/lang/annotation/Annotation.h"

@interface ComStSt25sdkFtmprotocolFtmCommands () {
 @public
  ComStSt25sdkFtmprotocolFtmProtocol *mFtmProtocol_;
}

@end

J2OBJC_FIELD_SETTER(ComStSt25sdkFtmprotocolFtmCommands, mFtmProtocol_, ComStSt25sdkFtmprotocolFtmProtocol *)

__attribute__((unused)) static IOSObjectArray *ComStSt25sdkFtmprotocolFtmCommands__Annotations$0(void);

@implementation ComStSt25sdkFtmprotocolFtmCommands

+ (jbyte)FTM_CMD_GET_BOARD_INFO {
  return ComStSt25sdkFtmprotocolFtmCommands_FTM_CMD_GET_BOARD_INFO;
}

+ (jbyte)FTM_CMD_SEND_PICTURE {
  return ComStSt25sdkFtmprotocolFtmCommands_FTM_CMD_SEND_PICTURE;
}

+ (jbyte)FTM_CMD_READ_PICTURE {
  return ComStSt25sdkFtmprotocolFtmCommands_FTM_CMD_READ_PICTURE;
}

+ (jbyte)FTM_CMD_STOPWATCH {
  return ComStSt25sdkFtmprotocolFtmCommands_FTM_CMD_STOPWATCH;
}

+ (jbyte)FTM_CMD_FW_UPGRADE {
  return ComStSt25sdkFtmprotocolFtmCommands_FTM_CMD_FW_UPGRADE;
}

+ (jbyte)FTM_CMD_SEND_DATA {
  return ComStSt25sdkFtmprotocolFtmCommands_FTM_CMD_SEND_DATA;
}

+ (jbyte)FTM_CMD_READ_DATA {
  return ComStSt25sdkFtmprotocolFtmCommands_FTM_CMD_READ_DATA;
}

+ (jbyte)FTM_CMD_SEND_PASSWORD {
  return ComStSt25sdkFtmprotocolFtmCommands_FTM_CMD_SEND_PASSWORD;
}

+ (jbyte)FTM_CMD_READ_PICTURE_NO_ERROR_RECOVERY {
  return ComStSt25sdkFtmprotocolFtmCommands_FTM_CMD_READ_PICTURE_NO_ERROR_RECOVERY;
}

+ (jbyte)FTM_CMD_READ_DATA_NO_ERROR_RECOVERY {
  return ComStSt25sdkFtmprotocolFtmCommands_FTM_CMD_READ_DATA_NO_ERROR_RECOVERY;
}

+ (jbyte)NO_ACK_REQUESTED {
  return ComStSt25sdkFtmprotocolFtmCommands_NO_ACK_REQUESTED;
}

+ (jbyte)ACK_REQUESTED {
  return ComStSt25sdkFtmprotocolFtmCommands_ACK_REQUESTED;
}

+ (jbyte)CMD_OK {
  return ComStSt25sdkFtmprotocolFtmCommands_CMD_OK;
}

+ (jbyte)CMD_ERROR {
  return ComStSt25sdkFtmprotocolFtmCommands_CMD_ERROR;
}

+ (jbyte)CMD_INTERNAL_ERROR {
  return ComStSt25sdkFtmprotocolFtmCommands_CMD_INTERNAL_ERROR;
}

+ (jbyte)CMD_UNKNOWN {
  return ComStSt25sdkFtmprotocolFtmCommands_CMD_UNKNOWN;
}

+ (jbyte)CMD_NOT_ALLOWED {
  return ComStSt25sdkFtmprotocolFtmCommands_CMD_NOT_ALLOWED;
}

+ (jint)DEFAULT_FTM_TIME_OUT_IN_MS {
  return ComStSt25sdkFtmprotocolFtmCommands_DEFAULT_FTM_TIME_OUT_IN_MS;
}

+ (jint)SHORT_FTM_TIME_OUT_IN_MS {
  return ComStSt25sdkFtmprotocolFtmCommands_SHORT_FTM_TIME_OUT_IN_MS;
}

- (instancetype)initWithComStSt25sdkType5St25dvST25DVTag:(ComStSt25sdkType5St25dvST25DVTag *)st25DVTag {
  ComStSt25sdkFtmprotocolFtmCommands_initWithComStSt25sdkType5St25dvST25DVTag_(self, st25DVTag);
  return self;
}

- (void)java_finalize {
  [super java_finalize];
  [((ComStSt25sdkFtmprotocolFtmProtocol *) nil_chk(mFtmProtocol_)) stopFtmThread];
}

- (void)setTagWithComStSt25sdkType5St25dvST25DVTag:(ComStSt25sdkType5St25dvST25DVTag *)st25DVTag {
  [((ComStSt25sdkFtmprotocolFtmProtocol *) nil_chk(mFtmProtocol_)) setTagWithComStSt25sdkType5St25dvST25DVTag:st25DVTag];
}

- (void)sendCmdWithByte:(jbyte)cmdId
          withByteArray:(IOSByteArray *)data
            withBoolean:(jboolean)isErrorControlNeeded
            withBoolean:(jboolean)isResponseExpected
withComStSt25sdkFtmprotocolFtmProtocol_TransferProgressionListener:(id<ComStSt25sdkFtmprotocolFtmProtocol_TransferProgressionListener>)transferProgressionListener
withComStSt25sdkFtmprotocolFtmProtocol_TransferCompletionListener:(id<ComStSt25sdkFtmprotocolFtmProtocol_TransferCompletionListener>)transferCompletionListener
                withInt:(jint)timeOutInMs {
  jbyte flag = ComStSt25sdkCommandIso15693Protocol_HIGH_DATA_RATE_MODE;
  [self sendCmdWithByte:cmdId withByteArray:data withBoolean:isErrorControlNeeded withBoolean:isResponseExpected withComStSt25sdkFtmprotocolFtmProtocol_TransferProgressionListener:transferProgressionListener withComStSt25sdkFtmprotocolFtmProtocol_TransferCompletionListener:transferCompletionListener withInt:timeOutInMs withByte:flag];
}

- (void)sendCmdWithByte:(jbyte)cmdId
          withByteArray:(IOSByteArray *)data
            withBoolean:(jboolean)isErrorControlNeeded
            withBoolean:(jboolean)isResponseExpected
withComStSt25sdkFtmprotocolFtmProtocol_TransferProgressionListener:(id<ComStSt25sdkFtmprotocolFtmProtocol_TransferProgressionListener>)transferProgressionListener
withComStSt25sdkFtmprotocolFtmProtocol_TransferCompletionListener:(id<ComStSt25sdkFtmprotocolFtmProtocol_TransferCompletionListener>)transferCompletionListener
                withInt:(jint)timeOutInMs
               withByte:(jbyte)flag {
  IOSByteArray *dataToSend;
  if (data == nil) {
    dataToSend = [IOSByteArray newArrayWithBytes:(jbyte[]){ cmdId } count:1];
  }
  else {
    dataToSend = ComStSt25sdkHelper_concatenateByteArraysWithByte_withByteArray_(cmdId, data);
  }
  ComStSt25sdkSTLog_wWithNSString_(NSString_java_formatWithNSString_withNSObjectArray_(@"*** Send FTM command 0x%02x (Data length: %d bytes)", [IOSObjectArray newArrayWithObjects:(id[]){ JavaLangByte_valueOfWithByte_(cmdId), JavaLangInteger_valueOfWithInt_(data == nil ? 0 : data->size_) } count:2 type:NSObject_class_()]));
  [((ComStSt25sdkFtmprotocolFtmProtocol *) nil_chk(mFtmProtocol_)) sendFtmDataWithByteArray:dataToSend withBoolean:isErrorControlNeeded withBoolean:isResponseExpected withComStSt25sdkFtmprotocolFtmProtocol_TransferProgressionListener:transferProgressionListener withComStSt25sdkFtmprotocolFtmProtocol_TransferCompletionListener:transferCompletionListener withInt:timeOutInMs withByte:flag];
}

- (IOSByteArray *)sendCmdAndWaitForCompletionWithByte:(jbyte)cmdId
                                        withByteArray:(IOSByteArray *)data
                                          withBoolean:(jboolean)isErrorControlNeeded
                                          withBoolean:(jboolean)isResponseExpected
withComStSt25sdkFtmprotocolFtmProtocol_TransferProgressionListener:(id<ComStSt25sdkFtmprotocolFtmProtocol_TransferProgressionListener>)transferProgressionListener
                                              withInt:(jint)timeOutInMs {
  jbyte flag = ComStSt25sdkCommandIso15693Protocol_HIGH_DATA_RATE_MODE;
  return [self sendCmdAndWaitForCompletionWithByte:cmdId withByteArray:data withBoolean:isErrorControlNeeded withBoolean:isResponseExpected withComStSt25sdkFtmprotocolFtmProtocol_TransferProgressionListener:transferProgressionListener withInt:timeOutInMs withByte:flag];
}

- (IOSByteArray *)sendCmdAndWaitForCompletionWithByte:(jbyte)cmdId
                                        withByteArray:(IOSByteArray *)data
                                          withBoolean:(jboolean)isErrorControlNeeded
                                          withBoolean:(jboolean)isResponseExpected
withComStSt25sdkFtmprotocolFtmProtocol_TransferProgressionListener:(id<ComStSt25sdkFtmprotocolFtmProtocol_TransferProgressionListener>)transferProgressionListener
                                              withInt:(jint)timeOutInMs
                                             withByte:(jbyte)flag {
  IOSByteArray *dataToSend;
  IOSByteArray *receivedData = nil;
  if (data == nil) {
    dataToSend = [IOSByteArray newArrayWithBytes:(jbyte[]){ cmdId } count:1];
  }
  else {
    dataToSend = ComStSt25sdkHelper_concatenateByteArraysWithByte_withByteArray_(cmdId, data);
  }
  ComStSt25sdkSTLog_wWithNSString_(NSString_java_formatWithNSString_withNSObjectArray_(@"*** Send FTM command 0x%02x (Data length: %d bytes)", [IOSObjectArray newArrayWithObjects:(id[]){ JavaLangByte_valueOfWithByte_(cmdId), JavaLangInteger_valueOfWithInt_(data == nil ? 0 : data->size_) } count:2 type:NSObject_class_()]));
  IOSByteArray *received = [((ComStSt25sdkFtmprotocolFtmProtocol *) nil_chk(mFtmProtocol_)) sendFtmDataAndWaitForCompletionWithByteArray:dataToSend withBoolean:isErrorControlNeeded withBoolean:isResponseExpected withComStSt25sdkFtmprotocolFtmProtocol_TransferProgressionListener:transferProgressionListener withInt:timeOutInMs withByte:flag];
  if (isResponseExpected) {
    if (received == nil) {
      @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, RFREADER_NO_RESPONSE));
    }
    if (received->size_ < 2) {
      @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, CMD_FAILED));
    }
    jbyte expectedCmdAck = (jbyte) ((cmdId | (jint) 0x80) & (jint) 0xFF);
    if (JavaLangByte_compareWithByte_withByte_(IOSByteArray_Get(received, 0), expectedCmdAck) != 0) {
      ComStSt25sdkSTLog_eWithNSString_(NSString_java_formatWithNSString_withNSObjectArray_(@"The response doesn't correspond to the command sent (0x%02x)", [IOSObjectArray newArrayWithObjects:(id[]){ JavaLangByte_valueOfWithByte_(IOSByteArray_Get(received, 0)) } count:1 type:NSObject_class_()]));
      @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, CMD_FAILED));
    }
    if (JavaLangByte_compareWithByte_withByte_(IOSByteArray_Get(received, 1), ComStSt25sdkFtmprotocolFtmCommands_CMD_OK) != 0) {
      ComStSt25sdkSTLog_eWithNSString_(NSString_java_formatWithNSString_withNSObjectArray_(@"Command failed: status = 0x%02x", [IOSObjectArray newArrayWithObjects:(id[]){ JavaLangByte_valueOfWithByte_(IOSByteArray_Get(received, 1)) } count:1 type:NSObject_class_()]));
      @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, CMD_FAILED));
    }
    if (received->size_ > 2) {
      receivedData = [IOSByteArray newArrayWithLength:received->size_ - 2];
      JavaLangSystem_arraycopyWithId_withInt_withId_withInt_withInt_(received, 2, receivedData, 0, receivedData->size_);
    }
  }
  return receivedData;
}

- (void)cancelCurrentTransfer {
  [((ComStSt25sdkFtmprotocolFtmProtocol *) nil_chk(mFtmProtocol_)) cancelCurrentTransfer];
}

- (void)pauseCurrentTransfer {
  [((ComStSt25sdkFtmprotocolFtmProtocol *) nil_chk(mFtmProtocol_)) pauseCurrentTransfer];
}

- (void)resumeCurrentTransfer {
  [((ComStSt25sdkFtmprotocolFtmProtocol *) nil_chk(mFtmProtocol_)) resumeCurrentTransfer];
}

- (jboolean)getFastCommandsUsage {
  return [((ComStSt25sdkFtmprotocolFtmProtocol *) nil_chk(mFtmProtocol_)) getFastCommandsUsage];
}

- (void)setFastCommandUsageWithBoolean:(jboolean)useFastCommands {
  [((ComStSt25sdkFtmprotocolFtmProtocol *) nil_chk(mFtmProtocol_)) setFastCommandUsageWithBoolean:useFastCommands];
}

- (void)setSegmentLengthWithInt:(jint)nbrOfPacketsPerSegment {
  [((ComStSt25sdkFtmprotocolFtmProtocol *) nil_chk(mFtmProtocol_)) setSegmentLengthWithInt:nbrOfPacketsPerSegment];
}

- (void)setNbrOfRetriesInCaseOfErrorWithInt:(jint)nbrOfRetriesInCaseOfError {
  [((ComStSt25sdkFtmprotocolFtmProtocol *) nil_chk(mFtmProtocol_)) setNbrOfRetriesInCaseOfErrorWithInt:nbrOfRetriesInCaseOfError];
}

- (void)setMinTimeInMsWhenWaitingAckWithLong:(jlong)minTimeInMsWhenWaitingAck {
  [((ComStSt25sdkFtmprotocolFtmProtocol *) nil_chk(mFtmProtocol_)) setMinTimeInMsWhenWaitingAckWithLong:minTimeInMsWhenWaitingAck];
}

- (void)setMinTimeInMsBetweenConsecutiveCmdsWithLong:(jlong)timeInMs {
  [((ComStSt25sdkFtmprotocolFtmProtocol *) nil_chk(mFtmProtocol_)) setMinTimeInMsBetweenSendCmdsWithLong:timeInMs];
  [((ComStSt25sdkFtmprotocolFtmProtocol *) nil_chk(mFtmProtocol_)) setMinTimeInMsBetweenReceiveCmdsWithLong:timeInMs];
}

- (void)setMinTimeInMsBetweenSendCmdsWithLong:(jlong)timeInMs {
  [((ComStSt25sdkFtmprotocolFtmProtocol *) nil_chk(mFtmProtocol_)) setMinTimeInMsBetweenSendCmdsWithLong:timeInMs];
}

- (void)setMinTimeInMsBetweenReceiveCmdsWithLong:(jlong)timeInMs {
  [((ComStSt25sdkFtmprotocolFtmProtocol *) nil_chk(mFtmProtocol_)) setMinTimeInMsBetweenReceiveCmdsWithLong:timeInMs];
}

- (void)dealloc {
  JreCheckFinalize(self, [ComStSt25sdkFtmprotocolFtmCommands class]);
}

+ (const J2ObjcClassInfo *)__metadata {
  static J2ObjcMethodInfo methods[] = {
    { NULL, NULL, 0x1, -1, 0, -1, -1, -1, -1 },
    { NULL, "V", 0x4, 1, -1, 2, -1, -1, -1 },
    { NULL, "V", 0x1, 3, 0, -1, -1, -1, -1 },
    { NULL, "V", 0x1, 4, 5, 6, -1, -1, -1 },
    { NULL, "V", 0x1, 4, 7, 6, -1, -1, -1 },
    { NULL, "[B", 0x1, 8, 9, 10, -1, -1, -1 },
    { NULL, "[B", 0x1, 8, 11, 10, -1, -1, -1 },
    { NULL, "V", 0x1, -1, -1, -1, -1, -1, -1 },
    { NULL, "V", 0x1, -1, -1, -1, -1, -1, -1 },
    { NULL, "V", 0x1, -1, -1, -1, -1, -1, -1 },
    { NULL, "Z", 0x1, -1, -1, -1, -1, -1, -1 },
    { NULL, "V", 0x1, 12, 13, -1, -1, -1, -1 },
    { NULL, "V", 0x1, 14, 15, 6, -1, -1, -1 },
    { NULL, "V", 0x1, 16, 15, -1, -1, -1, -1 },
    { NULL, "V", 0x1, 17, 18, -1, -1, -1, -1 },
    { NULL, "V", 0x1, 19, 18, -1, -1, 20, -1 },
    { NULL, "V", 0x1, 21, 18, -1, -1, -1, -1 },
    { NULL, "V", 0x1, 22, 18, -1, -1, -1, -1 },
  };
  #pragma clang diagnostic push
  #pragma clang diagnostic ignored "-Wobjc-multiple-method-names"
  #pragma clang diagnostic ignored "-Wundeclared-selector"
  methods[0].selector = @selector(initWithComStSt25sdkType5St25dvST25DVTag:);
  methods[1].selector = @selector(java_finalize);
  methods[2].selector = @selector(setTagWithComStSt25sdkType5St25dvST25DVTag:);
  methods[3].selector = @selector(sendCmdWithByte:withByteArray:withBoolean:withBoolean:withComStSt25sdkFtmprotocolFtmProtocol_TransferProgressionListener:withComStSt25sdkFtmprotocolFtmProtocol_TransferCompletionListener:withInt:);
  methods[4].selector = @selector(sendCmdWithByte:withByteArray:withBoolean:withBoolean:withComStSt25sdkFtmprotocolFtmProtocol_TransferProgressionListener:withComStSt25sdkFtmprotocolFtmProtocol_TransferCompletionListener:withInt:withByte:);
  methods[5].selector = @selector(sendCmdAndWaitForCompletionWithByte:withByteArray:withBoolean:withBoolean:withComStSt25sdkFtmprotocolFtmProtocol_TransferProgressionListener:withInt:);
  methods[6].selector = @selector(sendCmdAndWaitForCompletionWithByte:withByteArray:withBoolean:withBoolean:withComStSt25sdkFtmprotocolFtmProtocol_TransferProgressionListener:withInt:withByte:);
  methods[7].selector = @selector(cancelCurrentTransfer);
  methods[8].selector = @selector(pauseCurrentTransfer);
  methods[9].selector = @selector(resumeCurrentTransfer);
  methods[10].selector = @selector(getFastCommandsUsage);
  methods[11].selector = @selector(setFastCommandUsageWithBoolean:);
  methods[12].selector = @selector(setSegmentLengthWithInt:);
  methods[13].selector = @selector(setNbrOfRetriesInCaseOfErrorWithInt:);
  methods[14].selector = @selector(setMinTimeInMsWhenWaitingAckWithLong:);
  methods[15].selector = @selector(setMinTimeInMsBetweenConsecutiveCmdsWithLong:);
  methods[16].selector = @selector(setMinTimeInMsBetweenSendCmdsWithLong:);
  methods[17].selector = @selector(setMinTimeInMsBetweenReceiveCmdsWithLong:);
  #pragma clang diagnostic pop
  static const J2ObjcFieldInfo fields[] = {
    { "mFtmProtocol_", "LComStSt25sdkFtmprotocolFtmProtocol;", .constantValue.asLong = 0, 0x2, -1, -1, -1, -1 },
    { "FTM_CMD_GET_BOARD_INFO", "B", .constantValue.asChar = ComStSt25sdkFtmprotocolFtmCommands_FTM_CMD_GET_BOARD_INFO, 0x19, -1, -1, -1, -1 },
    { "FTM_CMD_SEND_PICTURE", "B", .constantValue.asChar = ComStSt25sdkFtmprotocolFtmCommands_FTM_CMD_SEND_PICTURE, 0x19, -1, -1, -1, -1 },
    { "FTM_CMD_READ_PICTURE", "B", .constantValue.asChar = ComStSt25sdkFtmprotocolFtmCommands_FTM_CMD_READ_PICTURE, 0x19, -1, -1, -1, -1 },
    { "FTM_CMD_STOPWATCH", "B", .constantValue.asChar = ComStSt25sdkFtmprotocolFtmCommands_FTM_CMD_STOPWATCH, 0x19, -1, -1, -1, -1 },
    { "FTM_CMD_FW_UPGRADE", "B", .constantValue.asChar = ComStSt25sdkFtmprotocolFtmCommands_FTM_CMD_FW_UPGRADE, 0x19, -1, -1, -1, -1 },
    { "FTM_CMD_SEND_DATA", "B", .constantValue.asChar = ComStSt25sdkFtmprotocolFtmCommands_FTM_CMD_SEND_DATA, 0x19, -1, -1, -1, -1 },
    { "FTM_CMD_READ_DATA", "B", .constantValue.asChar = ComStSt25sdkFtmprotocolFtmCommands_FTM_CMD_READ_DATA, 0x19, -1, -1, -1, -1 },
    { "FTM_CMD_SEND_PASSWORD", "B", .constantValue.asChar = ComStSt25sdkFtmprotocolFtmCommands_FTM_CMD_SEND_PASSWORD, 0x19, -1, -1, -1, -1 },
    { "FTM_CMD_READ_PICTURE_NO_ERROR_RECOVERY", "B", .constantValue.asChar = ComStSt25sdkFtmprotocolFtmCommands_FTM_CMD_READ_PICTURE_NO_ERROR_RECOVERY, 0x19, -1, -1, -1, -1 },
    { "FTM_CMD_READ_DATA_NO_ERROR_RECOVERY", "B", .constantValue.asChar = ComStSt25sdkFtmprotocolFtmCommands_FTM_CMD_READ_DATA_NO_ERROR_RECOVERY, 0x19, -1, -1, -1, -1 },
    { "NO_ACK_REQUESTED", "B", .constantValue.asChar = ComStSt25sdkFtmprotocolFtmCommands_NO_ACK_REQUESTED, 0x19, -1, -1, -1, -1 },
    { "ACK_REQUESTED", "B", .constantValue.asChar = ComStSt25sdkFtmprotocolFtmCommands_ACK_REQUESTED, 0x19, -1, -1, -1, -1 },
    { "CMD_OK", "B", .constantValue.asChar = ComStSt25sdkFtmprotocolFtmCommands_CMD_OK, 0x19, -1, -1, -1, -1 },
    { "CMD_ERROR", "B", .constantValue.asChar = ComStSt25sdkFtmprotocolFtmCommands_CMD_ERROR, 0x19, -1, -1, -1, -1 },
    { "CMD_INTERNAL_ERROR", "B", .constantValue.asChar = ComStSt25sdkFtmprotocolFtmCommands_CMD_INTERNAL_ERROR, 0x19, -1, -1, -1, -1 },
    { "CMD_UNKNOWN", "B", .constantValue.asChar = ComStSt25sdkFtmprotocolFtmCommands_CMD_UNKNOWN, 0x19, -1, -1, -1, -1 },
    { "CMD_NOT_ALLOWED", "B", .constantValue.asChar = ComStSt25sdkFtmprotocolFtmCommands_CMD_NOT_ALLOWED, 0x19, -1, -1, -1, -1 },
    { "DEFAULT_FTM_TIME_OUT_IN_MS", "I", .constantValue.asInt = ComStSt25sdkFtmprotocolFtmCommands_DEFAULT_FTM_TIME_OUT_IN_MS, 0x19, -1, -1, -1, -1 },
    { "SHORT_FTM_TIME_OUT_IN_MS", "I", .constantValue.asInt = ComStSt25sdkFtmprotocolFtmCommands_SHORT_FTM_TIME_OUT_IN_MS, 0x19, -1, -1, -1, -1 },
  };
  static const void *ptrTable[] = { "LComStSt25sdkType5St25dvST25DVTag;", "finalize", "LJavaLangThrowable;", "setTag", "sendCmd", "B[BZZLComStSt25sdkFtmprotocolFtmProtocol_TransferProgressionListener;LComStSt25sdkFtmprotocolFtmProtocol_TransferCompletionListener;I", "LComStSt25sdkSTException;", "B[BZZLComStSt25sdkFtmprotocolFtmProtocol_TransferProgressionListener;LComStSt25sdkFtmprotocolFtmProtocol_TransferCompletionListener;IB", "sendCmdAndWaitForCompletion", "B[BZZLComStSt25sdkFtmprotocolFtmProtocol_TransferProgressionListener;I", "LComStSt25sdkSTException;LJavaLangInterruptedException;", "B[BZZLComStSt25sdkFtmprotocolFtmProtocol_TransferProgressionListener;IB", "setFastCommandUsage", "Z", "setSegmentLength", "I", "setNbrOfRetriesInCaseOfError", "setMinTimeInMsWhenWaitingAck", "J", "setMinTimeInMsBetweenConsecutiveCmds", (void *)&ComStSt25sdkFtmprotocolFtmCommands__Annotations$0, "setMinTimeInMsBetweenSendCmds", "setMinTimeInMsBetweenReceiveCmds" };
  static const J2ObjcClassInfo _ComStSt25sdkFtmprotocolFtmCommands = { "FtmCommands", "com.st.st25sdk.ftmprotocol", ptrTable, methods, fields, 7, 0x1, 18, 20, -1, -1, -1, -1, -1 };
  return &_ComStSt25sdkFtmprotocolFtmCommands;
}

@end

void ComStSt25sdkFtmprotocolFtmCommands_initWithComStSt25sdkType5St25dvST25DVTag_(ComStSt25sdkFtmprotocolFtmCommands *self, ComStSt25sdkType5St25dvST25DVTag *st25DVTag) {
  NSObject_init(self);
  self->mFtmProtocol_ = new_ComStSt25sdkFtmprotocolFtmProtocol_initWithComStSt25sdkType5St25dvST25DVTag_(st25DVTag);
}

ComStSt25sdkFtmprotocolFtmCommands *new_ComStSt25sdkFtmprotocolFtmCommands_initWithComStSt25sdkType5St25dvST25DVTag_(ComStSt25sdkType5St25dvST25DVTag *st25DVTag) {
  J2OBJC_NEW_IMPL(ComStSt25sdkFtmprotocolFtmCommands, initWithComStSt25sdkType5St25dvST25DVTag_, st25DVTag)
}

ComStSt25sdkFtmprotocolFtmCommands *create_ComStSt25sdkFtmprotocolFtmCommands_initWithComStSt25sdkType5St25dvST25DVTag_(ComStSt25sdkType5St25dvST25DVTag *st25DVTag) {
  J2OBJC_CREATE_IMPL(ComStSt25sdkFtmprotocolFtmCommands, initWithComStSt25sdkType5St25dvST25DVTag_, st25DVTag)
}

IOSObjectArray *ComStSt25sdkFtmprotocolFtmCommands__Annotations$0() {
  return [IOSObjectArray newArrayWithObjects:(id[]){ create_JavaLangDeprecated() } count:1 type:JavaLangAnnotationAnnotation_class_()];
}

J2OBJC_CLASS_TYPE_LITERAL_SOURCE(ComStSt25sdkFtmprotocolFtmCommands)