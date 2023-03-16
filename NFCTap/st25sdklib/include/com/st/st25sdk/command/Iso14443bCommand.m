//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: st25sdk_ios/command/Iso14443bCommand.java
//

#include "IOSObjectArray.h"
#include "IOSPrimitiveArray.h"
#include "J2ObjC_source.h"
#include "com/st/st25sdk/Helper.h"
#include "com/st/st25sdk/RFReaderInterface.h"
#include "com/st/st25sdk/STException.h"
#include "com/st/st25sdk/command/Iso14443aCommand.h"
#include "com/st/st25sdk/command/Iso14443bCommand.h"
#include "java/lang/Enum.h"
#include "java/lang/Exception.h"
#include "java/lang/IllegalArgumentException.h"
#include "java/lang/System.h"
#include "java/util/ArrayList.h"
#include "java/util/Arrays.h"
#include "java/util/List.h"

__attribute__((unused)) static void ComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode_initWithNSString_withInt_(ComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode *self, NSString *__name, jint __ordinal);

__attribute__((unused)) static ComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode *new_ComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode_initWithNSString_withInt_(NSString *__name, jint __ordinal) NS_RETURNS_RETAINED;

@implementation ComStSt25sdkCommandIso14443bCommand

+ (jbyte)ISO14443B_CMD_REQB_WUPB {
  return ComStSt25sdkCommandIso14443bCommand_ISO14443B_CMD_REQB_WUPB;
}

+ (jbyte)ISO14443B_CMD_HLTB {
  return ComStSt25sdkCommandIso14443bCommand_ISO14443B_CMD_HLTB;
}

+ (jbyte)ISO14443B_CMD_SLOT_MARKER {
  return ComStSt25sdkCommandIso14443bCommand_ISO14443B_CMD_SLOT_MARKER;
}

+ (jbyte)ISO14443B_ATQB_1ST_RESPONSE_BYTE {
  return ComStSt25sdkCommandIso14443bCommand_ISO14443B_ATQB_1ST_RESPONSE_BYTE;
}

+ (jbyte)ISO14443B_CMD_ATTRIB {
  return ComStSt25sdkCommandIso14443bCommand_ISO14443B_CMD_ATTRIB;
}

+ (jbyte)ISO14443B_CMD_DESELECT {
  return ComStSt25sdkCommandIso14443bCommand_ISO14443B_CMD_DESELECT;
}

- (instancetype)initWithComStSt25sdkRFReaderInterface:(id<ComStSt25sdkRFReaderInterface>)reader {
  ComStSt25sdkCommandIso14443bCommand_initWithComStSt25sdkRFReaderInterface_(self, reader);
  return self;
}

- (IOSByteArray *)reqBWithByte:(jbyte)afi
                      withByte:(jbyte)param {
  NSString *commandName = @"reqB";
  IOSByteArray *frame;
  frame = [IOSByteArray newArrayWithLength:3];
  *IOSByteArray_GetRef(frame, 0) = ComStSt25sdkCommandIso14443bCommand_ISO14443B_CMD_REQB_WUPB;
  *IOSByteArray_GetRef(frame, 1) = afi;
  *IOSByteArray_GetRef(frame, 2) = (jbyte) (param & (jbyte) (jint) 0xF7);
  @try {
    return [((id<ComStSt25sdkRFReaderInterface>) nil_chk(mReaderInterface_)) transceiveWithId:JreLoadEnum(ComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode, ISO14443B_STANDARD_FRAME) withNSString:commandName withByteArray:frame];
  }
  @catch (JavaLangException *e) {
    [e printStackTrace];
    @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, CMD_FAILED));
  }
}

- (IOSByteArray *)wupBWithByte:(jbyte)afi
                      withByte:(jbyte)param {
  NSString *commandName = @"wupB";
  IOSByteArray *frame;
  frame = [IOSByteArray newArrayWithLength:3];
  *IOSByteArray_GetRef(frame, 0) = ComStSt25sdkCommandIso14443bCommand_ISO14443B_CMD_REQB_WUPB;
  *IOSByteArray_GetRef(frame, 1) = afi;
  *IOSByteArray_GetRef(frame, 2) = (jbyte) (param | (jbyte) (jint) 0x08);
  @try {
    return [((id<ComStSt25sdkRFReaderInterface>) nil_chk(mReaderInterface_)) transceiveWithId:JreLoadEnum(ComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode, ISO14443B_STANDARD_FRAME) withNSString:commandName withByteArray:frame];
  }
  @catch (JavaLangException *e) {
    [e printStackTrace];
    @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, CMD_FAILED));
  }
}

