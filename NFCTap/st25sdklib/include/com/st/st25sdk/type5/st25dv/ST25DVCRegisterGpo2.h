//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: st25sdk_ios/type5/st25dv/ST25DVCRegisterGpo2.java
//

#include "J2ObjC_header.h"

#pragma push_macro("INCLUDE_ALL_ComStSt25sdkType5St25dvST25DVCRegisterGpo2")
#ifdef RESTRICT_ComStSt25sdkType5St25dvST25DVCRegisterGpo2
#define INCLUDE_ALL_ComStSt25sdkType5St25dvST25DVCRegisterGpo2 0
#else
#define INCLUDE_ALL_ComStSt25sdkType5St25dvST25DVCRegisterGpo2 1
#endif
#undef RESTRICT_ComStSt25sdkType5St25dvST25DVCRegisterGpo2

#if __has_feature(nullability)
#pragma clang diagnostic push
#pragma GCC diagnostic ignored "-Wnullability"
#pragma GCC diagnostic ignored "-Wnullability-completeness"
#endif

#if !defined (ComStSt25sdkType5St25dvST25DVCRegisterGpo2_) && (INCLUDE_ALL_ComStSt25sdkType5St25dvST25DVCRegisterGpo2 || defined(INCLUDE_ComStSt25sdkType5St25dvST25DVCRegisterGpo2))
#define ComStSt25sdkType5St25dvST25DVCRegisterGpo2_

#define RESTRICT_ComStSt25sdkType5STType5Register 1
#define INCLUDE_ComStSt25sdkType5STType5Register 1
#include "com/st/st25sdk/type5/STType5Register.h"

@class ComStSt25sdkCommandIso15693CustomCommand;
@class ComStSt25sdkSTRegister_RegisterAccessRights;
@class ComStSt25sdkSTRegister_RegisterDataSize;
@class ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVGPOControl;
@class ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl;

@interface ComStSt25sdkType5St25dvST25DVCRegisterGpo2 : ComStSt25sdkType5STType5Register
@property (readonly, class) jbyte I2C_WRITE_EN_BIT_MASK NS_SWIFT_NAME(I2C_WRITE_EN_BIT_MASK);
@property (readonly, class) jbyte I2C_RF_OFF_EN_BIT_MASK NS_SWIFT_NAME(I2C_RF_OFF_EN_BIT_MASK);
@property (readonly, class) jbyte IT_TIME_BIT_MASK NS_SWIFT_NAME(IT_TIME_BIT_MASK);
@property (readonly, class) jbyte RFU_BIT_MASK NS_SWIFT_NAME(RFU_BIT_MASK);

+ (jbyte)I2C_WRITE_EN_BIT_MASK;

+ (jbyte)I2C_RF_OFF_EN_BIT_MASK;

+ (jbyte)IT_TIME_BIT_MASK;

+ (jbyte)RFU_BIT_MASK;

#pragma mark Public

- (instancetype __nonnull)initWithComStSt25sdkCommandIso15693CustomCommand:(ComStSt25sdkCommandIso15693CustomCommand *)iso15693CustomCommand
                                                                   withInt:(jint)registerAddress
                                                              withNSString:(NSString *)registerName
                                                              withNSString:(NSString *)registerContentDescription
                           withComStSt25sdkSTRegister_RegisterAccessRights:(ComStSt25sdkSTRegister_RegisterAccessRights *)registerAccessRights
                               withComStSt25sdkSTRegister_RegisterDataSize:(ComStSt25sdkSTRegister_RegisterDataSize *)registerDataSize;

- (jboolean)isGPOFieldEnabledWithComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVGPOControl:(ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVGPOControl *)gpoControl;

- (jboolean)isITTimeControlFieldEnabledWithComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl:(ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl *)iTTimeControl;

+ (ComStSt25sdkType5St25dvST25DVCRegisterGpo2 *)newInstanceWithComStSt25sdkCommandIso15693CustomCommand:(ComStSt25sdkCommandIso15693CustomCommand *)iso15693CustomCommand OBJC_METHOD_FAMILY_NONE;

