//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: st25sdk_ios/ndef/HandoverCarrierRecord.java
//

#include "J2ObjC_header.h"

#pragma push_macro("INCLUDE_ALL_ComStSt25sdkNdefHandoverCarrierRecord")
#ifdef RESTRICT_ComStSt25sdkNdefHandoverCarrierRecord
#define INCLUDE_ALL_ComStSt25sdkNdefHandoverCarrierRecord 0
#else
#define INCLUDE_ALL_ComStSt25sdkNdefHandoverCarrierRecord 1
#endif
#undef RESTRICT_ComStSt25sdkNdefHandoverCarrierRecord

#if __has_feature(nullability)
#pragma clang diagnostic push
#pragma GCC diagnostic ignored "-Wnullability"
#pragma GCC diagnostic ignored "-Wnullability-completeness"
#endif

#if !defined (ComStSt25sdkNdefHandoverCarrierRecord_) && (INCLUDE_ALL_ComStSt25sdkNdefHandoverCarrierRecord || defined(INCLUDE_ComStSt25sdkNdefHandoverCarrierRecord))
#define ComStSt25sdkNdefHandoverCarrierRecord_

#define RESTRICT_ComStSt25sdkNdefNDEFRecord 1
#define INCLUDE_ComStSt25sdkNdefNDEFRecord 1
#include "com/st/st25sdk/ndef/NDEFRecord.h"

@class IOSByteArray;
@class JavaIoByteArrayInputStream;

@interface ComStSt25sdkNdefHandoverCarrierRecord : ComStSt25sdkNdefNDEFRecord

#pragma mark Public

- (instancetype __nonnull)initWithByte:(jbyte)carrierTypeFormat
                         withByteArray:(IOSByteArray *)carrierType
                         withByteArray:(IOSByteArray *)carrierData;

- (instancetype __nonnull)initWithJavaIoByteArrayInputStream:(JavaIoByteArrayInputStream *)inputStream;

- (IOSByteArray *)getCarrierData;

- (IOSByteArray *)getCarrierType;

- (jbyte)getCarrierTypeFormat;

- (jbyte)getCarrierTypeLength;

- (IOSByteArray *)getPayload;

- (void)setCarrierTypeWithByteArray:(IOSByteArray *)carrierType;

- (NSString *)description;

// Disallowed inherited constructors, do not use.

- (instancetype __nonnull)init NS_UNAVAILABLE;

- (instancetype __nonnull)initWithByteArray:(IOSByteArray *)arg0 NS_UNAVAILABLE;

- (instancetype __nonnull)initWithComStSt25sdkNdefNDEFRecord:(ComStSt25sdkNdefNDEFRecord *)arg0 NS_UNAVAILABLE;

@end

J2OBJC_STATIC_INIT(ComStSt25sdkNdefHandoverCarrierRecord)

FOUNDATION_EXPORT void ComStSt25sdkNdefHandoverCarrierRecord_initWithByte_withByteArray_withByteArray_(ComStSt25sdkNdefHandoverCarrierRecord *self, jbyte carrierTypeFormat, IOSByteArray *carrierType, IOSByteArray *carrierData);

FOUNDATION_EXPORT ComStSt25sdkNdefHandoverCarrierRecord *new_ComStSt25sdkNdefHandoverCarrierRecord_initWithByte_withByteArray_withByteArray_(jbyte carrierTypeFormat, IOSByteArray *carrierType, IOSByteArray *carrierData) NS_RETURNS_RETAINED;

FOUNDATION_EXPORT ComStSt25sdkNdefHandoverCarrierRecord *create_ComStSt25sdkNdefHandoverCarrierRecord_initWithByte_withByteArray_withByteArray_(jbyte carrierTypeFormat, IOSByteArray *carrierType, IOSByteArray *carrierData);

FOUNDATION_EXPORT void ComStSt25sdkNdefHandoverCarrierRecord_initWithJavaIoByteArrayInputStream_(ComStSt25sdkNdefHandoverCarrierRecord *self, JavaIoByteArrayInputStream *inputStream);

FOUNDATION_EXPORT ComStSt25sdkNdefHandoverCarrierRecord *new_ComStSt25sdkNdefHandoverCarrierRecord_initWithJavaIoByteArrayInputStream_(JavaIoByteArrayInputStream *inputStream) NS_RETURNS_RETAINED;

FOUNDATION_EXPORT ComStSt25sdkNdefHandoverCarrierRecord *create_ComStSt25sdkNdefHandoverCarrierRecord_initWithJavaIoByteArrayInputStream_(JavaIoByteArrayInputStream *inputStream);

J2OBJC_TYPE_LITERAL_HEADER(ComStSt25sdkNdefHandoverCarrierRecord)

#endif


#if __has_feature(nullability)
#pragma clang diagnostic pop
#endif
#pragma pop_macro("INCLUDE_ALL_ComStSt25sdkNdefHandoverCarrierRecord")
