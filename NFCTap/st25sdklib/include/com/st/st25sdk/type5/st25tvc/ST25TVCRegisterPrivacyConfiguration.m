//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: st25sdk_ios/type5/st25tvc/ST25TVCRegisterPrivacyConfiguration.java
//

#include "J2ObjC_source.h"
#include "com/st/st25sdk/STRegister.h"
#include "com/st/st25sdk/UntraceableModeInterface.h"
#include "com/st/st25sdk/command/Iso15693CustomCommand.h"
#include "com/st/st25sdk/type5/STType5Register.h"
#include "com/st/st25sdk/type5/st25tvc/ST25TVCRegisterPrivacyConfiguration.h"
#include "com/st/st25sdk/type5/st25tvc/ST25TVCTag.h"
#include "java/util/ArrayList.h"

#pragma clang diagnostic ignored "-Wincomplete-implementation"

@interface ComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration_1 : JavaUtilArrayList

- (instancetype)initWithComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration:(ComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration *)outer$;

- (ComStSt25sdkSTRegister_STRegisterField *)getWithInt:(jint)arg0;

- (ComStSt25sdkSTRegister_STRegisterField *)removeWithInt:(jint)arg0;

- (ComStSt25sdkSTRegister_STRegisterField *)setWithInt:(jint)arg0
                                                withId:(ComStSt25sdkSTRegister_STRegisterField *)arg1;

@end

J2OBJC_EMPTY_STATIC_INIT(ComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration_1)

__attribute__((unused)) static void ComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration_1_initWithComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration_(ComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration_1 *self, ComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration *outer$);

__attribute__((unused)) static ComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration_1 *new_ComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration_1_initWithComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration_(ComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration *outer$) NS_RETURNS_RETAINED;

__attribute__((unused)) static ComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration_1 *create_ComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration_1_initWithComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration_(ComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration *outer$);

@implementation ComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration

+ (ComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration *)newInstanceWithComStSt25sdkCommandIso15693CustomCommand:(ComStSt25sdkCommandIso15693CustomCommand *)iso15693CustomCommand {
  return ComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration_newInstanceWithComStSt25sdkCommandIso15693CustomCommand_(iso15693CustomCommand);
}

- (instancetype)initWithComStSt25sdkCommandIso15693CustomCommand:(ComStSt25sdkCommandIso15693CustomCommand *)iso15693CustomCommand
                                                         withInt:(jint)registerAddress
                                                         withInt:(jint)registerParameterAddress
                                                    withNSString:(NSString *)registerName
                                                    withNSString:(NSString *)registerContentDescription
                 withComStSt25sdkSTRegister_RegisterAccessRights:(ComStSt25sdkSTRegister_RegisterAccessRights *)registerAccessRights
                     withComStSt25sdkSTRegister_RegisterDataSize:(ComStSt25sdkSTRegister_RegisterDataSize *)registerDataSize {
  ComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration_initWithComStSt25sdkCommandIso15693CustomCommand_withInt_withInt_withNSString_withNSString_withComStSt25sdkSTRegister_RegisterAccessRights_withComStSt25sdkSTRegister_RegisterDataSize_(self, iso15693CustomCommand, registerAddress, registerParameterAddress, registerName, registerContentDescription, registerAccessRights, registerDataSize);
  return self;
}

- (jboolean)isUntraceableInventoryDisabled {
  jboolean isInventoryDisabled;
  jint fieldValue = [((ComStSt25sdkSTRegister_STRegisterField *) nil_chk([self getRegisterFieldWithNSString:@"DIS_INV"])) getValue];
  isInventoryDisabled = (fieldValue == 1);
  return isInventoryDisabled;
}

- (void)disableUntraceableInventoryWithBoolean:(jboolean)isInventoryResponseDisabled {
  jint fieldValue = isInventoryResponseDisabled ? 1 : 0;
  [((ComStSt25sdkSTRegister_STRegisterField *) nil_chk([self getRegisterFieldWithNSString:@"DIS_INV"])) setValueWithInt:fieldValue];
}

- (jboolean)isKillDisabled {
  jboolean isKillDisable;
  jint fieldValue = [((ComStSt25sdkSTRegister_STRegisterField *) nil_chk([self getRegisterFieldWithNSString:@"DIS_KILL"])) getValue];
  isKillDisable = (fieldValue == 1);
  return isKillDisable;
}

- (void)disableKillWithBoolean:(jboolean)isKillDisabled {
  jint fieldValue = isKillDisabled ? 1 : 0;
  [((ComStSt25sdkSTRegister_STRegisterField *) nil_chk([self getRegisterFieldWithNSString:@"DIS_KILL"])) setValueWithInt:fieldValue];
}