- (void)setGPOWithByte:(jbyte)value
withComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVGPOControl:(ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVGPOControl *)gpoControl
           withBoolean:(jboolean)enable;

- (void)setGPOWithComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVGPOControl:(ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVGPOControl *)gpoControl
                                                                  withBoolean:(jboolean)enable;

- (void)setITTimeControlWithComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl:(ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl *)iTTimeControl;

// Disallowed inherited constructors, do not use.

- (instancetype __nonnull)initWithComStSt25sdkCommandIso15693CustomCommand:(ComStSt25sdkCommandIso15693CustomCommand *)arg0
                                                                   withInt:(jint)arg1
                                                                   withInt:(jint)arg2
                                                              withNSString:(NSString *)arg3
                                                              withNSString:(NSString *)arg4
                           withComStSt25sdkSTRegister_RegisterAccessRights:(ComStSt25sdkSTRegister_RegisterAccessRights *)arg5
                               withComStSt25sdkSTRegister_RegisterDataSize:(ComStSt25sdkSTRegister_RegisterDataSize *)arg6 NS_UNAVAILABLE;

@end

J2OBJC_EMPTY_STATIC_INIT(ComStSt25sdkType5St25dvST25DVCRegisterGpo2)

inline jbyte ComStSt25sdkType5St25dvST25DVCRegisterGpo2_get_I2C_WRITE_EN_BIT_MASK(void);
#define ComStSt25sdkType5St25dvST25DVCRegisterGpo2_I2C_WRITE_EN_BIT_MASK 1
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkType5St25dvST25DVCRegisterGpo2, I2C_WRITE_EN_BIT_MASK, jbyte)

inline jbyte ComStSt25sdkType5St25dvST25DVCRegisterGpo2_get_I2C_RF_OFF_EN_BIT_MASK(void);
#define ComStSt25sdkType5St25dvST25DVCRegisterGpo2_I2C_RF_OFF_EN_BIT_MASK 2
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkType5St25dvST25DVCRegisterGpo2, I2C_RF_OFF_EN_BIT_MASK, jbyte)

inline jbyte ComStSt25sdkType5St25dvST25DVCRegisterGpo2_get_IT_TIME_BIT_MASK(void);
#define ComStSt25sdkType5St25dvST25DVCRegisterGpo2_IT_TIME_BIT_MASK 28
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkType5St25dvST25DVCRegisterGpo2, IT_TIME_BIT_MASK, jbyte)

inline jbyte ComStSt25sdkType5St25dvST25DVCRegisterGpo2_get_RFU_BIT_MASK(void);
#define ComStSt25sdkType5St25dvST25DVCRegisterGpo2_RFU_BIT_MASK -32
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkType5St25dvST25DVCRegisterGpo2, RFU_BIT_MASK, jbyte)

FOUNDATION_EXPORT ComStSt25sdkType5St25dvST25DVCRegisterGpo2 *ComStSt25sdkType5St25dvST25DVCRegisterGpo2_newInstanceWithComStSt25sdkCommandIso15693CustomCommand_(ComStSt25sdkCommandIso15693CustomCommand *iso15693CustomCommand);

FOUNDATION_EXPORT void ComStSt25sdkType5St25dvST25DVCRegisterGpo2_initWithComStSt25sdkCommandIso15693CustomCommand_withInt_withNSString_withNSString_withComStSt25sdkSTRegister_RegisterAccessRights_withComStSt25sdkSTRegister_RegisterDataSize_(ComStSt25sdkType5St25dvST25DVCRegisterGpo2 *self, ComStSt25sdkCommandIso15693CustomCommand *iso15693CustomCommand, jint registerAddress, NSString *registerName, NSString *registerContentDescription, ComStSt25sdkSTRegister_RegisterAccessRights *registerAccessRights, ComStSt25sdkSTRegister_RegisterDataSize *registerDataSize);

