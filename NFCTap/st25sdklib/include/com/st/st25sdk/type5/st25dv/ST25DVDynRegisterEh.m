//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: st25sdk_ios/type5/st25dv/ST25DVDynRegisterEh.java
//

#include "IOSObjectArray.h"
#include "J2ObjC_source.h"
#include "com/st/st25sdk/STDynamicRegister.h"
#include "com/st/st25sdk/STRegister.h"
#include "com/st/st25sdk/command/Iso15693CustomCommand.h"
#include "com/st/st25sdk/type5/st25dv/ST25DVDynRegisterEh.h"
#include "com/st/st25sdk/type5/st25dv/ST25DVTag.h"
#include "java/lang/Enum.h"
#include "java/lang/IllegalArgumentException.h"
#include "java/util/ArrayList.h"
#include "java/util/List.h"

__attribute__((unused)) static void ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl_initWithNSString_withInt_(ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl *self, NSString *__name, jint __ordinal);

__attribute__((unused)) static ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl *new_ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl_initWithNSString_withInt_(NSString *__name, jint __ordinal) NS_RETURNS_RETAINED;

@implementation ComStSt25sdkType5St25dvST25DVDynRegisterEh

+ (jbyte)EH_EN_BIT_MASK {
  return ComStSt25sdkType5St25dvST25DVDynRegisterEh_EH_EN_BIT_MASK;
}

+ (jbyte)EH_ON_BIT_MASK {
  return ComStSt25sdkType5St25dvST25DVDynRegisterEh_EH_ON_BIT_MASK;
}

+ (jbyte)FIELD_ON_BIT_MASK {
  return ComStSt25sdkType5St25dvST25DVDynRegisterEh_FIELD_ON_BIT_MASK;
}

+ (jbyte)VCC_ON_BIT_MASK {
  return ComStSt25sdkType5St25dvST25DVDynRegisterEh_VCC_ON_BIT_MASK;
}

+ (jbyte)RFU_ON_BIT_MASK {
  return ComStSt25sdkType5St25dvST25DVDynRegisterEh_RFU_ON_BIT_MASK;
}

+ (ComStSt25sdkType5St25dvST25DVDynRegisterEh *)newInstanceWithComStSt25sdkCommandIso15693CustomCommand:(ComStSt25sdkCommandIso15693CustomCommand *)iso15693CustomCommand {
  return ComStSt25sdkType5St25dvST25DVDynRegisterEh_newInstanceWithComStSt25sdkCommandIso15693CustomCommand_(iso15693CustomCommand);
}

- (instancetype)initWithComStSt25sdkCommandIso15693CustomCommand:(ComStSt25sdkCommandIso15693CustomCommand *)iso15693CustomCommand
                                                         withInt:(jint)registerAddress
                                                    withNSString:(NSString *)registerName
                                                    withNSString:(NSString *)registerContentDescription
                 withComStSt25sdkSTRegister_RegisterAccessRights:(ComStSt25sdkSTRegister_RegisterAccessRights *)registerAccessRights
                     withComStSt25sdkSTRegister_RegisterDataSize:(ComStSt25sdkSTRegister_RegisterDataSize *)registerDataSize {
  ComStSt25sdkType5St25dvST25DVDynRegisterEh_initWithComStSt25sdkCommandIso15693CustomCommand_withInt_withNSString_withNSString_withComStSt25sdkSTRegister_RegisterAccessRights_withComStSt25sdkSTRegister_RegisterDataSize_(self, iso15693CustomCommand, registerAddress, registerName, registerContentDescription, registerAccessRights, registerDataSize);
  return self;
}

- (jboolean)isEHFieldEnabledWithComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl:(ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl *)ehControl {
  jboolean ehEnable;
  ComStSt25sdkSTRegister_STRegisterField *ehField = [self getRegisterFieldWithNSString:[((ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl *) nil_chk(ehControl)) description]];
  ehEnable = ([((ComStSt25sdkSTRegister_STRegisterField *) nil_chk(ehField)) getValue] != 0);
  return ehEnable;
}

