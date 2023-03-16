//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: st25sdk_ios/type5/st25dv/ST25DVRegisterEndAi.java
//

#include "J2ObjC_header.h"

#pragma push_macro("INCLUDE_ALL_ComStSt25sdkType5St25dvST25DVRegisterEndAi")
#ifdef RESTRICT_ComStSt25sdkType5St25dvST25DVRegisterEndAi
#define INCLUDE_ALL_ComStSt25sdkType5St25dvST25DVRegisterEndAi 0
#else
#define INCLUDE_ALL_ComStSt25sdkType5St25dvST25DVRegisterEndAi 1
#endif
#undef RESTRICT_ComStSt25sdkType5St25dvST25DVRegisterEndAi

#if __has_feature(nullability)
#pragma clang diagnostic push
#pragma GCC diagnostic ignored "-Wnullability"
#pragma GCC diagnostic ignored "-Wnullability-completeness"
#endif

#if !defined (ComStSt25sdkType5St25dvST25DVRegisterEndAi_) && (INCLUDE_ALL_ComStSt25sdkType5St25dvST25DVRegisterEndAi || defined(INCLUDE_ComStSt25sdkType5St25dvST25DVRegisterEndAi))
#define ComStSt25sdkType5St25dvST25DVRegisterEndAi_

#define RESTRICT_ComStSt25sdkType5STType5Register 1
#define INCLUDE_ComStSt25sdkType5STType5Register 1
#include "com/st/st25sdk/type5/STType5Register.h"

@class ComStSt25sdkCommandIso15693CustomCommand;
@class ComStSt25sdkSTRegister_RegisterAccessRights;
@class ComStSt25sdkSTRegister_RegisterDataSize;

@interface ComStSt25sdkType5St25dvST25DVRegisterEndAi : ComStSt25sdkType5STType5Register
@property (readonly, class) jbyte END_AI_BIT_MASK NS_SWIFT_NAME(END_AI_BIT_MASK);

+ (jbyte)END_AI_BIT_MASK;

#pragma mark Public

- (instancetype __nonnull)initWithComStSt25sdkCommandIso15693CustomCommand:(ComStSt25sdkCommandIso15693CustomCommand *)iso15693CustomCommand
                                                                   withInt:(jint)areaId
                                                                   withInt:(jint)registerAddress
                                                              withNSString:(NSString *)registerName
                                                              withNSString:(NSString *)registerContentDescription
                           withComStSt25sdkSTRegister_RegisterAccessRights:(ComStSt25sdkSTRegister_RegisterAccessRights *)registerAccessRights
                               withComStSt25sdkSTRegister_RegisterDataSize:(ComStSt25sdkSTRegister_RegisterDataSize *)registerDataSize;

- (jbyte)getEndArea;

- (jint)getEndAreaInBlock;

+ (ComStSt25sdkType5St25dvST25DVRegisterEndAi *)newInstanceWithComStSt25sdkCommandIso15693CustomCommand:(ComStSt25sdkCommandIso15693CustomCommand *)iso15693CustomCommand
                                                                                                withInt:(jint)index OBJC_METHOD_FAMILY_NONE;

// Disallowed inherited constructors, do not use.

- (instancetype __nonnull)initWithComStSt25sdkCommandIso15693CustomCommand:(ComStSt25sdkCommandIso15693CustomCommand *)arg0
                                                                   withInt:(jint)arg1
                                                              withNSString:(NSString *)arg2
                                                              withNSString:(NSString *)arg3
                           withComStSt25sdkSTRegister_RegisterAccessRights:(ComStSt25sdkSTRegister_RegisterAccessRights *)arg4
                               withComStSt25sdkSTRegister_RegisterDataSize:(ComStSt25sdkSTRegister_RegisterDataSize *)arg5 NS_UNAVAILABLE;

@end

J2OBJC_EMPTY_STATIC_INIT(ComStSt25sdkType5St25dvST25DVRegisterEndAi)

inline jbyte ComStSt25sdkType5St25dvST25DVRegisterEndAi_get_END_AI_BIT_MASK(void);
#define ComStSt25sdkType5St25dvST25DVRegisterEndAi_END_AI_BIT_MASK -1
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkType5St25dvST25DVRegisterEndAi, END_AI_BIT_MASK, jbyte)

FOUNDATION_EXPORT ComStSt25sdkType5St25dvST25DVRegisterEndAi *ComStSt25sdkType5St25dvST25DVRegisterEndAi_newInstanceWithComStSt25sdkCommandIso15693CustomCommand_withInt_(ComStSt25sdkCommandIso15693CustomCommand *iso15693CustomCommand, jint index);

FOUNDATION_EXPORT void ComStSt25sdkType5St25dvST25DVRegisterEndAi_initWithComStSt25sdkCommandIso15693CustomCommand_withInt_withInt_withNSString_withNSString_withComStSt25sdkSTRegister_RegisterAccessRights_withComStSt25sdkSTRegister_RegisterDataSize_(ComStSt25sdkType5St25dvST25DVRegisterEndAi *self, ComStSt25sdkCommandIso15693CustomCommand *iso15693CustomCommand, jint areaId, jint registerAddress, NSString *registerName, NSString *registerContentDescription, ComStSt25sdkSTRegister_RegisterAccessRights *registerAccessRights, ComStSt25sdkSTRegister_RegisterDataSize *registerDataSize);

FOUNDATION_EXPORT ComStSt25sdkType5St25dvST25DVRegisterEndAi *new_ComStSt25sdkType5St25dvST25DVRegisterEndAi_initWithComStSt25sdkCommandIso15693CustomCommand_withInt_withInt_withNSString_withNSString_withComStSt25sdkSTRegister_RegisterAccessRights_withComStSt25sdkSTRegister_RegisterDataSize_(ComStSt25sdkCommandIso15693CustomCommand *iso15693CustomCommand, jint areaId, jint registerAddress, NSString *registerName, NSString *registerContentDescription, ComStSt25sdkSTRegister_RegisterAccessRights *registerAccessRights, ComStSt25sdkSTRegister_RegisterDataSize *registerDataSize) NS_RETURNS_RETAINED;

FOUNDATION_EXPORT ComStSt25sdkType5St25dvST25DVRegisterEndAi *create_ComStSt25sdkType5St25dvST25DVRegisterEndAi_initWithComStSt25sdkCommandIso15693CustomCommand_withInt_withInt_withNSString_withNSString_withComStSt25sdkSTRegister_RegisterAccessRights_withComStSt25sdkSTRegister_RegisterDataSize_(ComStSt25sdkCommandIso15693CustomCommand *iso15693CustomCommand, jint areaId, jint registerAddress, NSString *registerName, NSString *registerContentDescription, ComStSt25sdkSTRegister_RegisterAccessRights *registerAccessRights, ComStSt25sdkSTRegister_RegisterDataSize *registerDataSize);

J2OBJC_TYPE_LITERAL_HEADER(ComStSt25sdkType5St25dvST25DVRegisterEndAi)

#endif


#if __has_feature(nullability)
#pragma clang diagnostic pop
#endif
#pragma pop_macro("INCLUDE_ALL_ComStSt25sdkType5St25dvST25DVRegisterEndAi")