FOUNDATION_EXPORT ComStSt25sdkType5St25dvST25DVCRegisterGpo2 *new_ComStSt25sdkType5St25dvST25DVCRegisterGpo2_initWithComStSt25sdkCommandIso15693CustomCommand_withInt_withNSString_withNSString_withComStSt25sdkSTRegister_RegisterAccessRights_withComStSt25sdkSTRegister_RegisterDataSize_(ComStSt25sdkCommandIso15693CustomCommand *iso15693CustomCommand, jint registerAddress, NSString *registerName, NSString *registerContentDescription, ComStSt25sdkSTRegister_RegisterAccessRights *registerAccessRights, ComStSt25sdkSTRegister_RegisterDataSize *registerDataSize) NS_RETURNS_RETAINED;

FOUNDATION_EXPORT ComStSt25sdkType5St25dvST25DVCRegisterGpo2 *create_ComStSt25sdkType5St25dvST25DVCRegisterGpo2_initWithComStSt25sdkCommandIso15693CustomCommand_withInt_withNSString_withNSString_withComStSt25sdkSTRegister_RegisterAccessRights_withComStSt25sdkSTRegister_RegisterDataSize_(ComStSt25sdkCommandIso15693CustomCommand *iso15693CustomCommand, jint registerAddress, NSString *registerName, NSString *registerContentDescription, ComStSt25sdkSTRegister_RegisterAccessRights *registerAccessRights, ComStSt25sdkSTRegister_RegisterDataSize *registerDataSize);

J2OBJC_TYPE_LITERAL_HEADER(ComStSt25sdkType5St25dvST25DVCRegisterGpo2)

#endif

#if !defined (ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVGPOControl_) && (INCLUDE_ALL_ComStSt25sdkType5St25dvST25DVCRegisterGpo2 || defined(INCLUDE_ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVGPOControl))
#define ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVGPOControl_

#define RESTRICT_JavaLangEnum 1
#define INCLUDE_JavaLangEnum 1
#include "java/lang/Enum.h"

@class IOSObjectArray;

typedef NS_ENUM(NSUInteger, ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVGPOControl_Enum) {
  ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVGPOControl_Enum_I2C_WRITE_EN = 0,
  ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVGPOControl_Enum_I2C_RF_OFF_EN = 1,
  ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVGPOControl_Enum_IT_TIME = 2,
};

@interface ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVGPOControl : JavaLangEnum

@property (readonly, class, nonnull) ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVGPOControl *I2C_WRITE_EN NS_SWIFT_NAME(I2C_WRITE_EN);
@property (readonly, class, nonnull) ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVGPOControl *I2C_RF_OFF_EN NS_SWIFT_NAME(I2C_RF_OFF_EN);
@property (readonly, class, nonnull) ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVGPOControl *IT_TIME NS_SWIFT_NAME(IT_TIME);
+ (ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVGPOControl * __nonnull)I2C_WRITE_EN;

+ (ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVGPOControl * __nonnull)I2C_RF_OFF_EN;

+ (ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVGPOControl * __nonnull)IT_TIME;

#pragma mark Public

+ (ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVGPOControl *)valueOfWithNSString:(NSString *)name;

+ (IOSObjectArray *)values;

#pragma mark Package-Private

- (ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVGPOControl_Enum)toNSEnum;

@end

J2OBJC_STATIC_INIT(ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVGPOControl)

/*! INTERNAL ONLY - Use enum accessors declared below. */
FOUNDATION_EXPORT ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVGPOControl *ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVGPOControl_values_[];

inline ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVGPOControl *ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVGPOControl_get_I2C_WRITE_EN(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVGPOControl, I2C_WRITE_EN)

inline ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVGPOControl *ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVGPOControl_get_I2C_RF_OFF_EN(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVGPOControl, I2C_RF_OFF_EN)

inline ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVGPOControl *ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVGPOControl_get_IT_TIME(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVGPOControl, IT_TIME)

FOUNDATION_EXPORT IOSObjectArray *ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVGPOControl_values(void);

FOUNDATION_EXPORT ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVGPOControl *ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVGPOControl_valueOfWithNSString_(NSString *name);

