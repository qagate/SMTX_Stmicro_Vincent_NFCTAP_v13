//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: st25sdk_ios/type5/m24lr/M24LR04KTag.java
//

#include "J2ObjC_header.h"

#pragma push_macro("INCLUDE_ALL_ComStSt25sdkType5M24lrM24LR04KTag")
#ifdef RESTRICT_ComStSt25sdkType5M24lrM24LR04KTag
#define INCLUDE_ALL_ComStSt25sdkType5M24lrM24LR04KTag 0
#else
#define INCLUDE_ALL_ComStSt25sdkType5M24lrM24LR04KTag 1
#endif
#undef RESTRICT_ComStSt25sdkType5M24lrM24LR04KTag

#if __has_feature(nullability)
#pragma clang diagnostic push
#pragma GCC diagnostic ignored "-Wnullability"
#pragma GCC diagnostic ignored "-Wnullability-completeness"
#endif

#if !defined (ComStSt25sdkType5M24lrM24LR04KTag_) && (INCLUDE_ALL_ComStSt25sdkType5M24lrM24LR04KTag || defined(INCLUDE_ComStSt25sdkType5M24lrM24LR04KTag))
#define ComStSt25sdkType5M24lrM24LR04KTag_

#define RESTRICT_ComStSt25sdkType5STType5Tag 1
#define INCLUDE_ComStSt25sdkType5STType5Tag 1
#include "com/st/st25sdk/type5/STType5Tag.h"

#define RESTRICT_ComStSt25sdkSectorInterface 1
#define INCLUDE_ComStSt25sdkSectorInterface 1
#include "com/st/st25sdk/SectorInterface.h"

#define RESTRICT_ComStSt25sdkType5STType5PasswordInterface 1
#define INCLUDE_ComStSt25sdkType5STType5PasswordInterface 1
#include "com/st/st25sdk/type5/STType5PasswordInterface.h"

#define RESTRICT_ComStSt25sdkType5STVicinityConfigInterface 1
#define INCLUDE_ComStSt25sdkType5STVicinityConfigInterface 1
#include "com/st/st25sdk/type5/STVicinityConfigInterface.h"

@class ComStSt25sdkType5STType5Sector;
@class IOSByteArray;
@protocol ComStSt25sdkRFReaderInterface;

@interface ComStSt25sdkType5M24lrM24LR04KTag : ComStSt25sdkType5STType5Tag < ComStSt25sdkSectorInterface, ComStSt25sdkType5STType5PasswordInterface, ComStSt25sdkType5STVicinityConfigInterface > {
 @public
  ComStSt25sdkType5STType5Sector *mSectorSec_;
  jint mNbOfSectors_;
  jint mNbOfBlocksPerSector_;
}

#pragma mark Public

- (instancetype __nonnull)initWithComStSt25sdkRFReaderInterface:(id<ComStSt25sdkRFReaderInterface>)readerInterface
                                                  withByteArray:(IOSByteArray *)uid;

- (IOSByteArray *)checkEHEn;

- (IOSByteArray *)checkEHEnWithByte:(jbyte)flag;

- (IOSByteArray *)fastInitiateWithByte:(jbyte)flag;

- (IOSByteArray *)fastInventoryInitiatedWithByte:(jbyte)flag;

- (IOSByteArray *)fastInventoryInitiatedWithByte:(jbyte)flag
                                        withByte:(jbyte)maskLength
                                   withByteArray:(IOSByteArray *)maskValue;

- (IOSByteArray *)fastInventoryInitiatedWithByte:(jbyte)flag
                                        withByte:(jbyte)maskLength
                                   withByteArray:(IOSByteArray *)maskValue
                                        withByte:(jbyte)afiField;

- (jint)getConfigurationPasswordNumber;

- (jint)getNumberOfBlocksPerSector;

- (jint)getNumberOfSectors;

- (jint)getPasswordLengthWithInt:(jint)passwordNumber;

- (jint)getPasswordNumberWithInt:(jint)sector;

- (IOSByteArray *)getSecurityStatus;

- (jbyte)getSecurityStatusWithInt:(jint)sector;

- (IOSByteArray *)initiateWithByte:(jbyte)flag OBJC_METHOD_FAMILY_NONE;

- (IOSByteArray *)inventoryInitiatedWithByte:(jbyte)flag;

- (IOSByteArray *)inventoryInitiatedWithByte:(jbyte)flag
                                    withByte:(jbyte)maskLength
                               withByteArray:(IOSByteArray *)maskValue;

- (IOSByteArray *)inventoryInitiatedWithByte:(jbyte)flag
                                    withByte:(jbyte)maskLength
                               withByteArray:(IOSByteArray *)maskValue
                                    withByte:(jbyte)afiField;

- (void)lockSectorWithInt:(jint)sector
                 withByte:(jbyte)value;

- (void)presentPasswordWithInt:(jint)passwordNumber
                 withByteArray:(IOSByteArray *)password;

- (IOSByteArray *)readCfg;

- (IOSByteArray *)readCfgWithByte:(jbyte)flag;

- (void)setPasswordNumberWithInt:(jint)sector
                         withInt:(jint)passwordNumber;

- (jbyte)setRstEHEnWithByte:(jbyte)data;

- (jbyte)setRstEHEnWithByte:(jbyte)data
                   withByte:(jbyte)flag;

- (void)setSecurityStatusWithInt:(jint)sector
                        withByte:(jbyte)value;

- (jbyte)writeDOCfgWithByte:(jbyte)data;

- (jbyte)writeDOCfgWithByte:(jbyte)data
                   withByte:(jbyte)flag;

- (jbyte)writeEHCfgWithByte:(jbyte)data;

- (jbyte)writeEHCfgWithByte:(jbyte)data
                   withByte:(jbyte)flag;

- (void)writePasswordWithInt:(jint)passwordNumber
               withByteArray:(IOSByteArray *)newPassword;

@end

J2OBJC_EMPTY_STATIC_INIT(ComStSt25sdkType5M24lrM24LR04KTag)

J2OBJC_FIELD_SETTER(ComStSt25sdkType5M24lrM24LR04KTag, mSectorSec_, ComStSt25sdkType5STType5Sector *)

FOUNDATION_EXPORT void ComStSt25sdkType5M24lrM24LR04KTag_initWithComStSt25sdkRFReaderInterface_withByteArray_(ComStSt25sdkType5M24lrM24LR04KTag *self, id<ComStSt25sdkRFReaderInterface> readerInterface, IOSByteArray *uid);

FOUNDATION_EXPORT ComStSt25sdkType5M24lrM24LR04KTag *new_ComStSt25sdkType5M24lrM24LR04KTag_initWithComStSt25sdkRFReaderInterface_withByteArray_(id<ComStSt25sdkRFReaderInterface> readerInterface, IOSByteArray *uid) NS_RETURNS_RETAINED;

FOUNDATION_EXPORT ComStSt25sdkType5M24lrM24LR04KTag *create_ComStSt25sdkType5M24lrM24LR04KTag_initWithComStSt25sdkRFReaderInterface_withByteArray_(id<ComStSt25sdkRFReaderInterface> readerInterface, IOSByteArray *uid);

J2OBJC_TYPE_LITERAL_HEADER(ComStSt25sdkType5M24lrM24LR04KTag)

#endif


#if __has_feature(nullability)
#pragma clang diagnostic pop
#endif
#pragma pop_macro("INCLUDE_ALL_ComStSt25sdkType5M24lrM24LR04KTag")