- (void)setEHWithComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl:(ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl *)ehControl
                                                                withBoolean:(jboolean)enable {
  ComStSt25sdkSTRegister_STRegisterField *ehField = [self getRegisterFieldWithNSString:[((ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl *) nil_chk(ehControl)) description]];
  [((ComStSt25sdkSTRegister_STRegisterField *) nil_chk(ehField)) setValueWithInt:enable ? 1 : 0];
}

+ (const J2ObjcClassInfo *)__metadata {
  static J2ObjcMethodInfo methods[] = {
    { NULL, "LComStSt25sdkType5St25dvST25DVDynRegisterEh;", 0x9, 0, 1, -1, -1, -1, -1 },
    { NULL, NULL, 0x1, -1, 2, -1, -1, -1, -1 },
    { NULL, "Z", 0x1, 3, 4, 5, -1, -1, -1 },
    { NULL, "V", 0x1, 6, 7, 5, -1, -1, -1 },
  };
  #pragma clang diagnostic push
  #pragma clang diagnostic ignored "-Wobjc-multiple-method-names"
  #pragma clang diagnostic ignored "-Wundeclared-selector"
  methods[0].selector = @selector(newInstanceWithComStSt25sdkCommandIso15693CustomCommand:);
  methods[1].selector = @selector(initWithComStSt25sdkCommandIso15693CustomCommand:withInt:withNSString:withNSString:withComStSt25sdkSTRegister_RegisterAccessRights:withComStSt25sdkSTRegister_RegisterDataSize:);
  methods[2].selector = @selector(isEHFieldEnabledWithComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl:);
  methods[3].selector = @selector(setEHWithComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl:withBoolean:);
  #pragma clang diagnostic pop
  static const J2ObjcFieldInfo fields[] = {
    { "EH_EN_BIT_MASK", "B", .constantValue.asChar = ComStSt25sdkType5St25dvST25DVDynRegisterEh_EH_EN_BIT_MASK, 0x19, -1, -1, -1, -1 },
    { "EH_ON_BIT_MASK", "B", .constantValue.asChar = ComStSt25sdkType5St25dvST25DVDynRegisterEh_EH_ON_BIT_MASK, 0x19, -1, -1, -1, -1 },
    { "FIELD_ON_BIT_MASK", "B", .constantValue.asChar = ComStSt25sdkType5St25dvST25DVDynRegisterEh_FIELD_ON_BIT_MASK, 0x19, -1, -1, -1, -1 },
    { "VCC_ON_BIT_MASK", "B", .constantValue.asChar = ComStSt25sdkType5St25dvST25DVDynRegisterEh_VCC_ON_BIT_MASK, 0x19, -1, -1, -1, -1 },
    { "RFU_ON_BIT_MASK", "B", .constantValue.asChar = ComStSt25sdkType5St25dvST25DVDynRegisterEh_RFU_ON_BIT_MASK, 0x19, -1, -1, -1, -1 },
  };
  static const void *ptrTable[] = { "newInstance", "LComStSt25sdkCommandIso15693CustomCommand;", "LComStSt25sdkCommandIso15693CustomCommand;ILNSString;LNSString;LComStSt25sdkSTRegister_RegisterAccessRights;LComStSt25sdkSTRegister_RegisterDataSize;", "isEHFieldEnabled", "LComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl;", "LComStSt25sdkSTException;", "setEH", "LComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl;Z" };
  static const J2ObjcClassInfo _ComStSt25sdkType5St25dvST25DVDynRegisterEh = { "ST25DVDynRegisterEh", "com.st.st25sdk.type5.st25dv", ptrTable, methods, fields, 7, 0x1, 4, 5, -1, 4, -1, -1, -1 };
  return &_ComStSt25sdkType5St25dvST25DVDynRegisterEh;
}

