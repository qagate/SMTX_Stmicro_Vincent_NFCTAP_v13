//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: st25sdk_ios/TagCache.java
//

#include "J2ObjC_header.h"

#pragma push_macro("INCLUDE_ALL_ComStSt25sdkTagCache")
#ifdef RESTRICT_ComStSt25sdkTagCache
#define INCLUDE_ALL_ComStSt25sdkTagCache 0
#else
#define INCLUDE_ALL_ComStSt25sdkTagCache 1
#endif
#undef RESTRICT_ComStSt25sdkTagCache

#if __has_feature(nullability)
#pragma clang diagnostic push
#pragma GCC diagnostic ignored "-Wnullability"
#pragma GCC diagnostic ignored "-Wnullability-completeness"
#endif

#if !defined (ComStSt25sdkTagCache_) && (INCLUDE_ALL_ComStSt25sdkTagCache || defined(INCLUDE_ComStSt25sdkTagCache))
#define ComStSt25sdkTagCache_

@interface ComStSt25sdkTagCache : NSObject
@property (class) jboolean DBG_CACHE_MANAGER NS_SWIFT_NAME(DBG_CACHE_MANAGER);

+ (jboolean)DBG_CACHE_MANAGER;

+ (void)setDBG_CACHE_MANAGER:(jboolean)value;

#pragma mark Public

- (instancetype __nonnull)init;

- (void)activateCache;

- (void)activateCacheWithId:(id)obj;

- (void)addWithId:(id)obj;

- (jboolean)containsWithId:(id)obj;

- (void)deactivateCache;

- (void)deactivateCacheWithId:(id)obj;

- (void)invalidateCache;

- (void)invalidateCacheWithId:(id)obj;

- (jboolean)isCacheActivated;

- (jboolean)isCacheActivatedWithId:(id)obj;

- (jboolean)isCacheValid;

- (jboolean)isCacheValidWithId:(id)obj;

- (void)removeWithId:(id)obj;

- (void)updateCache;

- (void)validateCache;

- (void)validateCacheWithId:(id)obj;

@end

J2OBJC_EMPTY_STATIC_INIT(ComStSt25sdkTagCache)

inline jboolean ComStSt25sdkTagCache_get_DBG_CACHE_MANAGER(void);
inline jboolean ComStSt25sdkTagCache_set_DBG_CACHE_MANAGER(jboolean value);
inline jboolean *ComStSt25sdkTagCache_getRef_DBG_CACHE_MANAGER(void);
/*! INTERNAL ONLY - Use accessor function from above. */
FOUNDATION_EXPORT jboolean ComStSt25sdkTagCache_DBG_CACHE_MANAGER;
J2OBJC_STATIC_FIELD_PRIMITIVE(ComStSt25sdkTagCache, DBG_CACHE_MANAGER, jboolean)

FOUNDATION_EXPORT void ComStSt25sdkTagCache_init(ComStSt25sdkTagCache *self);

FOUNDATION_EXPORT ComStSt25sdkTagCache *new_ComStSt25sdkTagCache_init(void) NS_RETURNS_RETAINED;

FOUNDATION_EXPORT ComStSt25sdkTagCache *create_ComStSt25sdkTagCache_init(void);

J2OBJC_TYPE_LITERAL_HEADER(ComStSt25sdkTagCache)

#endif


#if __has_feature(nullability)
#pragma clang diagnostic pop
#endif
#pragma pop_macro("INCLUDE_ALL_ComStSt25sdkTagCache")