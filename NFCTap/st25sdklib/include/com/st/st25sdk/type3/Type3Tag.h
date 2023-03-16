//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: st25sdk_ios/type3/Type3Tag.java
//

#include "J2ObjC_header.h"

#pragma push_macro("INCLUDE_ALL_ComStSt25sdkType3Type3Tag")
#ifdef RESTRICT_ComStSt25sdkType3Type3Tag
#define INCLUDE_ALL_ComStSt25sdkType3Type3Tag 0
#else
#define INCLUDE_ALL_ComStSt25sdkType3Type3Tag 1
#endif
#undef RESTRICT_ComStSt25sdkType3Type3Tag

#if __has_feature(nullability)
#pragma clang diagnostic push
#pragma GCC diagnostic ignored "-Wnullability"
#pragma GCC diagnostic ignored "-Wnullability-completeness"
#endif

#if !defined (ComStSt25sdkType3Type3Tag_) && (INCLUDE_ALL_ComStSt25sdkType3Type3Tag || defined(INCLUDE_ComStSt25sdkType3Type3Tag))
#define ComStSt25sdkType3Type3Tag_

#define RESTRICT_ComStSt25sdkNFCTag 1
#define INCLUDE_ComStSt25sdkNFCTag 1
#include "com/st/st25sdk/NFCTag.h"

#define RESTRICT_ComStSt25sdkCacheInterface 1
#define INCLUDE_ComStSt25sdkCacheInterface 1
#include "com/st/st25sdk/CacheInterface.h"

#define RESTRICT_ComStSt25sdkCommandNdefCommandInterface 1
#define INCLUDE_ComStSt25sdkCommandNdefCommandInterface 1
#include "com/st/st25sdk/command/NdefCommandInterface.h"

@class ComStSt25sdkCommandNdefType3Command;
@class ComStSt25sdkCommandType3Command;
@class ComStSt25sdkNdefNDEFMsg;
@class ComStSt25sdkTagCache;
@class IOSByteArray;
@protocol ComStSt25sdkRFReaderInterface;

@interface ComStSt25sdkType3Type3Tag : ComStSt25sdkNFCTag < ComStSt25sdkCacheInterface, ComStSt25sdkCommandNdefCommandInterface > {
 @public
  ComStSt25sdkCommandType3Command *mType3Cmd_;
  ComStSt25sdkCommandNdefType3Command *mNdefCmd_;
  ComStSt25sdkTagCache *mCache_;
  IOSByteArray *mManufacturerId_;
  jbyte mVer_;
  jbyte mNbr_;
  jbyte mNbw_;
  jint mNMaxB_;
  jbyte mWriteFlag_;
  jbyte mRWFlag_;
  jint mLn_;
  jint mChecksum_;
}
@property (readonly, class) jint T3T_ATTRIBUTE_INFO_BLOCK_ADDRESS NS_SWIFT_NAME(T3T_ATTRIBUTE_INFO_BLOCK_ADDRESS);
@property (readonly, class) jint T3T_ATTRIBUTE_INFO_VER_ADDRESS_IN_BYTE NS_SWIFT_NAME(T3T_ATTRIBUTE_INFO_VER_ADDRESS_IN_BYTE);
@property (readonly, class) jint T3T_ATTRIBUTE_INFO_NBR_ADDRESS_IN_BYTE NS_SWIFT_NAME(T3T_ATTRIBUTE_INFO_NBR_ADDRESS_IN_BYTE);
@property (readonly, class) jint T3T_ATTRIBUTE_INFO_NBW_ADDRESS_IN_BYTE NS_SWIFT_NAME(T3T_ATTRIBUTE_INFO_NBW_ADDRESS_IN_BYTE);
@property (readonly, class) jint T3T_ATTRIBUTE_INFO_NMAXB_ADDRESS_IN_BYTE NS_SWIFT_NAME(T3T_ATTRIBUTE_INFO_NMAXB_ADDRESS_IN_BYTE);
@property (readonly, class) jint T3T_ATTRIBUTE_INFO_WRITEFLAG_ADDRESS_IN_BYTE NS_SWIFT_NAME(T3T_ATTRIBUTE_INFO_WRITEFLAG_ADDRESS_IN_BYTE);
@property (readonly, class) jint T3T_ATTRIBUTE_INFO_RWFLAG_ADDRESS_IN_BYTE NS_SWIFT_NAME(T3T_ATTRIBUTE_INFO_RWFLAG_ADDRESS_IN_BYTE);
@property (readonly, class) jint T3T_ATTRIBUTE_INFO_LN_ADDRESS_IN_BYTE NS_SWIFT_NAME(T3T_ATTRIBUTE_INFO_LN_ADDRESS_IN_BYTE);
@property (readonly, class) jint T3T_ATTRIBUTE_INFO_CHECKSUM_ADDRESS_IN_BYTE NS_SWIFT_NAME(T3T_ATTRIBUTE_INFO_CHECKSUM_ADDRESS_IN_BYTE);
@property (readonly, class) jbyte T3T_ATTRIBUTE_INFO_WRITEFLAG_PROCEDURE_FINISHED NS_SWIFT_NAME(T3T_ATTRIBUTE_INFO_WRITEFLAG_PROCEDURE_FINISHED);
@property (readonly, class) jbyte T3T_ATTRIBUTE_INFO_WRITEFLAG_PROCEDURE_NOT_FINISHED NS_SWIFT_NAME(T3T_ATTRIBUTE_INFO_WRITEFLAG_PROCEDURE_NOT_FINISHED);
@property (readonly, class) jint T3T_NDEF_FIRST_BYTE_ADDRESS NS_SWIFT_NAME(T3T_NDEF_FIRST_BYTE_ADDRESS);
@property (readonly, class) jint T3T_NDEF_FIRST_BLOCK_NUMBER NS_SWIFT_NAME(T3T_NDEF_FIRST_BLOCK_NUMBER);