- (ComStSt25sdkUntraceableModeInterface_UntraceableModeDefaultSettings *)getUntraceableModeDefaultSetting {
  ComStSt25sdkUntraceableModeInterface_UntraceableModeDefaultSettings *mode;
  jint fieldValue = [((ComStSt25sdkSTRegister_STRegisterField *) nil_chk([self getRegisterFieldWithNSString:@"UNTR_DFT"])) getValue];
  switch (fieldValue) {
    default:
    case (jint) 0x0:
    mode = JreLoadEnum(ComStSt25sdkUntraceableModeInterface_UntraceableModeDefaultSettings, PRIVACY_BY_DEFAULT_DISABLED);
    break;
    case (jint) 0x1:
    mode = JreLoadEnum(ComStSt25sdkUntraceableModeInterface_UntraceableModeDefaultSettings, PRIVACY_BY_DEFAULT_ENABLED);
    break;
    case (jint) 0x2:
    mode = JreLoadEnum(ComStSt25sdkUntraceableModeInterface_UntraceableModeDefaultSettings, PRIVACY_BY_DEFAULT_ENABLED_WHEN_TAMPER_DETECT_CLOSED);
    break;
    case (jint) 0x3:
    mode = JreLoadEnum(ComStSt25sdkUntraceableModeInterface_UntraceableModeDefaultSettings, PRIVACY_BY_DEFAULT_ENABLED_WHEN_TAMPER_DETECT_OPEN);
    break;
  }
  return mode;
}

- (void)setUntraceableModeDefaultSettingWithComStSt25sdkUntraceableModeInterface_UntraceableModeDefaultSettings:(ComStSt25sdkUntraceableModeInterface_UntraceableModeDefaultSettings *)mode {
  jint fieldValue;
  switch ([mode ordinal]) {
    default:
    case ComStSt25sdkUntraceableModeInterface_UntraceableModeDefaultSettings_Enum_PRIVACY_BY_DEFAULT_DISABLED:
    fieldValue = (jint) 0x00;
    break;
    case ComStSt25sdkUntraceableModeInterface_UntraceableModeDefaultSettings_Enum_PRIVACY_BY_DEFAULT_ENABLED:
    fieldValue = (jint) 0x01;
    break;
    case ComStSt25sdkUntraceableModeInterface_UntraceableModeDefaultSettings_Enum_PRIVACY_BY_DEFAULT_ENABLED_WHEN_TAMPER_DETECT_CLOSED:
    fieldValue = (jint) 0x02;
    break;
    case ComStSt25sdkUntraceableModeInterface_UntraceableModeDefaultSettings_Enum_PRIVACY_BY_DEFAULT_ENABLED_WHEN_TAMPER_DETECT_OPEN:
    fieldValue = (jint) 0x03;
    break;
  }
  [((ComStSt25sdkSTRegister_STRegisterField *) nil_chk([self getRegisterFieldWithNSString:@"UNTR_DFT"])) setValueWithInt:fieldValue];
}

+ (const J2ObjcClassInfo *)__metadata {
  static J2ObjcMethodInfo methods[] = {
    { NULL, "LComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration;", 0x9, 0, 1, -1, -1, -1, -1 },
    { NULL, NULL, 0x1, -1, 2, -1, -1, -1, -1 },
    { NULL, "Z", 0x1, -1, -1, 3, -1, -1, -1 },
    { NULL, "V", 0x1, 4, 5, 3, -1, -1, -1 },
    { NULL, "Z", 0x1, -1, -1, 3, -1, -1, -1 },
    { NULL, "V", 0x1, 6, 5, 3, -1, -1, -1 },
    { NULL, "LComStSt25sdkUntraceableModeInterface_UntraceableModeDefaultSettings;", 0x1, -1, -1, 3, -1, -1, -1 },
    { NULL, "V", 0x1, 7, 8, 3, -1, -1, -1 },
  };
  #pragma clang diagnostic push
  #pragma clang diagnostic ignored "-Wobjc-multiple-method-names"
  #pragma clang diagnostic ignored "-Wundeclared-selector"
  methods[0].selector = @selector(newInstanceWithComStSt25sdkCommandIso15693CustomCommand:);
  methods[1].selector = @selector(initWithComStSt25sdkCommandIso15693CustomCommand:withInt:withInt:withNSString:withNSString:withComStSt25sdkSTRegister_RegisterAccessRights:withComStSt25sdkSTRegister_RegisterDataSize:);
  methods[2].selector = @selector(isUntraceableInventoryDisabled);
  methods[3].selector = @selector(disableUntraceableInventoryWithBoolean:);
  methods[4].selector = @selector(isKillDisabled);
  methods[5].selector = @selector(disableKillWithBoolean:);
  methods[6].selector = @selector(getUntraceableModeDefaultSetting);
  methods[7].selector = @selector(setUntraceableModeDefaultSettingWithComStSt25sdkUntraceableModeInterface_UntraceableModeDefaultSettings:);
  #pragma clang diagnostic pop
  static const void *ptrTable[] = { "newInstance", "LComStSt25sdkCommandIso15693CustomCommand;", "LComStSt25sdkCommandIso15693CustomCommand;IILNSString;LNSString;LComStSt25sdkSTRegister_RegisterAccessRights;LComStSt25sdkSTRegister_RegisterDataSize;", "LComStSt25sdkSTException;", "disableUntraceableInventory", "Z", "disableKill", "setUntraceableModeDefaultSetting", "LComStSt25sdkUntraceableModeInterface_UntraceableModeDefaultSettings;" };
  static const J2ObjcClassInfo _ComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration = { "ST25TVCRegisterPrivacyConfiguration", "com.st.st25sdk.type5.st25tvc", ptrTable, methods, NULL, 7, 0x1, 8, 0, -1, -1, -1, -1, -1 };
  return &_ComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration;
}

