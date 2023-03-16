//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: st25sdk_ios/type5/st25dv/ST25DVRegisterMailboxWatchdog.java
//

#include "J2ObjC_header.h"

#pragma push_macro("INCLUDE_ALL_ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog")
#ifdef RESTRICT_ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog
#define INCLUDE_ALL_ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog 0
#else
#define INCLUDE_ALL_ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog 1
#endif
#undef RESTRICT_ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog

#if __has_feature(nullability)
#pragma clang diagnostic push
#pragma GCC diagnostic ignored "-Wnullability"
#pragma GCC diagnostic ignored "-Wnullability-completeness"
#endif

#if !defined (ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog_) && (INCLUDE_ALL_ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog || defined(INCLUDE_ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog))
#define ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog_

#define RESTRICT_ComStSt25sdkType5STType5Register 1
#define INCLUDE_ComStSt25sdkType5STType5Register 1
#include "com/st/st25sdk/type5/STType5Register.h"

@class ComStSt25sdkCommandIso15693CustomCommand;
@class ComStSt25sdkSTRegister_RegisterAccessRights;
@class ComStSt25sdkSTRegister_RegisterDataSize;

@interface ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog : ComStSt25sdkType5STType5Register
@property (readonly, class) jbyte MB_WDG_BIT_MASK NS_SWIFT_NAME(MB_WDG_BIT_MASK);
@property (readonly, class) jbyte RFU_BIT_MASK NS_SWIFT_NAME(RFU_BIT_MASK);

+ (jbyte)MB_WDG_BIT_MASK;

+ (jbyte)RFU_BIT_MASK;

#pragma mark Public

- (instancetype __nonnull)initWithComStSt25sdkCommandIso15693CustomCommand:(ComStSt25sdkCommandIso15693CustomCommand *)iso15693CustomCommand
                                                                   withInt:(jint)registerAddress
                                                              withNSString:(NSString *)registerName
                                                              withNSString:(NSString *)registerContentDescription
                           withComStSt25sdkSTRegister_RegisterAccessRights:(ComStSt25sdkSTRegister_RegisterAccessRights *)registerAccessRights
                               withComStSt25sdkSTRegister_RegisterDataSize:(ComStSt25sdkSTRegister_RegisterDataSize *)registerDataSize;

- (jbyte)getMailboxWatchdog;

+ (ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog *)newInstanceWithComStSt25sdkCommandIso15693CustomCommand:(ComStSt25sdkCommandIso15693CustomCommand *)iso15693CustomCommand OBJC_METHOD_FAMILY_NONE;

- (void)setMailboxWatchdogWithByte:(jbyte)value;

// Disallowed inherited constructors, do not use.

- (instancetype __nonnull)initWithComStSt25sdkCommandIso15693CustomCommand:(ComStSt25sdkCommandIso15693CustomCommand *)arg0
                                                                   withInt:(jint)arg1
                                                                   withInt:(jint)arg2
                                                              withNSString:(NSString *)arg3
                                                              withNSString:(NSString *)arg4
                           withComStSt25sdkSTRegister_RegisterAccessRights:(ComStSt25sdkSTRegister_RegisterAccessRights *)arg5
                               withComStSt25sdkSTRegister_RegisterDataSize:(ComStSt25sdkSTRegister_RegisterDataSize *)arg6 NS_UNAVAILABLE;

@end

J2OBJC_EMPTY_STATIC_INIT(ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog)

inline jbyte ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog_get_MB_WDG_BIT_MASK(void);
#define ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog_MB_WDG_BIT_MASK 7
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog, MB_WDG_BIT_MASK, jbyte)

inline jbyte ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog_get_RFU_BIT_MASK(void);
#define ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog_RFU_BIT_MASK -8
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog, RFU_BIT_MASK, jbyte)

FOUNDATION_EXPORT ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog *ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog_newInstanceWithComStSt25sdkCommandIso15693CustomCommand_(ComStSt25sdkCommandIso15693CustomCommand *iso15693CustomCommand);

FOUNDATION_EXPORT void ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog_initWithComStSt25sdkCommandIso15693CustomCommand_withInt_withNSString_withNSString_withComStSt25sdkSTRegister_RegisterAccessRights_withComStSt25sdkSTRegister_RegisterDataSize_(ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog *self, ComStSt25sdkCommandIso15693CustomCommand *iso15693CustomCommand, jint registerAddress, NSString *registerName, NSString *registerContentDescription, ComStSt25sdkSTRegister_RegisterAccessRights *registerAccessRights, ComStSt25sdkSTRegister_RegisterDataSize *registerDataSize);