+ (jint)T3T_ATTRIBUTE_INFO_BLOCK_ADDRESS;

+ (jint)T3T_ATTRIBUTE_INFO_VER_ADDRESS_IN_BYTE;

+ (jint)T3T_ATTRIBUTE_INFO_NBR_ADDRESS_IN_BYTE;

+ (jint)T3T_ATTRIBUTE_INFO_NBW_ADDRESS_IN_BYTE;

+ (jint)T3T_ATTRIBUTE_INFO_NMAXB_ADDRESS_IN_BYTE;

+ (jint)T3T_ATTRIBUTE_INFO_WRITEFLAG_ADDRESS_IN_BYTE;

+ (jint)T3T_ATTRIBUTE_INFO_RWFLAG_ADDRESS_IN_BYTE;

+ (jint)T3T_ATTRIBUTE_INFO_LN_ADDRESS_IN_BYTE;

+ (jint)T3T_ATTRIBUTE_INFO_CHECKSUM_ADDRESS_IN_BYTE;

+ (jbyte)T3T_ATTRIBUTE_INFO_WRITEFLAG_PROCEDURE_FINISHED;

+ (jbyte)T3T_ATTRIBUTE_INFO_WRITEFLAG_PROCEDURE_NOT_FINISHED;

+ (jint)T3T_NDEF_FIRST_BYTE_ADDRESS;

+ (jint)T3T_NDEF_FIRST_BLOCK_NUMBER;

#pragma mark Public

- (instancetype __nonnull)initWithComStSt25sdkRFReaderInterface:(id<ComStSt25sdkRFReaderInterface>)readerInterface;

- (instancetype __nonnull)initWithComStSt25sdkRFReaderInterface:(id<ComStSt25sdkRFReaderInterface>)readerInterface
                                                  withByteArray:(IOSByteArray *)manufactureId;

- (void)activateCache;

- (IOSByteArray *)calculateChecksumWithByteArray:(IOSByteArray *)data;

- (void)deactivateCache;

- (jint)getBlockSizeInBytes;

- (jint)getCCFileLength;

- (jbyte)getCCMagicNumber;

- (jbyte)getCCMappingVersion;

- (jint)getCCMemorySize;

- (jbyte)getCCReadAccess;

- (jbyte)getCCWriteAccess;

- (jint)getChecksum;

- (jint)getLn;

- (jint)getMemSizeInBytes;

- (jbyte)getNdefMappingVersion;

- (jint)getNumberOfBlocksForNdefData;

- (jbyte)getNumberOfBlocksForOneCheckCommand;

- (jbyte)getNumberOfBlocksForOneUpdateCommand;

- (jbyte)getRWFlag;

- (jint)getSysFileLength;