@end

ComStSt25sdkType5St25dvST25DVDynRegisterEh *ComStSt25sdkType5St25dvST25DVDynRegisterEh_newInstanceWithComStSt25sdkCommandIso15693CustomCommand_(ComStSt25sdkCommandIso15693CustomCommand *iso15693CustomCommand) {
  ComStSt25sdkType5St25dvST25DVDynRegisterEh_initialize();
  return new_ComStSt25sdkType5St25dvST25DVDynRegisterEh_initWithComStSt25sdkCommandIso15693CustomCommand_withInt_withNSString_withNSString_withComStSt25sdkSTRegister_RegisterAccessRights_withComStSt25sdkSTRegister_RegisterDataSize_(iso15693CustomCommand, ComStSt25sdkType5St25dvST25DVTag_REGISTER_DYN_EH_CTRL_ADDRESS, @"EH Control Dyn", @"Energy Harvesting management and usage status", JreLoadEnum(ComStSt25sdkSTRegister_RegisterAccessRights, REGISTER_READ_WRITE), JreLoadEnum(ComStSt25sdkSTRegister_RegisterDataSize, REGISTER_DATA_ON_8_BITS));
}

void ComStSt25sdkType5St25dvST25DVDynRegisterEh_initWithComStSt25sdkCommandIso15693CustomCommand_withInt_withNSString_withNSString_withComStSt25sdkSTRegister_RegisterAccessRights_withComStSt25sdkSTRegister_RegisterDataSize_(ComStSt25sdkType5St25dvST25DVDynRegisterEh *self, ComStSt25sdkCommandIso15693CustomCommand *iso15693CustomCommand, jint registerAddress, NSString *registerName, NSString *registerContentDescription, ComStSt25sdkSTRegister_RegisterAccessRights *registerAccessRights, ComStSt25sdkSTRegister_RegisterDataSize *registerDataSize) {
  ComStSt25sdkSTDynamicRegister_initWithComStSt25sdkCommandIso15693CustomCommand_withInt_withNSString_withNSString_withComStSt25sdkSTRegister_RegisterAccessRights_withComStSt25sdkSTRegister_RegisterDataSize_(self, iso15693CustomCommand, registerAddress, registerName, registerContentDescription, registerAccessRights, registerDataSize);
  id<JavaUtilList> registerFields = new_JavaUtilArrayList_init();
  [registerFields addWithId:new_ComStSt25sdkSTRegister_STRegisterField_initWithComStSt25sdkSTRegister_withNSString_withNSString_withByte_(self, [((ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl *) nil_chk(JreLoadEnum(ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl, EH_EN))) description], @"0: (R/W) Disable Energy Harvesting\n1: (R/W) Enable Energy Harvesting\n", ComStSt25sdkType5St25dvST25DVDynRegisterEh_EH_EN_BIT_MASK)];
  [registerFields addWithId:new_ComStSt25sdkSTRegister_STRegisterField_initWithComStSt25sdkSTRegister_withNSString_withNSString_withByte_(self, [((ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl *) nil_chk(JreLoadEnum(ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl, EH_ON))) description], @"0: (RO) Energy Harvesting state is inactive\n1: (RO) Energy Harvesting state is active\n", ComStSt25sdkType5St25dvST25DVDynRegisterEh_EH_ON_BIT_MASK)];
  [registerFields addWithId:new_ComStSt25sdkSTRegister_STRegisterField_initWithComStSt25sdkSTRegister_withNSString_withNSString_withByte_(self, [((ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl *) nil_chk(JreLoadEnum(ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl, FIELD_ON))) description], @"0: (RO) RF state is inactive\n1: (RO) RF state is active\n", ComStSt25sdkType5St25dvST25DVDynRegisterEh_FIELD_ON_BIT_MASK)];
  [registerFields addWithId:new_ComStSt25sdkSTRegister_STRegisterField_initWithComStSt25sdkSTRegister_withNSString_withNSString_withByte_(self, [((ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl *) nil_chk(JreLoadEnum(ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl, VCC_ON))) description], @"0: (RO) VCC state is inactive\n1: (RO) VCC state is active\n", ComStSt25sdkType5St25dvST25DVDynRegisterEh_VCC_ON_BIT_MASK)];
  [registerFields addWithId:new_ComStSt25sdkSTRegister_STRegisterField_initWithComStSt25sdkSTRegister_withNSString_withNSString_withByte_(self, @"RFU", @"RFU", ComStSt25sdkType5St25dvST25DVDynRegisterEh_RFU_ON_BIT_MASK)];
  [self createFieldHashWithJavaUtilList:registerFields];
}