- (void)hltBWithByteArray:(IOSByteArray *)identifier {
  NSString *commandName = @"hltB";
  IOSByteArray *frame;
  frame = [IOSByteArray newArrayWithLength:1 + ((IOSByteArray *) nil_chk(identifier))->size_];
  *IOSByteArray_GetRef(frame, 0) = ComStSt25sdkCommandIso14443bCommand_ISO14443B_CMD_HLTB;
  JavaLangSystem_arraycopyWithId_withInt_withId_withInt_withInt_(identifier, 0, frame, 1, identifier->size_);
  @try {
    (void) [((id<ComStSt25sdkRFReaderInterface>) nil_chk(mReaderInterface_)) transceiveWithId:JreLoadEnum(ComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode, ISO14443B_STANDARD_FRAME) withNSString:commandName withByteArray:frame];
  }
  @catch (JavaLangException *e) {
    [e printStackTrace];
    @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, CMD_FAILED));
  }
}

- (IOSByteArray *)slotMarkerWithByte:(jbyte)slotNumber {
  NSString *commandName = @"slotMarker";
  IOSByteArray *frame;
  frame = [IOSByteArray newArrayWithLength:1];
  *IOSByteArray_GetRef(frame, 0) = (jbyte) (ComStSt25sdkCommandIso14443bCommand_ISO14443B_CMD_SLOT_MARKER | ((JreLShift32(slotNumber, 4)) & (jint) 0xF0));
  @try {
    return [((id<ComStSt25sdkRFReaderInterface>) nil_chk(mReaderInterface_)) transceiveWithId:JreLoadEnum(ComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode, ISO14443B_STANDARD_FRAME) withNSString:commandName withByteArray:frame];
  }
  @catch (JavaLangException *e) {
    [e printStackTrace];
    @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, CMD_FAILED));
  }
}

- (IOSByteArray *)attriBWithByteArray:(IOSByteArray *)param {
  NSString *commandName = @"attriB";
  IOSByteArray *frame;
  frame = [IOSByteArray newArrayWithLength:1 + ((IOSByteArray *) nil_chk(param))->size_];
  *IOSByteArray_GetRef(frame, 0) = ComStSt25sdkCommandIso14443bCommand_ISO14443B_CMD_ATTRIB;
  JavaLangSystem_arraycopyWithId_withInt_withId_withInt_withInt_(param, 0, frame, 1, param->size_);
  @try {
    return [((id<ComStSt25sdkRFReaderInterface>) nil_chk(mReaderInterface_)) transceiveWithId:JreLoadEnum(ComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode, ISO14443B_STANDARD_FRAME) withNSString:commandName withByteArray:frame];
  }
  @catch (JavaLangException *e) {
    [e printStackTrace];
    @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, CMD_FAILED));
  }
}

- (IOSByteArray *)deselect {
  NSString *commandName = @"deselectB";
  IOSByteArray *frame;
  frame = [IOSByteArray newArrayWithLength:1];
  *IOSByteArray_GetRef(frame, 0) = ComStSt25sdkCommandIso14443bCommand_ISO14443B_CMD_DESELECT;
  @try {
    return [((id<ComStSt25sdkRFReaderInterface>) nil_chk(mReaderInterface_)) transceiveWithId:JreLoadEnum(ComStSt25sdkCommandIso14443aCommand_iso14443aFrameMode, ISO14443A_STANDARD_FRAME) withNSString:commandName withByteArray:frame];
  }
  @catch (JavaLangException *e) {
    [e printStackTrace];
    @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, CMD_FAILED));
  }
}

