//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: st25sdk_ios/type2/st25tn/ST25TNRegisterAndefCustom.java
//

#include "J2ObjC_header.h"

#pragma push_macro("INCLUDE_ALL_ComStSt25sdkType2St25tnST25TNRegisterAndefCustom")
#ifdef RESTRICT_ComStSt25sdkType2St25tnST25TNRegisterAndefCustom
#define INCLUDE_ALL_ComStSt25sdkType2St25tnST25TNRegisterAndefCustom 0
#else
#define INCLUDE_ALL_ComStSt25sdkType2St25tnST25TNRegisterAndefCustom 1
#endif
#undef RESTRICT_ComStSt25sdkType2St25tnST25TNRegisterAndefCustom

#if __has_feature(nullability)
#pragma clang diagnostic push
#pragma GCC diagnostic ignored "-Wnullability"
#pragma GCC diagnostic ignored "-Wnullability-completeness"
#endif

#if !defined (ComStSt25sdkType2St25tnST25TNRegisterAndefCustom_) && (INCLUDE_ALL_ComStSt25sdkType2St25tnST25TNRegisterAndefCustom || defined(INCLUDE_ComStSt25sdkType2St25tnST25TNRegisterAndefCustom))
#define ComStSt25sdkType2St25tnST25TNRegisterAndefCustom_

#define RESTRICT_ComStSt25sdkType2STType2Register 1
#define INCLUDE_ComStSt25sdkType2STType2Register 1
#include "com/st/st25sdk/type2/STType2Register.h"

@class ComStSt25sdkCommandType2Command;
@class ComStSt25sdkSTRegister_RegisterAccessRights;
@class ComStSt25sdkSTRegister_RegisterDataSize;

@interface ComStSt25sdkType2St25tnST25TNRegisterAndefCustom : ComStSt25sdkType2STType2Register

#pragma mark Public

- (instancetype __nonnull)initWithComStSt25sdkCommandType2Command:(ComStSt25sdkCommandType2Command *)type2Command
                                                          withInt:(jint)blockNumber
                                                     withNSString:(NSString *)registerName
                                                     withNSString:(NSString *)registerContentDescription
                  withComStSt25sdkSTRegister_RegisterAccessRights:(ComStSt25sdkSTRegister_RegisterAccessRights *)registerAccessRights
                      withComStSt25sdkSTRegister_RegisterDataSize:(ComStSt25sdkSTRegister_RegisterDataSize *)registerDataSize;

- (jint)getAndefCustMsg;

+ (ComStSt25sdkType2St25tnST25TNRegisterAndefCustom *)newInstanceWithComStSt25sdkCommandType2Command:(ComStSt25sdkCommandType2Command *)type2Command
                                                                                             withInt:(jint)blockNumber OBJC_METHOD_FAMILY_NONE;

- (void)setAndefCustMsgWithInt:(jint)andefCustMsg;

@end

J2OBJC_EMPTY_STATIC_INIT(ComStSt25sdkType2St25tnST25TNRegisterAndefCustom)

FOUNDATION_EXPORT ComStSt25sdkType2St25tnST25TNRegisterAndefCustom *ComStSt25sdkType2St25tnST25TNRegisterAndefCustom_newInstanceWithComStSt25sdkCommandType2Command_withInt_(ComStSt25sdkCommandType2Command *type2Command, jint blockNumber);

FOUNDATION_EXPORT void ComStSt25sdkType2St25tnST25TNRegisterAndefCustom_initWithComStSt25sdkCommandType2Command_withInt_withNSString_withNSString_withComStSt25sdkSTRegister_RegisterAccessRights_withComStSt25sdkSTRegister_RegisterDataSize_(ComStSt25sdkType2St25tnST25TNRegisterAndefCustom *self, ComStSt25sdkCommandType2Command *type2Command, jint blockNumber, NSString *registerName, NSString *registerContentDescription, ComStSt25sdkSTRegister_RegisterAccessRights *registerAccessRights, ComStSt25sdkSTRegister_RegisterDataSize *registerDataSize);

FOUNDATION_EXPORT ComStSt25sdkType2St25tnST25TNRegisterAndefCustom *new_ComStSt25sdkType2St25tnST25TNRegisterAndefCustom_initWithComStSt25sdkCommandType2Command_withInt_withNSString_withNSString_withComStSt25sdkSTRegister_RegisterAccessRights_withComStSt25sdkSTRegister_RegisterDataSize_(ComStSt25sdkCommandType2Command *type2Command, jint blockNumber, NSString *registerName, NSString *registerContentDescription, ComStSt25sdkSTRegister_RegisterAccessRights *registerAccessRights, ComStSt25sdkSTRegister_RegisterDataSize *registerDataSize) NS_RETURNS_RETAINED;

FOUNDATION_EXPORT ComStSt25sdkType2St25tnST25TNRegisterAndefCustom *create_ComStSt25sdkType2St25tnST25TNRegisterAndefCustom_initWithComStSt25sdkCommandType2Command_withInt_withNSString_withNSString_withComStSt25sdkSTRegister_RegisterAccessRights_withComStSt25sdkSTRegister_RegisterDataSize_(ComStSt25sdkCommandType2Command *type2Command, jint blockNumber, NSString *registerName, NSString *registerContentDescription, ComStSt25sdkSTRegister_RegisterAccessRights *registerAccessRights, ComStSt25sdkSTRegister_RegisterDataSize *registerDataSize);

J2OBJC_TYPE_LITERAL_HEADER(ComStSt25sdkType2St25tnST25TNRegisterAndefCustom)

#endif


#if __has_feature(nullability)
#pragma clang diagnostic pop
#endif
#pragma pop_macro("INCLUDE_ALL_ComStSt25sdkType2St25tnST25TNRegisterAndefCustom")