FOUNDATION_EXPORT ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVGPOControl *ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVGPOControl_fromOrdinal(NSUInteger ordinal);

J2OBJC_TYPE_LITERAL_HEADER(ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVGPOControl)

#endif

#if !defined (ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl_) && (INCLUDE_ALL_ComStSt25sdkType5St25dvST25DVCRegisterGpo2 || defined(INCLUDE_ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl))
#define ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl_

#define RESTRICT_JavaLangEnum 1
#define INCLUDE_JavaLangEnum 1
#include "java/lang/Enum.h"

@class IOSObjectArray;

typedef NS_ENUM(NSUInteger, ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl_Enum) {
  ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl_Enum_ITIME_000 = 0,
  ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl_Enum_ITIME_001 = 1,
  ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl_Enum_ITIME_010 = 2,
  ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl_Enum_ITIME_011 = 3,
  ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl_Enum_ITIME_100 = 4,
  ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl_Enum_ITIME_101 = 5,
  ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl_Enum_ITIME_110 = 6,
  ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl_Enum_ITIME_111 = 7,
};

@interface ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl : JavaLangEnum

@property (readonly, class, nonnull) ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl *ITIME_000 NS_SWIFT_NAME(ITIME_000);
@property (readonly, class, nonnull) ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl *ITIME_001 NS_SWIFT_NAME(ITIME_001);
@property (readonly, class, nonnull) ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl *ITIME_010 NS_SWIFT_NAME(ITIME_010);
@property (readonly, class, nonnull) ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl *ITIME_011 NS_SWIFT_NAME(ITIME_011);
@property (readonly, class, nonnull) ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl *ITIME_100 NS_SWIFT_NAME(ITIME_100);
@property (readonly, class, nonnull) ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl *ITIME_101 NS_SWIFT_NAME(ITIME_101);
@property (readonly, class, nonnull) ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl *ITIME_110 NS_SWIFT_NAME(ITIME_110);
@property (readonly, class, nonnull) ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl *ITIME_111 NS_SWIFT_NAME(ITIME_111);
+ (ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl * __nonnull)ITIME_000;

+ (ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl * __nonnull)ITIME_001;

+ (ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl * __nonnull)ITIME_010;

+ (ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl * __nonnull)ITIME_011;

+ (ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl * __nonnull)ITIME_100;

+ (ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl * __nonnull)ITIME_101;

+ (ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl * __nonnull)ITIME_110;

+ (ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl * __nonnull)ITIME_111;

#pragma mark Public

+ (ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl *)valueOfWithNSString:(NSString *)name;

+ (IOSObjectArray *)values;

#pragma mark Package-Private

- (ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl_Enum)toNSEnum;

@end

J2OBJC_STATIC_INIT(ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl)

/*! INTERNAL ONLY - Use enum accessors declared below. */
FOUNDATION_EXPORT ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl *ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl_values_[];

inline ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl *ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl_get_ITIME_000(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl, ITIME_000)

inline ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl *ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl_get_ITIME_001(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl, ITIME_001)

inline ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl *ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl_get_ITIME_010(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl, ITIME_010)

inline ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl *ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl_get_ITIME_011(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl, ITIME_011)

inline ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl *ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl_get_ITIME_100(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl, ITIME_100)

inline ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl *ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl_get_ITIME_101(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl, ITIME_101)

inline ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl *ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl_get_ITIME_110(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl, ITIME_110)

inline ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl *ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl_get_ITIME_111(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl, ITIME_111)

FOUNDATION_EXPORT IOSObjectArray *ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl_values(void);

FOUNDATION_EXPORT ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl *ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl_valueOfWithNSString_(NSString *name);

FOUNDATION_EXPORT ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl *ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl_fromOrdinal(NSUInteger ordinal);

J2OBJC_TYPE_LITERAL_HEADER(ComStSt25sdkType5St25dvST25DVCRegisterGpo2_ST25DVITTimeControl)

#endif


#if __has_feature(nullability)
#pragma clang diagnostic pop
#endif
#pragma pop_macro("INCLUDE_ALL_ComStSt25sdkType5St25dvST25DVCRegisterGpo2")