- (IOSByteArray *)iso14443bSelectTagWithByteArray:(IOSByteArray *)pupi {
  IOSByteArray *attriBparam = [IOSByteArray newArrayWithLength:8];
  IOSByteArray *response = nil;
  IOSByteArray *pupiTmp = nil;
  @try {
    response = [self wupBWithByte:(jbyte) (jint) 0x00 withByte:(jbyte) (jint) 0x04];
    if (response != nil) {
      if (response->size_ > 5 && IOSByteArray_Get(response, 0) == ComStSt25sdkCommandIso14443bCommand_ISO14443B_ATQB_1ST_RESPONSE_BYTE) {
        pupiTmp = JavaUtilArrays_copyOfRangeWithByteArray_withInt_withInt_(response, 1, 5);
        if (JavaUtilArrays_equalsWithByteArray_withByteArray_(pupi, pupiTmp)) {
          JavaLangSystem_arraycopyWithId_withInt_withId_withInt_withInt_(pupi, 0, attriBparam, 0, 4);
          *IOSByteArray_GetRef(attriBparam, 4) = (jbyte) (jint) 0x00;
          *IOSByteArray_GetRef(attriBparam, 5) = (jbyte) (jint) 0x08;
          *IOSByteArray_GetRef(attriBparam, 6) = (jbyte) (jint) 0x01;
          *IOSByteArray_GetRef(attriBparam, 7) = (jbyte) (jint) 0x00;
          return [self attriBWithByteArray:attriBparam];
        }
      }
    }
  }
  @catch (ComStSt25sdkSTException *e) {
    if (([e getError] != JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, RFREADER_NO_RESPONSE)) && ([e getError] != JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, TAG_NOT_IN_THE_FIELD))) {
      @throw (e);
    }
  }
  for (jbyte slotNumber = 1; slotNumber < 16; slotNumber++) {
    @try {
      response = [self slotMarkerWithByte:slotNumber];
      if (response != nil) {
        if (response->size_ > 5 && IOSByteArray_Get(response, 0) == ComStSt25sdkCommandIso14443bCommand_ISO14443B_ATQB_1ST_RESPONSE_BYTE) {
          pupiTmp = JavaUtilArrays_copyOfRangeWithByteArray_withInt_withInt_(response, 1, 5);
          if (JavaUtilArrays_equalsWithByteArray_withByteArray_(pupi, pupiTmp)) {
            JavaLangSystem_arraycopyWithId_withInt_withId_withInt_withInt_(pupi, 0, attriBparam, 0, 4);
            *IOSByteArray_GetRef(attriBparam, 4) = (jbyte) (jint) 0x00;
            *IOSByteArray_GetRef(attriBparam, 5) = (jbyte) (jint) 0x08;
            *IOSByteArray_GetRef(attriBparam, 6) = (jbyte) (jint) 0x01;
            *IOSByteArray_GetRef(attriBparam, 7) = (jbyte) (jint) 0x00;
            return [self attriBWithByteArray:attriBparam];
          }
        }
      }
    }
    @catch (ComStSt25sdkSTException *e) {
      if (([e getError] != JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, RFREADER_NO_RESPONSE)) && ([e getError] != JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, TAG_NOT_IN_THE_FIELD))) {
        @throw (e);
      }
    }
  }
  @throw new_ComStSt25sdkSTException_initWithComStSt25sdkSTException_STExceptionCode_(JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, RFREADER_NO_RESPONSE));
}

- (id<JavaUtilList>)anticollision_iso14443b {
  id<JavaUtilList> pupiList = new_JavaUtilArrayList_init();
  IOSByteArray *response = nil;
  IOSByteArray *pupi = nil;
  @try {
    response = [self wupBWithByte:(jbyte) (jint) 0x00 withByte:(jbyte) (jint) 0x04];
    if (response != nil) {
      if (response->size_ > 5 && IOSByteArray_Get(response, 0) == ComStSt25sdkCommandIso14443bCommand_ISO14443B_ATQB_1ST_RESPONSE_BYTE) {
        pupi = JavaUtilArrays_copyOfRangeWithByteArray_withInt_withInt_(response, 1, 5);
        [pupiList addWithId:ComStSt25sdkHelper_convertByteArrayToHexStringWithByteArray_(pupi)];
      }
    }
  }
  @catch (ComStSt25sdkSTException *e) {
    if (([e getError] != JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, RFREADER_NO_RESPONSE)) && ([e getError] != JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, TAG_NOT_IN_THE_FIELD))) {
      @throw (e);
    }
  }
  for (jbyte slotNumber = 1; slotNumber < 16; slotNumber++) {
    @try {
      response = [self slotMarkerWithByte:slotNumber];
      if (response != nil) {
        if (response->size_ > 5 && IOSByteArray_Get(response, 0) == ComStSt25sdkCommandIso14443bCommand_ISO14443B_ATQB_1ST_RESPONSE_BYTE) {
          pupi = JavaUtilArrays_copyOfRangeWithByteArray_withInt_withInt_(response, 1, 5);
          [pupiList addWithId:ComStSt25sdkHelper_convertByteArrayToHexStringWithByteArray_(pupi)];
        }
      }
    }
    @catch (ComStSt25sdkSTException *e) {
      if (([e getError] != JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, RFREADER_NO_RESPONSE)) && ([e getError] != JreLoadEnum(ComStSt25sdkSTException_STExceptionCode, TAG_NOT_IN_THE_FIELD))) {
        @throw (e);
      }
    }
  }
  return pupiList;
}

