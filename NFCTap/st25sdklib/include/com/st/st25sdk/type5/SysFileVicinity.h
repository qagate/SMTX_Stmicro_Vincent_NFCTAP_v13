//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: st25sdk_ios/type5/SysFileVicinity.java
//

#include "J2ObjC_header.h"

#pragma push_macro("INCLUDE_ALL_ComStSt25sdkType5SysFileVicinity")
#ifdef RESTRICT_ComStSt25sdkType5SysFileVicinity
#define INCLUDE_ALL_ComStSt25sdkType5SysFileVicinity 0
#else
#define INCLUDE_ALL_ComStSt25sdkType5SysFileVicinity 1
#endif
#undef RESTRICT_ComStSt25sdkType5SysFileVicinity

#if __has_feature(nullability)
#pragma clang diagnostic push
#pragma GCC diagnostic ignored "-Wnullability"
#pragma GCC diagnostic ignored "-Wnullability-completeness"
#endif

#if !defined (ComStSt25sdkType5SysFileVicinity_) && (INCLUDE_ALL_ComStSt25sdkType5SysFileVicinity || defined(INCLUDE_ComStSt25sdkType5SysFileVicinity))
#define ComStSt25sdkType5SysFileVicinity_

#define RESTRICT_ComStSt25sdkType5SysFile 1
#define INCLUDE_ComStSt25sdkType5SysFile 1
#include "com/st/st25sdk/type5/SysFile.h"

@class ComStSt25sdkCommandVicinityCommand;
@class IOSByteArray;

@interface ComStSt25sdkType5SysFileVicinity : ComStSt25sdkType5SysFile

#pragma mark Public

- (instancetype __nonnull)initWithComStSt25sdkCommandVicinityCommand:(ComStSt25sdkCommandVicinityCommand *)vicinityCommand;

- (IOSByteArray *)read;

#pragma mark Protected

- (void)parseSysFileWithByteArray:(IOSByteArray *)buffer;

// Disallowed inherited constructors, do not use.

- (instancetype __nonnull)init NS_UNAVAILABLE;

@end

J2OBJC_EMPTY_STATIC_INIT(ComStSt25sdkType5SysFileVicinity)

FOUNDATION_EXPORT void ComStSt25sdkType5SysFileVicinity_initWithComStSt25sdkCommandVicinityCommand_(ComStSt25sdkType5SysFileVicinity *self, ComStSt25sdkCommandVicinityCommand *vicinityCommand);

FOUNDATION_EXPORT ComStSt25sdkType5SysFileVicinity *new_ComStSt25sdkType5SysFileVicinity_initWithComStSt25sdkCommandVicinityCommand_(ComStSt25sdkCommandVicinityCommand *vicinityCommand) NS_RETURNS_RETAINED;

FOUNDATION_EXPORT ComStSt25sdkType5SysFileVicinity *create_ComStSt25sdkType5SysFileVicinity_initWithComStSt25sdkCommandVicinityCommand_(ComStSt25sdkCommandVicinityCommand *vicinityCommand);

J2OBJC_TYPE_LITERAL_HEADER(ComStSt25sdkType5SysFileVicinity)

#endif


#if __has_feature(nullability)
#pragma clang diagnostic pop
#endif
#pragma pop_macro("INCLUDE_ALL_ComStSt25sdkType5SysFileVicinity")
