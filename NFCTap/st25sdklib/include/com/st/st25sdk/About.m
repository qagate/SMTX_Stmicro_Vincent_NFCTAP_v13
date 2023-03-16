//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: st25sdk_ios/About.java
//

#include "IOSClass.h"
#include "IOSObjectArray.h"
#include "J2ObjC_source.h"
#include "com/st/st25sdk/About.h"
#include "com/st/st25sdk/type5/st25tv/ST25TVTag.h"
#include "com/st/st25sdk/type5/st25tvc/ST25TVCTag.h"
#include "java/lang/ClassNotFoundException.h"
#include "java/util/Arrays.h"
#include "java/util/Collections.h"
#include "java/util/List.h"
#include "java/util/Set.h"
#include "java/util/TreeSet.h"

@interface ComStSt25sdkAbout ()

+ (id<JavaUtilList>)getTVFeatureList;

+ (id<JavaUtilList>)getSt25tvcExtraFeatureList;

+ (id<JavaUtilList>)getSignatureFeature;

@end

inline jint ComStSt25sdkAbout_get_ST25SDK_LIB_MAJOR_NUMBER(void);
#define ComStSt25sdkAbout_ST25SDK_LIB_MAJOR_NUMBER 1
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkAbout, ST25SDK_LIB_MAJOR_NUMBER, jint)

inline jint ComStSt25sdkAbout_get_ST25SDK_LIB_MINOR_NUMBER(void);
#define ComStSt25sdkAbout_ST25SDK_LIB_MINOR_NUMBER 10
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkAbout, ST25SDK_LIB_MINOR_NUMBER, jint)

inline jint ComStSt25sdkAbout_get_ST25SDK_LIB_PATCH_NUMBER(void);
#define ComStSt25sdkAbout_ST25SDK_LIB_PATCH_NUMBER 0
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkAbout, ST25SDK_LIB_PATCH_NUMBER, jint)

inline NSString *ComStSt25sdkAbout_get_ST25SDK_LIB_VERSION(void);
static NSString *ComStSt25sdkAbout_ST25SDK_LIB_VERSION = @"1.10.0";
J2OBJC_STATIC_FIELD_OBJ_FINAL(ComStSt25sdkAbout, ST25SDK_LIB_VERSION, NSString *)

__attribute__((unused)) static id<JavaUtilList> ComStSt25sdkAbout_getTVFeatureList(void);

__attribute__((unused)) static id<JavaUtilList> ComStSt25sdkAbout_getSt25tvcExtraFeatureList(void);

__attribute__((unused)) static id<JavaUtilList> ComStSt25sdkAbout_getSignatureFeature(void);

@implementation ComStSt25sdkAbout

J2OBJC_IGNORE_DESIGNATED_BEGIN
- (instancetype)init {
  ComStSt25sdkAbout_init(self);
  return self;
}
J2OBJC_IGNORE_DESIGNATED_END

+ (NSString *)getFullVersion {
  return ComStSt25sdkAbout_getFullVersion();
}

+ (jint)getMajorVersionNumber {
  return ComStSt25sdkAbout_getMajorVersionNumber();
}

+ (jint)getMinorVersionNumber {
  return ComStSt25sdkAbout_getMinorVersionNumber();
}

+ (jint)getPatchVersionNumber {
  return ComStSt25sdkAbout_getPatchVersionNumber();
}

+ (id<JavaUtilSet>)getExtraFeatureList {
  return ComStSt25sdkAbout_getExtraFeatureList();
}

+ (id<JavaUtilList>)getTVFeatureList {
  return ComStSt25sdkAbout_getTVFeatureList();
}

+ (id<JavaUtilList>)getSt25tvcExtraFeatureList {
  return ComStSt25sdkAbout_getSt25tvcExtraFeatureList();
}

+ (id<JavaUtilList>)getSignatureFeature {
  return ComStSt25sdkAbout_getSignatureFeature();
}