- (ComStSt25sdkCommandType3Command *)getType3Command;

- (jbyte)getWriteFlag;

- (void)initEmptyCCFile OBJC_METHOD_FAMILY_NONE;

- (void)invalidateCache;

- (jboolean)isCacheActivated;

- (jboolean)isCacheValid;

- (jboolean)isType3TagPresent;

- (IOSByteArray *)readBlocksWithInt:(jint)firstBlockAddress
                            withInt:(jint)sizeInBlocks;

- (IOSByteArray *)readBytesWithInt:(jint)byteAddress
                           withInt:(jint)sizeInBytes;

- (IOSByteArray *)readCCFile;

- (ComStSt25sdkNdefNDEFMsg *)readNdefMessage;

- (IOSByteArray *)readSysFile;

- (jboolean)refreshAttributeInformationBlock;

- (void)setChecksumWithInt:(jint)checksum;

- (void)setLnWithInt:(jint)ln;

- (void)setRWFlagWithByte:(jbyte)rwFlag;

- (void)setWriteFlagWithByte:(jbyte)writeFlag;

- (jboolean)updateAttributeInformationBlockWithInt:(jint)address
                                     withByteArray:(IOSByteArray *)data;

- (void)updateCache;

- (void)validateCache;

- (void)writeBlocksWithInt:(jint)firstBlockAddress
             withByteArray:(IOSByteArray *)data;

- (void)writeBytesWithInt:(jint)byteAddress
            withByteArray:(IOSByteArray *)data;

- (void)writeCCFile;

- (void)writeCCFileWithByteArray:(IOSByteArray *)buffer;

- (void)writeNdefMessageWithComStSt25sdkNdefNDEFMsg:(ComStSt25sdkNdefNDEFMsg *)msg;

// Disallowed inherited constructors, do not use.

- (instancetype __nonnull)init NS_UNAVAILABLE;

@end

J2OBJC_EMPTY_STATIC_INIT(ComStSt25sdkType3Type3Tag)

J2OBJC_FIELD_SETTER(ComStSt25sdkType3Type3Tag, mType3Cmd_, ComStSt25sdkCommandType3Command *)
J2OBJC_FIELD_SETTER(ComStSt25sdkType3Type3Tag, mNdefCmd_, ComStSt25sdkCommandNdefType3Command *)
J2OBJC_FIELD_SETTER(ComStSt25sdkType3Type3Tag, mCache_, ComStSt25sdkTagCache *)
J2OBJC_FIELD_SETTER(ComStSt25sdkType3Type3Tag, mManufacturerId_, IOSByteArray *)

inline jint ComStSt25sdkType3Type3Tag_get_T3T_ATTRIBUTE_INFO_BLOCK_ADDRESS(void);
#define ComStSt25sdkType3Type3Tag_T3T_ATTRIBUTE_INFO_BLOCK_ADDRESS 0
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkType3Type3Tag, T3T_ATTRIBUTE_INFO_BLOCK_ADDRESS, jint)

inline jint ComStSt25sdkType3Type3Tag_get_T3T_ATTRIBUTE_INFO_VER_ADDRESS_IN_BYTE(void);
#define ComStSt25sdkType3Type3Tag_T3T_ATTRIBUTE_INFO_VER_ADDRESS_IN_BYTE 0
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkType3Type3Tag, T3T_ATTRIBUTE_INFO_VER_ADDRESS_IN_BYTE, jint)

inline jint ComStSt25sdkType3Type3Tag_get_T3T_ATTRIBUTE_INFO_NBR_ADDRESS_IN_BYTE(void);
#define ComStSt25sdkType3Type3Tag_T3T_ATTRIBUTE_INFO_NBR_ADDRESS_IN_BYTE 1
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkType3Type3Tag, T3T_ATTRIBUTE_INFO_NBR_ADDRESS_IN_BYTE, jint)

inline jint ComStSt25sdkType3Type3Tag_get_T3T_ATTRIBUTE_INFO_NBW_ADDRESS_IN_BYTE(void);
#define ComStSt25sdkType3Type3Tag_T3T_ATTRIBUTE_INFO_NBW_ADDRESS_IN_BYTE 2
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkType3Type3Tag, T3T_ATTRIBUTE_INFO_NBW_ADDRESS_IN_BYTE, jint)

