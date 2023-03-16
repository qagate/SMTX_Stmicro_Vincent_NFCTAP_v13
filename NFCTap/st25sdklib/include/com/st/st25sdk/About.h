//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: st25sdk_ios/About.java
//

#include "J2ObjC_header.h"

#pragma push_macro("INCLUDE_ALL_ComStSt25sdkAbout")
#ifdef RESTRICT_ComStSt25sdkAbout
#define INCLUDE_ALL_ComStSt25sdkAbout 0
#else
#define INCLUDE_ALL_ComStSt25sdkAbout 1
#endif
#undef RESTRICT_ComStSt25sdkAbout

#if __has_feature(nullability)
#pragma clang diagnostic push
#pragma GCC diagnostic ignored "-Wnullability"
#pragma GCC diagnostic ignored "-Wnullability-completeness"
#endif

#if !defined (ComStSt25sdkAbout_) && (INCLUDE_ALL_ComStSt25sdkAbout || defined(INCLUDE_ComStSt25sdkAbout))
#define ComStSt25sdkAbout_

@protocol JavaUtilSet;

@interface ComStSt25sdkAbout : NSObject

#pragma mark Public

- (instancetype __nonnull)init;

+ (id<JavaUtilSet>)getExtraFeatureList;

+ (NSString *)getFullVersion;

+ (jint)getMajorVersionNumber;

+ (jint)getMinorVersionNumber;

+ (jint)getPatchVersionNumber;

@end

J2OBJC_EMPTY_STATIC_INIT(ComStSt25sdkAbout)

FOUNDATION_EXPORT void ComStSt25sdkAbout_init(ComStSt25sdkAbout *self);

FOUNDATION_EXPORT ComStSt25sdkAbout *new_ComStSt25sdkAbout_init(void) NS_RETURNS_RETAINED;

FOUNDATION_EXPORT ComStSt25sdkAbout *create_ComStSt25sdkAbout_init(void);

FOUNDATION_EXPORT NSString *ComStSt25sdkAbout_getFullVersion(void);

FOUNDATION_EXPORT jint ComStSt25sdkAbout_getMajorVersionNumber(void);

FOUNDATION_EXPORT jint ComStSt25sdkAbout_getMinorVersionNumber(void);

FOUNDATION_EXPORT jint ComStSt25sdkAbout_getPatchVersionNumber(void);

FOUNDATION_EXPORT id<JavaUtilSet> ComStSt25sdkAbout_getExtraFeatureList(void);

J2OBJC_TYPE_LITERAL_HEADER(ComStSt25sdkAbout)

#endif


#if __has_feature(nullability)
#pragma clang diagnostic pop
#endif
#pragma pop_macro("INCLUDE_ALL_ComStSt25sdkAbout")