@end

ComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration *ComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration_newInstanceWithComStSt25sdkCommandIso15693CustomCommand_(ComStSt25sdkCommandIso15693CustomCommand *iso15693CustomCommand) {
  ComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration_initialize();
  NSString *registerName = @"PrivacyConfig";
  NSString *registerContentDescription = @"Defines Privacy behaviour";
  return new_ComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration_initWithComStSt25sdkCommandIso15693CustomCommand_withInt_withInt_withNSString_withNSString_withComStSt25sdkSTRegister_RegisterAccessRights_withComStSt25sdkSTRegister_RegisterDataSize_(iso15693CustomCommand, ComStSt25sdkType5St25tvcST25TVCTag_ST25TVC_FID_REGISTER_PRIVACY, ComStSt25sdkType5St25tvcST25TVCTag_ST25TVC_PID_REGISTER_PRIVACY_CONFIGURATION, registerName, registerContentDescription, JreLoadEnum(ComStSt25sdkSTRegister_RegisterAccessRights, REGISTER_READ_WRITE), JreLoadEnum(ComStSt25sdkSTRegister_RegisterDataSize, REGISTER_DATA_ON_8_BITS));
}

void ComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration_initWithComStSt25sdkCommandIso15693CustomCommand_withInt_withInt_withNSString_withNSString_withComStSt25sdkSTRegister_RegisterAccessRights_withComStSt25sdkSTRegister_RegisterDataSize_(ComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration *self, ComStSt25sdkCommandIso15693CustomCommand *iso15693CustomCommand, jint registerAddress, jint registerParameterAddress, NSString *registerName, NSString *registerContentDescription, ComStSt25sdkSTRegister_RegisterAccessRights *registerAccessRights, ComStSt25sdkSTRegister_RegisterDataSize *registerDataSize) {
  ComStSt25sdkType5STType5Register_initWithComStSt25sdkCommandIso15693CustomCommand_withInt_withInt_withNSString_withNSString_withComStSt25sdkSTRegister_RegisterAccessRights_withComStSt25sdkSTRegister_RegisterDataSize_(self, iso15693CustomCommand, registerAddress, registerParameterAddress, registerName, registerContentDescription, registerAccessRights, registerDataSize);
  [self createFieldHashWithJavaUtilList:new_ComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration_1_initWithComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration_(self)];
}

ComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration *new_ComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration_initWithComStSt25sdkCommandIso15693CustomCommand_withInt_withInt_withNSString_withNSString_withComStSt25sdkSTRegister_RegisterAccessRights_withComStSt25sdkSTRegister_RegisterDataSize_(ComStSt25sdkCommandIso15693CustomCommand *iso15693CustomCommand, jint registerAddress, jint registerParameterAddress, NSString *registerName, NSString *registerContentDescription, ComStSt25sdkSTRegister_RegisterAccessRights *registerAccessRights, ComStSt25sdkSTRegister_RegisterDataSize *registerDataSize) {
  J2OBJC_NEW_IMPL(ComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration, initWithComStSt25sdkCommandIso15693CustomCommand_withInt_withInt_withNSString_withNSString_withComStSt25sdkSTRegister_RegisterAccessRights_withComStSt25sdkSTRegister_RegisterDataSize_, iso15693CustomCommand, registerAddress, registerParameterAddress, registerName, registerContentDescription, registerAccessRights, registerDataSize)
}

ComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration *create_ComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration_initWithComStSt25sdkCommandIso15693CustomCommand_withInt_withInt_withNSString_withNSString_withComStSt25sdkSTRegister_RegisterAccessRights_withComStSt25sdkSTRegister_RegisterDataSize_(ComStSt25sdkCommandIso15693CustomCommand *iso15693CustomCommand, jint registerAddress, jint registerParameterAddress, NSString *registerName, NSString *registerContentDescription, ComStSt25sdkSTRegister_RegisterAccessRights *registerAccessRights, ComStSt25sdkSTRegister_RegisterDataSize *registerDataSize) {
  J2OBJC_CREATE_IMPL(ComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration, initWithComStSt25sdkCommandIso15693CustomCommand_withInt_withInt_withNSString_withNSString_withComStSt25sdkSTRegister_RegisterAccessRights_withComStSt25sdkSTRegister_RegisterDataSize_, iso15693CustomCommand, registerAddress, registerParameterAddress, registerName, registerContentDescription, registerAccessRights, registerDataSize)
}

J2OBJC_CLASS_TYPE_LITERAL_SOURCE(ComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration)

@implementation ComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration_1

- (instancetype)initWithComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration:(ComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration *)outer$ {
  ComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration_1_initWithComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration_(self, outer$);
  return self;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id *)stackbuf count:(NSUInteger)len {
  return JreDefaultFastEnumeration(self, state, stackbuf);
}

+ (const J2ObjcClassInfo *)__metadata {
  static J2ObjcMethodInfo methods[] = {
    { NULL, NULL, 0x0, -1, -1, -1, -1, -1, -1 },
  };
  #pragma clang diagnostic push
  #pragma clang diagnostic ignored "-Wobjc-multiple-method-names"
  #pragma clang diagnostic ignored "-Wundeclared-selector"
  methods[0].selector = @selector(initWithComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration:);
  #pragma clang diagnostic pop
  static const void *ptrTable[] = { "LComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration;", "initWithComStSt25sdkCommandIso15693CustomCommand:withInt:withInt:withNSString:withNSString:withComStSt25sdkSTRegister_RegisterAccessRights:withComStSt25sdkSTRegister_RegisterDataSize:", "Ljava/util/ArrayList<Lcom/st/st25sdk/STRegister$STRegisterField;>;" };
  static const J2ObjcClassInfo _ComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration_1 = { "", "com.st.st25sdk.type5.st25tvc", ptrTable, methods, NULL, 7, 0x8010, 1, 0, 0, -1, 1, 2, -1 };
  return &_ComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration_1;
}

@end

void ComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration_1_initWithComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration_(ComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration_1 *self, ComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration *outer$) {
  JavaUtilArrayList_init(self);
  {
    [self addWithId:new_ComStSt25sdkSTRegister_STRegisterField_initWithComStSt25sdkSTRegister_withNSString_withNSString_withInt_(outer$, @"UNTR_DFT", @"Untraceable mode default settings\n", 0b00000011)];
    [self addWithId:new_ComStSt25sdkSTRegister_STRegisterField_initWithComStSt25sdkSTRegister_withNSString_withNSString_withInt_(outer$, @"DIS_INV", @"0: Untraceable but responds to Inventory commands with a generic ID\n1: Disable the Inventory response of the tag in Untraceable Mode", 0b00000100)];
    [self addWithId:new_ComStSt25sdkSTRegister_STRegisterField_initWithComStSt25sdkSTRegister_withNSString_withNSString_withInt_(outer$, @"DIS_KILL", @"1: Kill feature is disabled\n", 0b00001000)];
    [self addWithId:new_ComStSt25sdkSTRegister_STRegisterField_initWithComStSt25sdkSTRegister_withNSString_withNSString_withInt_(outer$, @"RFU", @"Reserved for Future Use", 0b11110000)];
  }
}

ComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration_1 *new_ComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration_1_initWithComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration_(ComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration *outer$) {
  J2OBJC_NEW_IMPL(ComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration_1, initWithComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration_, outer$)
}

ComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration_1 *create_ComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration_1_initWithComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration_(ComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration *outer$) {
  J2OBJC_CREATE_IMPL(ComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration_1, initWithComStSt25sdkType5St25tvcST25TVCRegisterPrivacyConfiguration_, outer$)
}