ComStSt25sdkType5St25dvST25DVDynRegisterEh *new_ComStSt25sdkType5St25dvST25DVDynRegisterEh_initWithComStSt25sdkCommandIso15693CustomCommand_withInt_withNSString_withNSString_withComStSt25sdkSTRegister_RegisterAccessRights_withComStSt25sdkSTRegister_RegisterDataSize_(ComStSt25sdkCommandIso15693CustomCommand *iso15693CustomCommand, jint registerAddress, NSString *registerName, NSString *registerContentDescription, ComStSt25sdkSTRegister_RegisterAccessRights *registerAccessRights, ComStSt25sdkSTRegister_RegisterDataSize *registerDataSize) {
  J2OBJC_NEW_IMPL(ComStSt25sdkType5St25dvST25DVDynRegisterEh, initWithComStSt25sdkCommandIso15693CustomCommand_withInt_withNSString_withNSString_withComStSt25sdkSTRegister_RegisterAccessRights_withComStSt25sdkSTRegister_RegisterDataSize_, iso15693CustomCommand, registerAddress, registerName, registerContentDescription, registerAccessRights, registerDataSize)
}

ComStSt25sdkType5St25dvST25DVDynRegisterEh *create_ComStSt25sdkType5St25dvST25DVDynRegisterEh_initWithComStSt25sdkCommandIso15693CustomCommand_withInt_withNSString_withNSString_withComStSt25sdkSTRegister_RegisterAccessRights_withComStSt25sdkSTRegister_RegisterDataSize_(ComStSt25sdkCommandIso15693CustomCommand *iso15693CustomCommand, jint registerAddress, NSString *registerName, NSString *registerContentDescription, ComStSt25sdkSTRegister_RegisterAccessRights *registerAccessRights, ComStSt25sdkSTRegister_RegisterDataSize *registerDataSize) {
  J2OBJC_CREATE_IMPL(ComStSt25sdkType5St25dvST25DVDynRegisterEh, initWithComStSt25sdkCommandIso15693CustomCommand_withInt_withNSString_withNSString_withComStSt25sdkSTRegister_RegisterAccessRights_withComStSt25sdkSTRegister_RegisterDataSize_, iso15693CustomCommand, registerAddress, registerName, registerContentDescription, registerAccessRights, registerDataSize)
}

J2OBJC_CLASS_TYPE_LITERAL_SOURCE(ComStSt25sdkType5St25dvST25DVDynRegisterEh)

J2OBJC_INITIALIZED_DEFN(ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl)

ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl *ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl_values_[4];

@implementation ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl

+ (ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl *)EH_EN {
  return JreEnum(ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl, EH_EN);
}

+ (ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl *)EH_ON {
  return JreEnum(ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl, EH_ON);
}

+ (ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl *)FIELD_ON {
  return JreEnum(ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl, FIELD_ON);
}

+ (ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl *)VCC_ON {
  return JreEnum(ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl, VCC_ON);
}

+ (IOSObjectArray *)values {
  return ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl_values();
}

+ (ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl *)valueOfWithNSString:(NSString *)name {
  return ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl_valueOfWithNSString_(name);
}

- (ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl_Enum)toNSEnum {
  return (ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl_Enum)[self ordinal];
}