inline jint ComStSt25sdkType3Type3Tag_get_T3T_ATTRIBUTE_INFO_NMAXB_ADDRESS_IN_BYTE(void);
#define ComStSt25sdkType3Type3Tag_T3T_ATTRIBUTE_INFO_NMAXB_ADDRESS_IN_BYTE 3
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkType3Type3Tag, T3T_ATTRIBUTE_INFO_NMAXB_ADDRESS_IN_BYTE, jint)

inline jint ComStSt25sdkType3Type3Tag_get_T3T_ATTRIBUTE_INFO_WRITEFLAG_ADDRESS_IN_BYTE(void);
#define ComStSt25sdkType3Type3Tag_T3T_ATTRIBUTE_INFO_WRITEFLAG_ADDRESS_IN_BYTE 9
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkType3Type3Tag, T3T_ATTRIBUTE_INFO_WRITEFLAG_ADDRESS_IN_BYTE, jint)

inline jint ComStSt25sdkType3Type3Tag_get_T3T_ATTRIBUTE_INFO_RWFLAG_ADDRESS_IN_BYTE(void);
#define ComStSt25sdkType3Type3Tag_T3T_ATTRIBUTE_INFO_RWFLAG_ADDRESS_IN_BYTE 10
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkType3Type3Tag, T3T_ATTRIBUTE_INFO_RWFLAG_ADDRESS_IN_BYTE, jint)

inline jint ComStSt25sdkType3Type3Tag_get_T3T_ATTRIBUTE_INFO_LN_ADDRESS_IN_BYTE(void);
#define ComStSt25sdkType3Type3Tag_T3T_ATTRIBUTE_INFO_LN_ADDRESS_IN_BYTE 11
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkType3Type3Tag, T3T_ATTRIBUTE_INFO_LN_ADDRESS_IN_BYTE, jint)

inline jint ComStSt25sdkType3Type3Tag_get_T3T_ATTRIBUTE_INFO_CHECKSUM_ADDRESS_IN_BYTE(void);
#define ComStSt25sdkType3Type3Tag_T3T_ATTRIBUTE_INFO_CHECKSUM_ADDRESS_IN_BYTE 14
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkType3Type3Tag, T3T_ATTRIBUTE_INFO_CHECKSUM_ADDRESS_IN_BYTE, jint)

inline jbyte ComStSt25sdkType3Type3Tag_get_T3T_ATTRIBUTE_INFO_WRITEFLAG_PROCEDURE_FINISHED(void);
#define ComStSt25sdkType3Type3Tag_T3T_ATTRIBUTE_INFO_WRITEFLAG_PROCEDURE_FINISHED 0
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkType3Type3Tag, T3T_ATTRIBUTE_INFO_WRITEFLAG_PROCEDURE_FINISHED, jbyte)

inline jbyte ComStSt25sdkType3Type3Tag_get_T3T_ATTRIBUTE_INFO_WRITEFLAG_PROCEDURE_NOT_FINISHED(void);
#define ComStSt25sdkType3Type3Tag_T3T_ATTRIBUTE_INFO_WRITEFLAG_PROCEDURE_NOT_FINISHED 15
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkType3Type3Tag, T3T_ATTRIBUTE_INFO_WRITEFLAG_PROCEDURE_NOT_FINISHED, jbyte)

inline jint ComStSt25sdkType3Type3Tag_get_T3T_NDEF_FIRST_BYTE_ADDRESS(void);
#define ComStSt25sdkType3Type3Tag_T3T_NDEF_FIRST_BYTE_ADDRESS 16
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkType3Type3Tag, T3T_NDEF_FIRST_BYTE_ADDRESS, jint)

inline jint ComStSt25sdkType3Type3Tag_get_T3T_NDEF_FIRST_BLOCK_NUMBER(void);
#define ComStSt25sdkType3Type3Tag_T3T_NDEF_FIRST_BLOCK_NUMBER 1
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkType3Type3Tag, T3T_NDEF_FIRST_BLOCK_NUMBER, jint)

FOUNDATION_EXPORT void ComStSt25sdkType3Type3Tag_initWithComStSt25sdkRFReaderInterface_(ComStSt25sdkType3Type3Tag *self, id<ComStSt25sdkRFReaderInterface> readerInterface);