FOUNDATION_EXPORT ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog *new_ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog_initWithComStSt25sdkCommandIso15693CustomCommand_withInt_withNSString_withNSString_withComStSt25sdkSTRegister_RegisterAccessRights_withComStSt25sdkSTRegister_RegisterDataSize_(ComStSt25sdkCommandIso15693CustomCommand *iso15693CustomCommand, jint registerAddress, NSString *registerName, NSString *registerContentDescription, ComStSt25sdkSTRegister_RegisterAccessRights *registerAccessRights, ComStSt25sdkSTRegister_RegisterDataSize *registerDataSize) NS_RETURNS_RETAINED;

FOUNDATION_EXPORT ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog *create_ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog_initWithComStSt25sdkCommandIso15693CustomCommand_withInt_withNSString_withNSString_withComStSt25sdkSTRegister_RegisterAccessRights_withComStSt25sdkSTRegister_RegisterDataSize_(ComStSt25sdkCommandIso15693CustomCommand *iso15693CustomCommand, jint registerAddress, NSString *registerName, NSString *registerContentDescription, ComStSt25sdkSTRegister_RegisterAccessRights *registerAccessRights, ComStSt25sdkSTRegister_RegisterDataSize *registerDataSize);

J2OBJC_TYPE_LITERAL_HEADER(ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog)

#endif

#if !defined (ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog_ST25DVRegisterMailboxWatchdogControl_) && (INCLUDE_ALL_ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog || defined(INCLUDE_ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog_ST25DVRegisterMailboxWatchdogControl))
#define ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog_ST25DVRegisterMailboxWatchdogControl_

#define RESTRICT_JavaLangEnum 1
#define INCLUDE_JavaLangEnum 1
#include "java/lang/Enum.h"

@class IOSObjectArray;

typedef NS_ENUM(NSUInteger, ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog_ST25DVRegisterMailboxWatchdogControl_Enum) {
  ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog_ST25DVRegisterMailboxWatchdogControl_Enum_MB_WDG = 0,
  ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog_ST25DVRegisterMailboxWatchdogControl_Enum_RFU = 1,
};

@interface ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog_ST25DVRegisterMailboxWatchdogControl : JavaLangEnum

@property (readonly, class, nonnull) ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog_ST25DVRegisterMailboxWatchdogControl *MB_WDG NS_SWIFT_NAME(MB_WDG);
@property (readonly, class, nonnull) ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog_ST25DVRegisterMailboxWatchdogControl *RFU NS_SWIFT_NAME(RFU);
+ (ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog_ST25DVRegisterMailboxWatchdogControl * __nonnull)MB_WDG;

+ (ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog_ST25DVRegisterMailboxWatchdogControl * __nonnull)RFU;

#pragma mark Public

+ (ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog_ST25DVRegisterMailboxWatchdogControl *)valueOfWithNSString:(NSString *)name;

+ (IOSObjectArray *)values;

#pragma mark Package-Private

- (ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog_ST25DVRegisterMailboxWatchdogControl_Enum)toNSEnum;

@end

J2OBJC_STATIC_INIT(ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog_ST25DVRegisterMailboxWatchdogControl)

/*! INTERNAL ONLY - Use enum accessors declared below. */
FOUNDATION_EXPORT ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog_ST25DVRegisterMailboxWatchdogControl *ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog_ST25DVRegisterMailboxWatchdogControl_values_[];

inline ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog_ST25DVRegisterMailboxWatchdogControl *ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog_ST25DVRegisterMailboxWatchdogControl_get_MB_WDG(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog_ST25DVRegisterMailboxWatchdogControl, MB_WDG)

inline ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog_ST25DVRegisterMailboxWatchdogControl *ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog_ST25DVRegisterMailboxWatchdogControl_get_RFU(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog_ST25DVRegisterMailboxWatchdogControl, RFU)

FOUNDATION_EXPORT IOSObjectArray *ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog_ST25DVRegisterMailboxWatchdogControl_values(void);

FOUNDATION_EXPORT ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog_ST25DVRegisterMailboxWatchdogControl *ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog_ST25DVRegisterMailboxWatchdogControl_valueOfWithNSString_(NSString *name);

FOUNDATION_EXPORT ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog_ST25DVRegisterMailboxWatchdogControl *ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog_ST25DVRegisterMailboxWatchdogControl_fromOrdinal(NSUInteger ordinal);

J2OBJC_TYPE_LITERAL_HEADER(ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog_ST25DVRegisterMailboxWatchdogControl)

#endif


#if __has_feature(nullability)
#pragma clang diagnostic pop
#endif
#pragma pop_macro("INCLUDE_ALL_ComStSt25sdkType5St25dvST25DVRegisterMailboxWatchdog")