+ (const J2ObjcClassInfo *)__metadata {
  static J2ObjcMethodInfo methods[] = {
    { NULL, "[LComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl;", 0x9, -1, -1, -1, -1, -1, -1 },
    { NULL, "LComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl;", 0x9, 0, 1, -1, -1, -1, -1 },
  };
  #pragma clang diagnostic push
  #pragma clang diagnostic ignored "-Wobjc-multiple-method-names"
  #pragma clang diagnostic ignored "-Wundeclared-selector"
  methods[0].selector = @selector(values);
  methods[1].selector = @selector(valueOfWithNSString:);
  #pragma clang diagnostic pop
  static const J2ObjcFieldInfo fields[] = {
    { "EH_EN", "LComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl;", .constantValue.asLong = 0, 0x4019, -1, 2, -1, -1 },
    { "EH_ON", "LComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl;", .constantValue.asLong = 0, 0x4019, -1, 3, -1, -1 },
    { "FIELD_ON", "LComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl;", .constantValue.asLong = 0, 0x4019, -1, 4, -1, -1 },
    { "VCC_ON", "LComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl;", .constantValue.asLong = 0, 0x4019, -1, 5, -1, -1 },
  };
  static const void *ptrTable[] = { "valueOf", "LNSString;", &JreEnum(ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl, EH_EN), &JreEnum(ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl, EH_ON), &JreEnum(ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl, FIELD_ON), &JreEnum(ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl, VCC_ON), "LComStSt25sdkType5St25dvST25DVDynRegisterEh;", "Ljava/lang/Enum<Lcom/st/st25sdk/type5/st25dv/ST25DVDynRegisterEh$ST25DVEHControl;>;" };
  static const J2ObjcClassInfo _ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl = { "ST25DVEHControl", "com.st.st25sdk.type5.st25dv", ptrTable, methods, fields, 7, 0x4019, 2, 4, 6, -1, -1, 7, -1 };
  return &_ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl;
}

+ (void)initialize {
  if (self == [ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl class]) {
    JreEnum(ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl, EH_EN) = new_ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl_initWithNSString_withInt_(JreEnumConstantName(ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl_class_(), 0), 0);
    JreEnum(ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl, EH_ON) = new_ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl_initWithNSString_withInt_(JreEnumConstantName(ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl_class_(), 1), 1);
    JreEnum(ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl, FIELD_ON) = new_ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl_initWithNSString_withInt_(JreEnumConstantName(ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl_class_(), 2), 2);
    JreEnum(ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl, VCC_ON) = new_ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl_initWithNSString_withInt_(JreEnumConstantName(ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl_class_(), 3), 3);
    J2OBJC_SET_INITIALIZED(ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl)
  }
}

@end

void ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl_initWithNSString_withInt_(ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl *self, NSString *__name, jint __ordinal) {
  JavaLangEnum_initWithNSString_withInt_(self, __name, __ordinal);
}

ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl *new_ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl_initWithNSString_withInt_(NSString *__name, jint __ordinal) {
  J2OBJC_NEW_IMPL(ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl, initWithNSString_withInt_, __name, __ordinal)
}

IOSObjectArray *ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl_values() {
  ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl_initialize();
  return [IOSObjectArray arrayWithObjects:ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl_values_ count:4 type:ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl_class_()];
}

ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl *ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl_valueOfWithNSString_(NSString *name) {
  ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl_initialize();
  for (int i = 0; i < 4; i++) {
    ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl *e = ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl_values_[i];
    if ([name isEqual:[e name]]) {
      return e;
    }
  }
  @throw create_JavaLangIllegalArgumentException_initWithNSString_(name);
  return nil;
}

ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl *ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl_fromOrdinal(NSUInteger ordinal) {
  ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl_initialize();
  if (ordinal >= 4) {
    return nil;
  }
  return ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl_values_[ordinal];
}

J2OBJC_CLASS_TYPE_LITERAL_SOURCE(ComStSt25sdkType5St25dvST25DVDynRegisterEh_ST25DVEHControl)