FOUNDATION_EXPORT ComStSt25sdkType3Type3Tag *new_ComStSt25sdkType3Type3Tag_initWithComStSt25sdkRFReaderInterface_(id<ComStSt25sdkRFReaderInterface> readerInterface) NS_RETURNS_RETAINED;

FOUNDATION_EXPORT ComStSt25sdkType3Type3Tag *create_ComStSt25sdkType3Type3Tag_initWithComStSt25sdkRFReaderInterface_(id<ComStSt25sdkRFReaderInterface> readerInterface);

FOUNDATION_EXPORT void ComStSt25sdkType3Type3Tag_initWithComStSt25sdkRFReaderInterface_withByteArray_(ComStSt25sdkType3Type3Tag *self, id<ComStSt25sdkRFReaderInterface> readerInterface, IOSByteArray *manufactureId);

FOUNDATION_EXPORT ComStSt25sdkType3Type3Tag *new_ComStSt25sdkType3Type3Tag_initWithComStSt25sdkRFReaderInterface_withByteArray_(id<ComStSt25sdkRFReaderInterface> readerInterface, IOSByteArray *manufactureId) NS_RETURNS_RETAINED;

FOUNDATION_EXPORT ComStSt25sdkType3Type3Tag *create_ComStSt25sdkType3Type3Tag_initWithComStSt25sdkRFReaderInterface_withByteArray_(id<ComStSt25sdkRFReaderInterface> readerInterface, IOSByteArray *manufactureId);

J2OBJC_TYPE_LITERAL_HEADER(ComStSt25sdkType3Type3Tag)

#endif

#if !defined (ComStSt25sdkType3Type3Tag_Type3FileType_) && (INCLUDE_ALL_ComStSt25sdkType3Type3Tag || defined(INCLUDE_ComStSt25sdkType3Type3Tag_Type3FileType))
#define ComStSt25sdkType3Type3Tag_Type3FileType_

#define RESTRICT_JavaLangEnum 1
#define INCLUDE_JavaLangEnum 1
#include "java/lang/Enum.h"

@class IOSObjectArray;

typedef NS_ENUM(NSUInteger, ComStSt25sdkType3Type3Tag_Type3FileType_Enum) {
  ComStSt25sdkType3Type3Tag_Type3FileType_Enum_NDEF_FILE = 0,
};

@interface ComStSt25sdkType3Type3Tag_Type3FileType : JavaLangEnum

@property (readonly, class, nonnull) ComStSt25sdkType3Type3Tag_Type3FileType *NDEF_FILE NS_SWIFT_NAME(NDEF_FILE);
+ (ComStSt25sdkType3Type3Tag_Type3FileType * __nonnull)NDEF_FILE;

#pragma mark Public

+ (ComStSt25sdkType3Type3Tag_Type3FileType *)valueOfWithNSString:(NSString *)name;

+ (IOSObjectArray *)values;

#pragma mark Package-Private

- (ComStSt25sdkType3Type3Tag_Type3FileType_Enum)toNSEnum;

@end

J2OBJC_STATIC_INIT(ComStSt25sdkType3Type3Tag_Type3FileType)

/*! INTERNAL ONLY - Use enum accessors declared below. */
FOUNDATION_EXPORT ComStSt25sdkType3Type3Tag_Type3FileType *ComStSt25sdkType3Type3Tag_Type3FileType_values_[];

inline ComStSt25sdkType3Type3Tag_Type3FileType *ComStSt25sdkType3Type3Tag_Type3FileType_get_NDEF_FILE(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkType3Type3Tag_Type3FileType, NDEF_FILE)

FOUNDATION_EXPORT IOSObjectArray *ComStSt25sdkType3Type3Tag_Type3FileType_values(void);

FOUNDATION_EXPORT ComStSt25sdkType3Type3Tag_Type3FileType *ComStSt25sdkType3Type3Tag_Type3FileType_valueOfWithNSString_(NSString *name);

FOUNDATION_EXPORT ComStSt25sdkType3Type3Tag_Type3FileType *ComStSt25sdkType3Type3Tag_Type3FileType_fromOrdinal(NSUInteger ordinal);

J2OBJC_TYPE_LITERAL_HEADER(ComStSt25sdkType3Type3Tag_Type3FileType)

#endif


#if __has_feature(nullability)
#pragma clang diagnostic pop
#endif
#pragma pop_macro("INCLUDE_ALL_ComStSt25sdkType3Type3Tag")
