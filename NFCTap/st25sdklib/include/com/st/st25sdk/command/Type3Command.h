//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: st25sdk_ios/command/Type3Command.java
//

#include "J2ObjC_header.h"

#pragma push_macro("INCLUDE_ALL_ComStSt25sdkCommandType3Command")
#ifdef RESTRICT_ComStSt25sdkCommandType3Command
#define INCLUDE_ALL_ComStSt25sdkCommandType3Command 0
#else
#define INCLUDE_ALL_ComStSt25sdkCommandType3Command 1
#endif
#undef RESTRICT_ComStSt25sdkCommandType3Command

#if __has_feature(nullability)
#pragma clang diagnostic push
#pragma GCC diagnostic ignored "-Wnullability"
#pragma GCC diagnostic ignored "-Wnullability-completeness"
#endif

#if !defined (ComStSt25sdkCommandType3Command_) && (INCLUDE_ALL_ComStSt25sdkCommandType3Command || defined(INCLUDE_ComStSt25sdkCommandType3Command))
#define ComStSt25sdkCommandType3Command_

#define RESTRICT_ComStSt25sdkCommandType3CommandInterface 1
#define INCLUDE_ComStSt25sdkCommandType3CommandInterface 1
#include "com/st/st25sdk/command/Type3CommandInterface.h"

@class ComStSt25sdkRFReaderInterface_TransceiveMode;
@class IOSByteArray;
@class IOSIntArray;
@protocol ComStSt25sdkRFReaderInterface;

@interface ComStSt25sdkCommandType3Command : NSObject < ComStSt25sdkCommandType3CommandInterface > {
 @public
  ComStSt25sdkRFReaderInterface_TransceiveMode *transceiveMode_;
}
@property (readonly, class) jint T3T_DEFAULT_NBR_OF_BYTES_PER_BLOCK NS_SWIFT_NAME(T3T_DEFAULT_NBR_OF_BYTES_PER_BLOCK);
@property (readonly, class) jbyte TYPE3_SENSF_REQUEST_CMD NS_SWIFT_NAME(TYPE3_SENSF_REQUEST_CMD);
@property (readonly, class) jbyte TYPE3_SENSF_RESPONSE_CODE NS_SWIFT_NAME(TYPE3_SENSF_RESPONSE_CODE);
@property (readonly, class) jbyte TYPE3_CHECK_REQUEST_CMD NS_SWIFT_NAME(TYPE3_CHECK_REQUEST_CMD);
@property (readonly, class) jbyte TYPE3_CHECK_RESPONSE_CODE NS_SWIFT_NAME(TYPE3_CHECK_RESPONSE_CODE);
@property (readonly, class) jbyte TYPE3_UPDATE_REQUEST_CMD NS_SWIFT_NAME(TYPE3_UPDATE_REQUEST_CMD);
@property (readonly, class) jbyte TYPE3_UPDATE_RESPONSE_CODE NS_SWIFT_NAME(TYPE3_UPDATE_RESPONSE_CODE);
@property (readonly, class) jint TYPE3_CHECK_RESPONSE_FRAME_HEADER_LENGTH NS_SWIFT_NAME(TYPE3_CHECK_RESPONSE_FRAME_HEADER_LENGTH);

+ (jint)T3T_DEFAULT_NBR_OF_BYTES_PER_BLOCK;

+ (jbyte)TYPE3_SENSF_REQUEST_CMD;

+ (jbyte)TYPE3_SENSF_RESPONSE_CODE;

+ (jbyte)TYPE3_CHECK_REQUEST_CMD;

+ (jbyte)TYPE3_CHECK_RESPONSE_CODE;

+ (jbyte)TYPE3_UPDATE_REQUEST_CMD;

+ (jbyte)TYPE3_UPDATE_RESPONSE_CODE;

+ (jint)TYPE3_CHECK_RESPONSE_FRAME_HEADER_LENGTH;

#pragma mark Public

- (instancetype __nonnull)initWithComStSt25sdkRFReaderInterface:(id<ComStSt25sdkRFReaderInterface>)reader;

- (IOSByteArray *)checkWithByteArray:(IOSByteArray *)nfcId2
                        withIntArray:(IOSIntArray *)serviceCodeList
                        withIntArray:(IOSIntArray *)blockList;

- (IOSByteArray *)checkType3TagPresence;

- (jint)getBlockSize;

- (IOSByteArray *)readBlockWithByteArray:(IOSByteArray *)nfcId2
                                 withInt:(jint)blockNumber;

- (IOSByteArray *)readBlocksWithByteArray:(IOSByteArray *)nfcId2
                                  withInt:(jint)firstBlockAddress
                                  withInt:(jint)sizeInBlocks;

- (IOSByteArray *)readBytesWithByteArray:(IOSByteArray *)nfcId2
                                 withInt:(jint)byteAddress
                                 withInt:(jint)sizeInBytes;

- (IOSByteArray *)sensFWithByteArray:(IOSByteArray *)systemCode
                            withByte:(jbyte)requestCode
                            withByte:(jbyte)timeSlotNumber;

- (IOSByteArray *)transceiveWithNSString:(NSString *)commandName
                           withByteArray:(IOSByteArray *)frame;

