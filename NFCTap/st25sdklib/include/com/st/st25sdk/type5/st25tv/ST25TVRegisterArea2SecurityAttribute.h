//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: st25sdk_ios/type5/st25tv/ST25TVRegisterArea2SecurityAttribute.java
//

#include "J2ObjC_header.h"

#pragma push_macro("INCLUDE_ALL_ComStSt25sdkType5St25tvST25TVRegisterArea2SecurityAttribute")
#ifdef RESTRICT_ComStSt25sdkType5St25tvST25TVRegisterArea2SecurityAttribute
#define INCLUDE_ALL_ComStSt25sdkType5St25tvST25TVRegisterArea2SecurityAttribute 0
#else
#define INCLUDE_ALL_ComStSt25sdkType5St25tvST25TVRegisterArea2SecurityAttribute 1
#endif
#undef RESTRICT_ComStSt25sdkType5St25tvST25TVRegisterArea2SecurityAttribute

#if __has_feature(nullability)
#pragma clang diagnostic push
#pragma GCC diagnostic ignored "-Wnullability"
#pragma GCC diagnostic ignored "-Wnullability-completeness"
#endif

#if !defined (ComStSt25sdkType5St25tvST25TVRegisterArea2SecurityAttribute_) && (INCLUDE_ALL_ComStSt25sdkType5St25tvST25TVRegisterArea2SecurityAttribute || defined(INCLUDE_ComStSt25sdkType5St25tvST25TVRegisterArea2SecurityAttribute))
#define ComStSt25sdkType5St25tvST25TVRegisterArea2SecurityAttribute_

#define RESTRICT_ComStSt25sdkType5STType5Register 1
#define INCLUDE_ComStSt25sdkType5STType5Register 1
#include "com/st/st25sdk/type5/STType5Register.h"

@class ComStSt25sdkCommandIso15693CustomCommand;
@class ComStSt25sdkSTRegister_RegisterAccessRights;
@class ComStSt25sdkSTRegister_RegisterDataSize;
@class ComStSt25sdkTagHelper_ReadWriteProtection;

@interface ComStSt25sdkType5St25tvST25TVRegisterArea2SecurityAttribute : ComStSt25sdkType5STType5Register

#pragma mark Public

- (instancetype __nonnull)initWithComStSt25sdkCommandIso15693CustomCommand:(ComStSt25sdkCommandIso15693CustomCommand *)iso15693CustomCommand
                                                                   withInt:(jint)registerAddress
                                                              withNSString:(NSString *)registerName
                                                              withNSString:(NSString *)registerContentDescription
                           withComStSt25sdkSTRegister_RegisterAccessRights:(ComStSt25sdkSTRegister_RegisterAccessRights *)registerAccessRights
                               withComStSt25sdkSTRegister_RegisterDataSize:(ComStSt25sdkSTRegister_RegisterDataSize *)registerDataSize;

- (ComStSt25sdkTagHelper_ReadWriteProtection *)getArea2SecurityStatus;

+ (ComStSt25sdkType5St25tvST25TVRegisterArea2SecurityAttribute *)newInstanceWithComStSt25sdkCommandIso15693CustomCommand:(ComStSt25sdkCommandIso15693CustomCommand *)iso15693CustomCommand
                                                                                                                 withInt:(jint)registerAddress OBJC_METHOD_FAMILY_NONE;

- (void)setArea2SecurityStatusWithComStSt25sdkTagHelper_ReadWriteProtection:(ComStSt25sdkTagHelper_ReadWriteProtection *)area2ReadWriteProtection;

// Disallowed inherited constructors, do not use.

- (instancetype __nonnull)initWithComStSt25sdkCommandIso15693CustomCommand:(ComStSt25sdkCommandIso15693CustomCommand *)arg0
                                                                   withInt:(jint)arg1
                                                                   withInt:(jint)arg2
                                                              withNSString:(NSString *)arg3
                                                              withNSString:(NSString *)arg4
                           withComStSt25sdkSTRegister_RegisterAccessRights:(ComStSt25sdkSTRegister_RegisterAccessRights *)arg5
                               withComStSt25sdkSTRegister_RegisterDataSize:(ComStSt25sdkSTRegister_RegisterDataSize *)arg6 NS_UNAVAILABLE;

@end

J2OBJC_EMPTY_STATIC_INIT(ComStSt25sdkType5St25tvST25TVRegisterArea2SecurityAttribute)

FOUNDATION_EXPORT ComStSt25sdkType5St25tvST25TVRegisterArea2SecurityAttribute *ComStSt25sdkType5St25tvST25TVRegisterArea2SecurityAttribute_newInstanceWithComStSt25sdkCommandIso15693CustomCommand_withInt_(ComStSt25sdkCommandIso15693CustomCommand *iso15693CustomCommand, jint registerAddress);

FOUNDATION_EXPORT void ComStSt25sdkType5St25tvST25TVRegisterArea2SecurityAttribute_initWithComStSt25sdkCommandIso15693CustomCommand_withInt_withNSString_withNSString_withComStSt25sdkSTRegister_RegisterAccessRights_withComStSt25sdkSTRegister_RegisterDataSize_(ComStSt25sdkType5St25tvST25TVRegisterArea2SecurityAttribute *self, ComStSt25sdkCommandIso15693CustomCommand *iso15693CustomCommand, jint registerAddress, NSString *registerName, NSString *registerContentDescription, ComStSt25sdkSTRegister_RegisterAccessRights *registerAccessRights, ComStSt25sdkSTRegister_RegisterDataSize *registerDataSize);

FOUNDATION_EXPORT ComStSt25sdkType5St25tvST25TVRegisterArea2SecurityAttribute *new_ComStSt25sdkType5St25tvST25TVRegisterArea2SecurityAttribute_initWithComStSt25sdkCommandIso15693CustomCommand_withInt_withNSString_withNSString_withComStSt25sdkSTRegister_RegisterAccessRights_withComStSt25sdkSTRegister_RegisterDataSize_(ComStSt25sdkCommandIso15693CustomCommand *iso15693CustomCommand, jint registerAddress, NSString *registerName, NSString *registerContentDescription, ComStSt25sdkSTRegister_RegisterAccessRights *registerAccessRights, ComStSt25sdkSTRegister_RegisterDataSize *registerDataSize) NS_RETURNS_RETAINED;

FOUNDATION_EXPORT ComStSt25sdkType5St25tvST25TVRegisterArea2SecurityAttribute *create_ComStSt25sdkType5St25tvST25TVRegisterArea2SecurityAttribute_initWithComStSt25sdkCommandIso15693CustomCommand_withInt_withNSString_withNSString_withComStSt25sdkSTRegister_RegisterAccessRights_withComStSt25sdkSTRegister_RegisterDataSize_(ComStSt25sdkCommandIso15693CustomCommand *iso15693CustomCommand, jint registerAddress, NSString *registerName, NSString *registerContentDescription, ComStSt25sdkSTRegister_RegisterAccessRights *registerAccessRights, ComStSt25sdkSTRegister_RegisterDataSize *registerDataSize);

J2OBJC_TYPE_LITERAL_HEADER(ComStSt25sdkType5St25tvST25TVRegisterArea2SecurityAttribute)

#endif


#if __has_feature(nullability)
#pragma clang diagnostic pop
#endif
#pragma pop_macro("INCLUDE_ALL_ComStSt25sdkType5St25tvST25TVRegisterArea2SecurityAttribute")