+ (const J2ObjcClassInfo *)__metadata {
  static J2ObjcMethodInfo methods[] = {
    { NULL, NULL, 0x1, -1, -1, -1, -1, -1, -1 },
    { NULL, "LNSString;", 0x9, -1, -1, -1, -1, -1, -1 },
    { NULL, "I", 0x9, -1, -1, -1, -1, -1, -1 },
    { NULL, "I", 0x9, -1, -1, -1, -1, -1, -1 },
    { NULL, "I", 0x9, -1, -1, -1, -1, -1, -1 },
    { NULL, "LJavaUtilSet;", 0x9, -1, -1, -1, 0, -1, -1 },
    { NULL, "LJavaUtilList;", 0xa, -1, -1, -1, 1, -1, -1 },
    { NULL, "LJavaUtilList;", 0xa, -1, -1, -1, 1, -1, -1 },
    { NULL, "LJavaUtilList;", 0xa, -1, -1, -1, 1, -1, -1 },
  };
  #pragma clang diagnostic push
  #pragma clang diagnostic ignored "-Wobjc-multiple-method-names"
  #pragma clang diagnostic ignored "-Wundeclared-selector"
  methods[0].selector = @selector(init);
  methods[1].selector = @selector(getFullVersion);
  methods[2].selector = @selector(getMajorVersionNumber);
  methods[3].selector = @selector(getMinorVersionNumber);
  methods[4].selector = @selector(getPatchVersionNumber);
  methods[5].selector = @selector(getExtraFeatureList);
  methods[6].selector = @selector(getTVFeatureList);
  methods[7].selector = @selector(getSt25tvcExtraFeatureList);
  methods[8].selector = @selector(getSignatureFeature);
  #pragma clang diagnostic pop
  static const J2ObjcFieldInfo fields[] = {
    { "ST25SDK_LIB_MAJOR_NUMBER", "I", .constantValue.asInt = ComStSt25sdkAbout_ST25SDK_LIB_MAJOR_NUMBER, 0x1a, -1, -1, -1, -1 },
    { "ST25SDK_LIB_MINOR_NUMBER", "I", .constantValue.asInt = ComStSt25sdkAbout_ST25SDK_LIB_MINOR_NUMBER, 0x1a, -1, -1, -1, -1 },
    { "ST25SDK_LIB_PATCH_NUMBER", "I", .constantValue.asInt = ComStSt25sdkAbout_ST25SDK_LIB_PATCH_NUMBER, 0x1a, -1, -1, -1, -1 },
    { "ST25SDK_LIB_VERSION", "LNSString;", .constantValue.asLong = 0, 0x1a, -1, 2, -1, -1 },
  };
  static const void *ptrTable[] = { "()Ljava/util/Set<Ljava/lang/String;>;", "()Ljava/util/List<Ljava/lang/String;>;", &ComStSt25sdkAbout_ST25SDK_LIB_VERSION };
  static const J2ObjcClassInfo _ComStSt25sdkAbout = { "About", "com.st.st25sdk", ptrTable, methods, fields, 7, 0x1, 9, 4, -1, -1, -1, -1, -1 };
  return &_ComStSt25sdkAbout;
}

@end

void ComStSt25sdkAbout_init(ComStSt25sdkAbout *self) {
  NSObject_init(self);
}

ComStSt25sdkAbout *new_ComStSt25sdkAbout_init() {
  J2OBJC_NEW_IMPL(ComStSt25sdkAbout, init)
}

ComStSt25sdkAbout *create_ComStSt25sdkAbout_init() {
  J2OBJC_CREATE_IMPL(ComStSt25sdkAbout, init)
}

NSString *ComStSt25sdkAbout_getFullVersion() {
  ComStSt25sdkAbout_initialize();
  return ComStSt25sdkAbout_ST25SDK_LIB_VERSION;
}

jint ComStSt25sdkAbout_getMajorVersionNumber() {
  ComStSt25sdkAbout_initialize();
  return ComStSt25sdkAbout_ST25SDK_LIB_MAJOR_NUMBER;
}

jint ComStSt25sdkAbout_getMinorVersionNumber() {
  ComStSt25sdkAbout_initialize();
  return ComStSt25sdkAbout_ST25SDK_LIB_MINOR_NUMBER;
}

jint ComStSt25sdkAbout_getPatchVersionNumber() {
  ComStSt25sdkAbout_initialize();
  return ComStSt25sdkAbout_ST25SDK_LIB_PATCH_NUMBER;
}

id<JavaUtilSet> ComStSt25sdkAbout_getExtraFeatureList() {
  ComStSt25sdkAbout_initialize();
  id<JavaUtilSet> extraFeatureList = new_JavaUtilTreeSet_init();
  [extraFeatureList addAllWithJavaUtilCollection:ComStSt25sdkAbout_getTVFeatureList()];
  [extraFeatureList addAllWithJavaUtilCollection:ComStSt25sdkAbout_getSt25tvcExtraFeatureList()];
  [extraFeatureList addAllWithJavaUtilCollection:ComStSt25sdkAbout_getSignatureFeature()];
  return extraFeatureList;
}

id<JavaUtilList> ComStSt25sdkAbout_getTVFeatureList() {
  ComStSt25sdkAbout_initialize();
  return ComStSt25sdkType5St25tvST25TVTag_getSt25tvExtraFeatureList();
}

id<JavaUtilList> ComStSt25sdkAbout_getSt25tvcExtraFeatureList() {
  ComStSt25sdkAbout_initialize();
  return ComStSt25sdkType5St25tvcST25TVCTag_getSt25tvcExtraFeatureList();
}

id<JavaUtilList> ComStSt25sdkAbout_getSignatureFeature() {
  ComStSt25sdkAbout_initialize();
  @try {
    (void) IOSClass_forName_(@"com.st.st25sdk.crypto.CheckSign");
  }
  @catch (JavaLangClassNotFoundException *e) {
    return JavaUtilCollections_emptyList();
  }
  return JavaUtilArrays_asListWithNSObjectArray_([IOSObjectArray newArrayWithObjects:(id[]){ @"signature" } count:1 type:NSString_class_()]);
}

J2OBJC_CLASS_TYPE_LITERAL_SOURCE(ComStSt25sdkAbout)