- (IOSByteArray *)updateWithByteArray:(IOSByteArray *)nfcId2
                         withIntArray:(IOSIntArray *)serviceCodeList
                         withIntArray:(IOSIntArray *)blockList
                        withByteArray:(IOSByteArray *)blockData;

- (IOSByteArray *)writeBlockWithByteArray:(IOSByteArray *)nfcId2
                                  withInt:(jint)blockNumber
                            withByteArray:(IOSByteArray *)data;

- (void)writeBlocksWithByteArray:(IOSByteArray *)nfcId2
                         withInt:(jint)firstBlockAddress
                   withByteArray:(IOSByteArray *)data;

- (void)writeBytesWithByteArray:(IOSByteArray *)nfcId2
                        withInt:(jint)byteAddress
                  withByteArray:(IOSByteArray *)data;

#pragma mark Protected

- (void)checkIso18092Type3ResponseWithByteArray:(IOSByteArray *)response;

- (void)generateCmdExceptionWithByteArray:(IOSByteArray *)response;

// Disallowed inherited constructors, do not use.

- (instancetype __nonnull)init NS_UNAVAILABLE;

@end

J2OBJC_EMPTY_STATIC_INIT(ComStSt25sdkCommandType3Command)

J2OBJC_FIELD_SETTER(ComStSt25sdkCommandType3Command, transceiveMode_, ComStSt25sdkRFReaderInterface_TransceiveMode *)

inline jint ComStSt25sdkCommandType3Command_get_T3T_DEFAULT_NBR_OF_BYTES_PER_BLOCK(void);
#define ComStSt25sdkCommandType3Command_T3T_DEFAULT_NBR_OF_BYTES_PER_BLOCK 16
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkCommandType3Command, T3T_DEFAULT_NBR_OF_BYTES_PER_BLOCK, jint)

inline jbyte ComStSt25sdkCommandType3Command_get_TYPE3_SENSF_REQUEST_CMD(void);
#define ComStSt25sdkCommandType3Command_TYPE3_SENSF_REQUEST_CMD 0
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkCommandType3Command, TYPE3_SENSF_REQUEST_CMD, jbyte)

inline jbyte ComStSt25sdkCommandType3Command_get_TYPE3_SENSF_RESPONSE_CODE(void);
#define ComStSt25sdkCommandType3Command_TYPE3_SENSF_RESPONSE_CODE 1
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkCommandType3Command, TYPE3_SENSF_RESPONSE_CODE, jbyte)

inline jbyte ComStSt25sdkCommandType3Command_get_TYPE3_CHECK_REQUEST_CMD(void);
#define ComStSt25sdkCommandType3Command_TYPE3_CHECK_REQUEST_CMD 6
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkCommandType3Command, TYPE3_CHECK_REQUEST_CMD, jbyte)

inline jbyte ComStSt25sdkCommandType3Command_get_TYPE3_CHECK_RESPONSE_CODE(void);
#define ComStSt25sdkCommandType3Command_TYPE3_CHECK_RESPONSE_CODE 7
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkCommandType3Command, TYPE3_CHECK_RESPONSE_CODE, jbyte)

inline jbyte ComStSt25sdkCommandType3Command_get_TYPE3_UPDATE_REQUEST_CMD(void);
#define ComStSt25sdkCommandType3Command_TYPE3_UPDATE_REQUEST_CMD 8
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkCommandType3Command, TYPE3_UPDATE_REQUEST_CMD, jbyte)

inline jbyte ComStSt25sdkCommandType3Command_get_TYPE3_UPDATE_RESPONSE_CODE(void);
#define ComStSt25sdkCommandType3Command_TYPE3_UPDATE_RESPONSE_CODE 9
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkCommandType3Command, TYPE3_UPDATE_RESPONSE_CODE, jbyte)

inline jint ComStSt25sdkCommandType3Command_get_TYPE3_CHECK_RESPONSE_FRAME_HEADER_LENGTH(void);
#define ComStSt25sdkCommandType3Command_TYPE3_CHECK_RESPONSE_FRAME_HEADER_LENGTH 12
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkCommandType3Command, TYPE3_CHECK_RESPONSE_FRAME_HEADER_LENGTH, jint)

FOUNDATION_EXPORT void ComStSt25sdkCommandType3Command_initWithComStSt25sdkRFReaderInterface_(ComStSt25sdkCommandType3Command *self, id<ComStSt25sdkRFReaderInterface> reader);

FOUNDATION_EXPORT ComStSt25sdkCommandType3Command *new_ComStSt25sdkCommandType3Command_initWithComStSt25sdkRFReaderInterface_(id<ComStSt25sdkRFReaderInterface> reader) NS_RETURNS_RETAINED;

FOUNDATION_EXPORT ComStSt25sdkCommandType3Command *create_ComStSt25sdkCommandType3Command_initWithComStSt25sdkRFReaderInterface_(id<ComStSt25sdkRFReaderInterface> reader);

J2OBJC_TYPE_LITERAL_HEADER(ComStSt25sdkCommandType3Command)

#endif


#if __has_feature(nullability)
#pragma clang diagnostic pop
#endif
#pragma pop_macro("INCLUDE_ALL_ComStSt25sdkCommandType3Command")