+ (const J2ObjcClassInfo *)__metadata {
  static J2ObjcMethodInfo methods[] = {
    { NULL, NULL, 0x1, -1, 0, -1, -1, -1, -1 },
    { NULL, "[B", 0x1, 1, 2, 3, -1, -1, -1 },
    { NULL, "[B", 0x1, 4, 2, 3, -1, -1, -1 },
    { NULL, "V", 0x1, 5, 6, 3, -1, -1, -1 },
    { NULL, "[B", 0x1, 7, 8, 3, -1, -1, -1 },
    { NULL, "[B", 0x1, 9, 6, 3, -1, -1, -1 },
    { NULL, "[B", 0x1, -1, -1, 3, -1, -1, -1 },
    { NULL, "[B", 0x1, 10, 6, 3, -1, -1, -1 },
    { NULL, "LJavaUtilList;", 0x1, -1, -1, 3, 11, -1, -1 },
  };
  #pragma clang diagnostic push
  #pragma clang diagnostic ignored "-Wobjc-multiple-method-names"
  #pragma clang diagnostic ignored "-Wundeclared-selector"
  methods[0].selector = @selector(initWithComStSt25sdkRFReaderInterface:);
  methods[1].selector = @selector(reqBWithByte:withByte:);
  methods[2].selector = @selector(wupBWithByte:withByte:);
  methods[3].selector = @selector(hltBWithByteArray:);
  methods[4].selector = @selector(slotMarkerWithByte:);
  methods[5].selector = @selector(attriBWithByteArray:);
  methods[6].selector = @selector(deselect);
  methods[7].selector = @selector(iso14443bSelectTagWithByteArray:);
  methods[8].selector = @selector(anticollision_iso14443b);
  #pragma clang diagnostic pop
  static const J2ObjcFieldInfo fields[] = {
    { "mReaderInterface_", "LComStSt25sdkRFReaderInterface;", .constantValue.asLong = 0, 0x4, -1, -1, -1, -1 },
    { "mFrameMode_", "LComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode;", .constantValue.asLong = 0, 0x4, -1, -1, -1, -1 },
    { "ISO14443B_CMD_REQB_WUPB", "B", .constantValue.asChar = ComStSt25sdkCommandIso14443bCommand_ISO14443B_CMD_REQB_WUPB, 0x19, -1, -1, -1, -1 },
    { "ISO14443B_CMD_HLTB", "B", .constantValue.asChar = ComStSt25sdkCommandIso14443bCommand_ISO14443B_CMD_HLTB, 0x19, -1, -1, -1, -1 },
    { "ISO14443B_CMD_SLOT_MARKER", "B", .constantValue.asChar = ComStSt25sdkCommandIso14443bCommand_ISO14443B_CMD_SLOT_MARKER, 0x19, -1, -1, -1, -1 },
    { "ISO14443B_ATQB_1ST_RESPONSE_BYTE", "B", .constantValue.asChar = ComStSt25sdkCommandIso14443bCommand_ISO14443B_ATQB_1ST_RESPONSE_BYTE, 0x19, -1, -1, -1, -1 },
    { "ISO14443B_CMD_ATTRIB", "B", .constantValue.asChar = ComStSt25sdkCommandIso14443bCommand_ISO14443B_CMD_ATTRIB, 0x19, -1, -1, -1, -1 },
    { "ISO14443B_CMD_DESELECT", "B", .constantValue.asChar = ComStSt25sdkCommandIso14443bCommand_ISO14443B_CMD_DESELECT, 0x19, -1, -1, -1, -1 },
  };
  static const void *ptrTable[] = { "LComStSt25sdkRFReaderInterface;", "reqB", "BB", "LComStSt25sdkSTException;", "wupB", "hltB", "[B", "slotMarker", "B", "attriB", "iso14443bSelectTag", "()Ljava/util/List<Ljava/lang/String;>;", "LComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode;" };
  static const J2ObjcClassInfo _ComStSt25sdkCommandIso14443bCommand = { "Iso14443bCommand", "com.st.st25sdk.command", ptrTable, methods, fields, 7, 0x1, 9, 8, -1, 12, -1, -1, -1 };
  return &_ComStSt25sdkCommandIso14443bCommand;
}

@end

void ComStSt25sdkCommandIso14443bCommand_initWithComStSt25sdkRFReaderInterface_(ComStSt25sdkCommandIso14443bCommand *self, id<ComStSt25sdkRFReaderInterface> reader) {
  NSObject_init(self);
  self->mReaderInterface_ = reader;
}

