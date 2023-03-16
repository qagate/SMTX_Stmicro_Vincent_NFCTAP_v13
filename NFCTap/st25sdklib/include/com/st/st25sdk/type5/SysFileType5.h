//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: st25sdk_ios/type5/SysFileType5.java
//

#include "J2ObjC_header.h"

#pragma push_macro("INCLUDE_ALL_ComStSt25sdkType5SysFileType5")
#ifdef RESTRICT_ComStSt25sdkType5SysFileType5
#define INCLUDE_ALL_ComStSt25sdkType5SysFileType5 0
#else
#define INCLUDE_ALL_ComStSt25sdkType5SysFileType5 1
#endif
#undef RESTRICT_ComStSt25sdkType5SysFileType5

#if __has_feature(nullability)
#pragma clang diagnostic push
#pragma GCC diagnostic ignored "-Wnullability"
#pragma GCC diagnostic ignored "-Wnullability-completeness"
#endif

#if !defined (ComStSt25sdkType5SysFileType5_) && (INCLUDE_ALL_ComStSt25sdkType5SysFileType5 || defined(INCLUDE_ComStSt25sdkType5SysFileType5))
#define ComStSt25sdkType5SysFileType5_

#define RESTRICT_ComStSt25sdkType5SysFile 1
#define INCLUDE_ComStSt25sdkType5SysFile 1
#include "com/st/st25sdk/type5/SysFile.h"

@class ComStSt25sdkCommandIso15693Command;
@class IOSByteArray;

@interface ComStSt25sdkType5SysFileType5 : ComStSt25sdkType5SysFile {
 @public
  ComStSt25sdkCommandIso15693Command *mIso15693Command_;
  jboolean mVICCCommandListSupported_;
  jboolean m2ByteAddressing_;
  IOSByteArray *mVICCCommandList_;
}
@property (readonly, class) jbyte MOI_VALUE NS_SWIFT_NAME(MOI_VALUE);
@property (readonly, class) jbyte VICC_CMD_LIST_MASK NS_SWIFT_NAME(VICC_CMD_LIST_MASK);

+ (jbyte)MOI_VALUE;

+ (jbyte)VICC_CMD_LIST_MASK;

#pragma mark Public

- (instancetype __nonnull)initWithComStSt25sdkCommandIso15693Command:(ComStSt25sdkCommandIso15693Command *)iso15693Command;

- (jboolean)getMOI;

- (IOSByteArray *)getVICCCommandList;

- (IOSByteArray *)read;

// Disallowed inherited constructors, do not use.

- (instancetype __nonnull)init NS_UNAVAILABLE;

@end

J2OBJC_EMPTY_STATIC_INIT(ComStSt25sdkType5SysFileType5)

J2OBJC_FIELD_SETTER(ComStSt25sdkType5SysFileType5, mIso15693Command_, ComStSt25sdkCommandIso15693Command *)
J2OBJC_FIELD_SETTER(ComStSt25sdkType5SysFileType5, mVICCCommandList_, IOSByteArray *)

inline jbyte ComStSt25sdkType5SysFileType5_get_MOI_VALUE(void);
#define ComStSt25sdkType5SysFileType5_MOI_VALUE 16
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkType5SysFileType5, MOI_VALUE, jbyte)

inline jbyte ComStSt25sdkType5SysFileType5_get_VICC_CMD_LIST_MASK(void);
#define ComStSt25sdkType5SysFileType5_VICC_CMD_LIST_MASK 32
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkType5SysFileType5, VICC_CMD_LIST_MASK, jbyte)

FOUNDATION_EXPORT void ComStSt25sdkType5SysFileType5_initWithComStSt25sdkCommandIso15693Command_(ComStSt25sdkType5SysFileType5 *self, ComStSt25sdkCommandIso15693Command *iso15693Command);

FOUNDATION_EXPORT ComStSt25sdkType5SysFileType5 *new_ComStSt25sdkType5SysFileType5_initWithComStSt25sdkCommandIso15693Command_(ComStSt25sdkCommandIso15693Command *iso15693Command) NS_RETURNS_RETAINED;

FOUNDATION_EXPORT ComStSt25sdkType5SysFileType5 *create_ComStSt25sdkType5SysFileType5_initWithComStSt25sdkCommandIso15693Command_(ComStSt25sdkCommandIso15693Command *iso15693Command);

J2OBJC_TYPE_LITERAL_HEADER(ComStSt25sdkType5SysFileType5)

#endif


#if __has_feature(nullability)
#pragma clang diagnostic pop
#endif
#pragma pop_macro("INCLUDE_ALL_ComStSt25sdkType5SysFileType5")