ComStSt25sdkCommandIso14443bCommand *new_ComStSt25sdkCommandIso14443bCommand_initWithComStSt25sdkRFReaderInterface_(id<ComStSt25sdkRFReaderInterface> reader) {
  J2OBJC_NEW_IMPL(ComStSt25sdkCommandIso14443bCommand, initWithComStSt25sdkRFReaderInterface_, reader)
}

ComStSt25sdkCommandIso14443bCommand *create_ComStSt25sdkCommandIso14443bCommand_initWithComStSt25sdkRFReaderInterface_(id<ComStSt25sdkRFReaderInterface> reader) {
  J2OBJC_CREATE_IMPL(ComStSt25sdkCommandIso14443bCommand, initWithComStSt25sdkRFReaderInterface_, reader)
}

J2OBJC_CLASS_TYPE_LITERAL_SOURCE(ComStSt25sdkCommandIso14443bCommand)

J2OBJC_INITIALIZED_DEFN(ComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode)

ComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode *ComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode_values_[1];

@implementation ComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode

+ (ComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode *)ISO14443B_STANDARD_FRAME {
  return JreEnum(ComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode, ISO14443B_STANDARD_FRAME);
}

+ (IOSObjectArray *)values {
  return ComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode_values();
}

+ (ComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode *)valueOfWithNSString:(NSString *)name {
  return ComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode_valueOfWithNSString_(name);
}

- (ComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode_Enum)toNSEnum {
  return (ComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode_Enum)[self ordinal];
}

+ (const J2ObjcClassInfo *)__metadata {
  static J2ObjcMethodInfo methods[] = {
    { NULL, "[LComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode;", 0x9, -1, -1, -1, -1, -1, -1 },
    { NULL, "LComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode;", 0x9, 0, 1, -1, -1, -1, -1 },
  };
  #pragma clang diagnostic push
  #pragma clang diagnostic ignored "-Wobjc-multiple-method-names"
  #pragma clang diagnostic ignored "-Wundeclared-selector"
  methods[0].selector = @selector(values);
  methods[1].selector = @selector(valueOfWithNSString:);
  #pragma clang diagnostic pop
  static const J2ObjcFieldInfo fields[] = {
    { "ISO14443B_STANDARD_FRAME", "LComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode;", .constantValue.asLong = 0, 0x4019, -1, 2, -1, -1 },
  };
  static const void *ptrTable[] = { "valueOf", "LNSString;", &JreEnum(ComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode, ISO14443B_STANDARD_FRAME), "LComStSt25sdkCommandIso14443bCommand;", "Ljava/lang/Enum<Lcom/st/st25sdk/command/Iso14443bCommand$iso14443bFrameMode;>;" };
  static const J2ObjcClassInfo _ComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode = { "iso14443bFrameMode", "com.st.st25sdk.command", ptrTable, methods, fields, 7, 0x4019, 2, 1, 3, -1, -1, 4, -1 };
  return &_ComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode;
}

+ (void)initialize {
  if (self == [ComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode class]) {
    JreEnum(ComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode, ISO14443B_STANDARD_FRAME) = new_ComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode_initWithNSString_withInt_(JreEnumConstantName(ComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode_class_(), 0), 0);
    J2OBJC_SET_INITIALIZED(ComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode)
  }
}

@end

void ComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode_initWithNSString_withInt_(ComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode *self, NSString *__name, jint __ordinal) {
  JavaLangEnum_initWithNSString_withInt_(self, __name, __ordinal);
}

ComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode *new_ComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode_initWithNSString_withInt_(NSString *__name, jint __ordinal) {
  J2OBJC_NEW_IMPL(ComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode, initWithNSString_withInt_, __name, __ordinal)
}

IOSObjectArray *ComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode_values() {
  ComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode_initialize();
  return [IOSObjectArray arrayWithObjects:ComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode_values_ count:1 type:ComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode_class_()];
}

ComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode *ComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode_valueOfWithNSString_(NSString *name) {
  ComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode_initialize();
  for (int i = 0; i < 1; i++) {
    ComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode *e = ComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode_values_[i];
    if ([name isEqual:[e name]]) {
      return e;
    }
  }
  @throw create_JavaLangIllegalArgumentException_initWithNSString_(name);
  return nil;
}

ComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode *ComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode_fromOrdinal(NSUInteger ordinal) {
  ComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode_initialize();
  if (ordinal >= 1) {
    return nil;
  }
  return ComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode_values_[ordinal];
}

J2OBJC_CLASS_TYPE_LITERAL_SOURCE(ComStSt25sdkCommandIso14443bCommand_iso14443bFrameMode)
