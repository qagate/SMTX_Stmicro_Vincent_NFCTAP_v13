//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: st25sdk_ios/ftmprotocol/FtmProtocol.java
//

#include "J2ObjC_header.h"

#pragma push_macro("INCLUDE_ALL_ComStSt25sdkFtmprotocolFtmProtocol")
#ifdef RESTRICT_ComStSt25sdkFtmprotocolFtmProtocol
#define INCLUDE_ALL_ComStSt25sdkFtmprotocolFtmProtocol 0
#else
#define INCLUDE_ALL_ComStSt25sdkFtmprotocolFtmProtocol 1
#endif
#undef RESTRICT_ComStSt25sdkFtmprotocolFtmProtocol

#if __has_feature(nullability)
#pragma clang diagnostic push
#pragma GCC diagnostic ignored "-Wnullability"
#pragma GCC diagnostic ignored "-Wnullability-completeness"
#endif

#if !defined (ComStSt25sdkFtmprotocolFtmProtocol_) && (INCLUDE_ALL_ComStSt25sdkFtmprotocolFtmProtocol || defined(INCLUDE_ComStSt25sdkFtmprotocolFtmProtocol))
#define ComStSt25sdkFtmprotocolFtmProtocol_

@class ComStSt25sdkType5St25dvST25DVTag;
@class IOSByteArray;
@class JavaUtilConcurrentSemaphore;
@protocol ComStSt25sdkFtmprotocolFtmProtocol_FtmProtocolHook;
@protocol ComStSt25sdkFtmprotocolFtmProtocol_TransferCompletionListener;
@protocol ComStSt25sdkFtmprotocolFtmProtocol_TransferProgressionListener;

@interface ComStSt25sdkFtmprotocolFtmProtocol : NSObject {
 @public
  JavaUtilConcurrentSemaphore *ftmSemaphore_;
}
@property (readonly, class) jint DEFAULT_NUMBER_OF_PACKETS_PER_SEGMENT NS_SWIFT_NAME(DEFAULT_NUMBER_OF_PACKETS_PER_SEGMENT);
@property (readonly, copy, class) NSString *TAG NS_SWIFT_NAME(TAG);

+ (jint)DEFAULT_NUMBER_OF_PACKETS_PER_SEGMENT;

+ (NSString *)TAG;

#pragma mark Public

- (instancetype __nonnull)initWithComStSt25sdkType5St25dvST25DVTag:(ComStSt25sdkType5St25dvST25DVTag *)st25DVTag;

- (void)cancelCurrentTransfer;

- (jint)getCurrentPacketNumber;

- (jboolean)getFastCommandsUsage;

- (jint)getMaxTransmissionSize;

- (void)pauseCurrentTransfer;

- (jbyte)readDynamicRegisterWithInt:(jint)configId
                           withByte:(jbyte)flag;

- (void)receiveDataWithComStSt25sdkFtmprotocolFtmProtocol_TransferProgressionListener:(id<ComStSt25sdkFtmprotocolFtmProtocol_TransferProgressionListener>)transferProgressionListener;

- (void)resetTimeOfFirstError;

- (void)resumeCurrentTransfer;

- (void)sendFtmDataWithByteArray:(IOSByteArray *)data
                     withBoolean:(jboolean)isErrorControlNeeded
                     withBoolean:(jboolean)isResponseExpected
withComStSt25sdkFtmprotocolFtmProtocol_TransferProgressionListener:(id<ComStSt25sdkFtmprotocolFtmProtocol_TransferProgressionListener>)transferProgressionListener
withComStSt25sdkFtmprotocolFtmProtocol_TransferCompletionListener:(id<ComStSt25sdkFtmprotocolFtmProtocol_TransferCompletionListener>)transferCompletionListener
                         withInt:(jint)timeOutInMs;

- (void)sendFtmDataWithByteArray:(IOSByteArray *)data
                     withBoolean:(jboolean)isErrorControlNeeded
                     withBoolean:(jboolean)isResponseExpected
withComStSt25sdkFtmprotocolFtmProtocol_TransferProgressionListener:(id<ComStSt25sdkFtmprotocolFtmProtocol_TransferProgressionListener>)transferProgressionListener
withComStSt25sdkFtmprotocolFtmProtocol_TransferCompletionListener:(id<ComStSt25sdkFtmprotocolFtmProtocol_TransferCompletionListener>)transferCompletionListener
                         withInt:(jint)timeOutInMs
                        withByte:(jbyte)flag;

- (IOSByteArray *)sendFtmDataAndWaitForCompletionWithByteArray:(IOSByteArray *)data
                                                   withBoolean:(jboolean)isErrorControlNeeded
                                                   withBoolean:(jboolean)isResponseExpected
withComStSt25sdkFtmprotocolFtmProtocol_TransferProgressionListener:(id<ComStSt25sdkFtmprotocolFtmProtocol_TransferProgressionListener>)transferProgressionListener
                                                       withInt:(jint)timeOutInMs;

- (IOSByteArray *)sendFtmDataAndWaitForCompletionWithByteArray:(IOSByteArray *)data
                                                   withBoolean:(jboolean)isErrorControlNeeded
                                                   withBoolean:(jboolean)isResponseExpected
withComStSt25sdkFtmprotocolFtmProtocol_TransferProgressionListener:(id<ComStSt25sdkFtmprotocolFtmProtocol_TransferProgressionListener>)transferProgressionListener
                                                       withInt:(jint)timeOutInMs
                                                      withByte:(jbyte)flag;

- (void)setFastCommandUsageWithBoolean:(jboolean)useFastCommands;

- (void)setFtmProtocolHookWithComStSt25sdkFtmprotocolFtmProtocol_FtmProtocolHook:(id<ComStSt25sdkFtmprotocolFtmProtocol_FtmProtocolHook>)ftmProtocolHook;

- (void)setMinTimeInMsBetweenReceiveCmdsWithLong:(jlong)timeInMs;

- (void)setMinTimeInMsBetweenSendCmdsWithLong:(jlong)timeInMs;

- (void)setMinTimeInMsWhenWaitingAckWithLong:(jlong)minTimeInMsWhenWaitingAck;

- (void)setNbrOfRetriesInCaseOfErrorWithInt:(jint)nbrOfRetriesInCaseOfError;

- (void)setSegmentLengthWithInt:(jint)nbrOfPacketsPerSegment;

- (void)setTagWithComStSt25sdkType5St25dvST25DVTag:(ComStSt25sdkType5St25dvST25DVTag *)st25DVTag;

- (void)stopFtmThread;

// Disallowed inherited constructors, do not use.

- (instancetype __nonnull)init NS_UNAVAILABLE;

@end

J2OBJC_EMPTY_STATIC_INIT(ComStSt25sdkFtmprotocolFtmProtocol)

J2OBJC_FIELD_SETTER(ComStSt25sdkFtmprotocolFtmProtocol, ftmSemaphore_, JavaUtilConcurrentSemaphore *)

inline jint ComStSt25sdkFtmprotocolFtmProtocol_get_DEFAULT_NUMBER_OF_PACKETS_PER_SEGMENT(void);
#define ComStSt25sdkFtmprotocolFtmProtocol_DEFAULT_NUMBER_OF_PACKETS_PER_SEGMENT 20
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkFtmprotocolFtmProtocol, DEFAULT_NUMBER_OF_PACKETS_PER_SEGMENT, jint)

inline NSString *ComStSt25sdkFtmprotocolFtmProtocol_get_TAG(void);
/*! INTERNAL ONLY - Use accessor function from above. */
FOUNDATION_EXPORT NSString *ComStSt25sdkFtmprotocolFtmProtocol_TAG;
J2OBJC_STATIC_FIELD_OBJ_FINAL(ComStSt25sdkFtmprotocolFtmProtocol, TAG, NSString *)

FOUNDATION_EXPORT void ComStSt25sdkFtmprotocolFtmProtocol_initWithComStSt25sdkType5St25dvST25DVTag_(ComStSt25sdkFtmprotocolFtmProtocol *self, ComStSt25sdkType5St25dvST25DVTag *st25DVTag);

FOUNDATION_EXPORT ComStSt25sdkFtmprotocolFtmProtocol *new_ComStSt25sdkFtmprotocolFtmProtocol_initWithComStSt25sdkType5St25dvST25DVTag_(ComStSt25sdkType5St25dvST25DVTag *st25DVTag) NS_RETURNS_RETAINED;

FOUNDATION_EXPORT ComStSt25sdkFtmprotocolFtmProtocol *create_ComStSt25sdkFtmprotocolFtmProtocol_initWithComStSt25sdkType5St25dvST25DVTag_(ComStSt25sdkType5St25dvST25DVTag *st25DVTag);

J2OBJC_TYPE_LITERAL_HEADER(ComStSt25sdkFtmprotocolFtmProtocol)

#endif

#if !defined (ComStSt25sdkFtmprotocolFtmProtocol_TransferStatus_) && (INCLUDE_ALL_ComStSt25sdkFtmprotocolFtmProtocol || defined(INCLUDE_ComStSt25sdkFtmprotocolFtmProtocol_TransferStatus))
#define ComStSt25sdkFtmprotocolFtmProtocol_TransferStatus_

#define RESTRICT_JavaLangEnum 1
#define INCLUDE_JavaLangEnum 1
#include "java/lang/Enum.h"

@class IOSObjectArray;

typedef NS_ENUM(NSUInteger, ComStSt25sdkFtmprotocolFtmProtocol_TransferStatus_Enum) {
  ComStSt25sdkFtmprotocolFtmProtocol_TransferStatus_Enum_TRANSFER_OK = 0,
  ComStSt25sdkFtmprotocolFtmProtocol_TransferStatus_Enum_TRANSFER_FAILED = 1,
  ComStSt25sdkFtmprotocolFtmProtocol_TransferStatus_Enum_TRANSFER_CANCELLED = 2,
};

@interface ComStSt25sdkFtmprotocolFtmProtocol_TransferStatus : JavaLangEnum

@property (readonly, class, nonnull) ComStSt25sdkFtmprotocolFtmProtocol_TransferStatus *TRANSFER_OK NS_SWIFT_NAME(TRANSFER_OK);
@property (readonly, class, nonnull) ComStSt25sdkFtmprotocolFtmProtocol_TransferStatus *TRANSFER_FAILED NS_SWIFT_NAME(TRANSFER_FAILED);
@property (readonly, class, nonnull) ComStSt25sdkFtmprotocolFtmProtocol_TransferStatus *TRANSFER_CANCELLED NS_SWIFT_NAME(TRANSFER_CANCELLED);
+ (ComStSt25sdkFtmprotocolFtmProtocol_TransferStatus * __nonnull)TRANSFER_OK;

+ (ComStSt25sdkFtmprotocolFtmProtocol_TransferStatus * __nonnull)TRANSFER_FAILED;

+ (ComStSt25sdkFtmprotocolFtmProtocol_TransferStatus * __nonnull)TRANSFER_CANCELLED;

#pragma mark Public

+ (ComStSt25sdkFtmprotocolFtmProtocol_TransferStatus *)valueOfWithNSString:(NSString *)name;

+ (IOSObjectArray *)values;

#pragma mark Package-Private

- (ComStSt25sdkFtmprotocolFtmProtocol_TransferStatus_Enum)toNSEnum;

@end

J2OBJC_STATIC_INIT(ComStSt25sdkFtmprotocolFtmProtocol_TransferStatus)

/*! INTERNAL ONLY - Use enum accessors declared below. */
FOUNDATION_EXPORT ComStSt25sdkFtmprotocolFtmProtocol_TransferStatus *ComStSt25sdkFtmprotocolFtmProtocol_TransferStatus_values_[];

inline ComStSt25sdkFtmprotocolFtmProtocol_TransferStatus *ComStSt25sdkFtmprotocolFtmProtocol_TransferStatus_get_TRANSFER_OK(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkFtmprotocolFtmProtocol_TransferStatus, TRANSFER_OK)

inline ComStSt25sdkFtmprotocolFtmProtocol_TransferStatus *ComStSt25sdkFtmprotocolFtmProtocol_TransferStatus_get_TRANSFER_FAILED(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkFtmprotocolFtmProtocol_TransferStatus, TRANSFER_FAILED)

inline ComStSt25sdkFtmprotocolFtmProtocol_TransferStatus *ComStSt25sdkFtmprotocolFtmProtocol_TransferStatus_get_TRANSFER_CANCELLED(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkFtmprotocolFtmProtocol_TransferStatus, TRANSFER_CANCELLED)

FOUNDATION_EXPORT IOSObjectArray *ComStSt25sdkFtmprotocolFtmProtocol_TransferStatus_values(void);

FOUNDATION_EXPORT ComStSt25sdkFtmprotocolFtmProtocol_TransferStatus *ComStSt25sdkFtmprotocolFtmProtocol_TransferStatus_valueOfWithNSString_(NSString *name);

FOUNDATION_EXPORT ComStSt25sdkFtmprotocolFtmProtocol_TransferStatus *ComStSt25sdkFtmprotocolFtmProtocol_TransferStatus_fromOrdinal(NSUInteger ordinal);

J2OBJC_TYPE_LITERAL_HEADER(ComStSt25sdkFtmprotocolFtmProtocol_TransferStatus)

#endif

#if !defined (ComStSt25sdkFtmprotocolFtmProtocol_TestPoint_) && (INCLUDE_ALL_ComStSt25sdkFtmprotocolFtmProtocol || defined(INCLUDE_ComStSt25sdkFtmprotocolFtmProtocol_TestPoint))
#define ComStSt25sdkFtmprotocolFtmProtocol_TestPoint_

#define RESTRICT_JavaLangEnum 1
#define INCLUDE_JavaLangEnum 1
#include "java/lang/Enum.h"

@class IOSObjectArray;

typedef NS_ENUM(NSUInteger, ComStSt25sdkFtmprotocolFtmProtocol_TestPoint_Enum) {
  ComStSt25sdkFtmprotocolFtmProtocol_TestPoint_Enum_PACKET_PREPARED = 0,
  ComStSt25sdkFtmprotocolFtmProtocol_TestPoint_Enum_BEFORE_READING_ACK = 1,
  ComStSt25sdkFtmprotocolFtmProtocol_TestPoint_Enum_AFTER_READING_ACK = 2,
  ComStSt25sdkFtmprotocolFtmProtocol_TestPoint_Enum_BEFORE_SENDING_SEGMENT_START = 3,
  ComStSt25sdkFtmprotocolFtmProtocol_TestPoint_Enum_BEFORE_SENDING_SEGMENT_MIDDLE = 4,
  ComStSt25sdkFtmprotocolFtmProtocol_TestPoint_Enum_BEFORE_SENDING_SEGMENT_END = 5,
  ComStSt25sdkFtmprotocolFtmProtocol_TestPoint_Enum_BEFORE_SENDING_PACKET = 6,
  ComStSt25sdkFtmprotocolFtmProtocol_TestPoint_Enum_BEFORE_RESENDING_PACKET = 7,
  ComStSt25sdkFtmprotocolFtmProtocol_TestPoint_Enum_AFTER_SENDING_SEGMENT_START = 8,
  ComStSt25sdkFtmprotocolFtmProtocol_TestPoint_Enum_AFTER_SENDING_SEGMENT_MIDDLE = 9,
  ComStSt25sdkFtmprotocolFtmProtocol_TestPoint_Enum_AFTER_SENDING_SEGMENT_END = 10,
  ComStSt25sdkFtmprotocolFtmProtocol_TestPoint_Enum_BEFORE_READING_PACKET = 11,
  ComStSt25sdkFtmprotocolFtmProtocol_TestPoint_Enum_CHECKING_IF_MB_AVAILABLE_FOR_READING = 12,
  ComStSt25sdkFtmprotocolFtmProtocol_TestPoint_Enum_CHECKING_SEGMENT_CRC = 13,
  ComStSt25sdkFtmprotocolFtmProtocol_TestPoint_Enum_BEFORE_SENDING_ACK = 14,
  ComStSt25sdkFtmprotocolFtmProtocol_TestPoint_Enum_AFTER_SENDING_ACK = 15,
  ComStSt25sdkFtmprotocolFtmProtocol_TestPoint_Enum_AFTER_READING_SEGMENT_START = 16,
  ComStSt25sdkFtmprotocolFtmProtocol_TestPoint_Enum_AFTER_READING_SEGMENT_MIDDLE = 17,
  ComStSt25sdkFtmprotocolFtmProtocol_TestPoint_Enum_AFTER_READING_SEGMENT_END = 18,
};

@interface ComStSt25sdkFtmprotocolFtmProtocol_TestPoint : JavaLangEnum

@property (readonly, class, nonnull) ComStSt25sdkFtmprotocolFtmProtocol_TestPoint *PACKET_PREPARED NS_SWIFT_NAME(PACKET_PREPARED);
@property (readonly, class, nonnull) ComStSt25sdkFtmprotocolFtmProtocol_TestPoint *BEFORE_READING_ACK NS_SWIFT_NAME(BEFORE_READING_ACK);
@property (readonly, class, nonnull) ComStSt25sdkFtmprotocolFtmProtocol_TestPoint *AFTER_READING_ACK NS_SWIFT_NAME(AFTER_READING_ACK);
@property (readonly, class, nonnull) ComStSt25sdkFtmprotocolFtmProtocol_TestPoint *BEFORE_SENDING_SEGMENT_START NS_SWIFT_NAME(BEFORE_SENDING_SEGMENT_START);
@property (readonly, class, nonnull) ComStSt25sdkFtmprotocolFtmProtocol_TestPoint *BEFORE_SENDING_SEGMENT_MIDDLE NS_SWIFT_NAME(BEFORE_SENDING_SEGMENT_MIDDLE);
@property (readonly, class, nonnull) ComStSt25sdkFtmprotocolFtmProtocol_TestPoint *BEFORE_SENDING_SEGMENT_END NS_SWIFT_NAME(BEFORE_SENDING_SEGMENT_END);
@property (readonly, class, nonnull) ComStSt25sdkFtmprotocolFtmProtocol_TestPoint *BEFORE_SENDING_PACKET NS_SWIFT_NAME(BEFORE_SENDING_PACKET);
@property (readonly, class, nonnull) ComStSt25sdkFtmprotocolFtmProtocol_TestPoint *BEFORE_RESENDING_PACKET NS_SWIFT_NAME(BEFORE_RESENDING_PACKET);
@property (readonly, class, nonnull) ComStSt25sdkFtmprotocolFtmProtocol_TestPoint *AFTER_SENDING_SEGMENT_START NS_SWIFT_NAME(AFTER_SENDING_SEGMENT_START);
@property (readonly, class, nonnull) ComStSt25sdkFtmprotocolFtmProtocol_TestPoint *AFTER_SENDING_SEGMENT_MIDDLE NS_SWIFT_NAME(AFTER_SENDING_SEGMENT_MIDDLE);
@property (readonly, class, nonnull) ComStSt25sdkFtmprotocolFtmProtocol_TestPoint *AFTER_SENDING_SEGMENT_END NS_SWIFT_NAME(AFTER_SENDING_SEGMENT_END);
@property (readonly, class, nonnull) ComStSt25sdkFtmprotocolFtmProtocol_TestPoint *BEFORE_READING_PACKET NS_SWIFT_NAME(BEFORE_READING_PACKET);
@property (readonly, class, nonnull) ComStSt25sdkFtmprotocolFtmProtocol_TestPoint *CHECKING_IF_MB_AVAILABLE_FOR_READING NS_SWIFT_NAME(CHECKING_IF_MB_AVAILABLE_FOR_READING);
@property (readonly, class, nonnull) ComStSt25sdkFtmprotocolFtmProtocol_TestPoint *CHECKING_SEGMENT_CRC NS_SWIFT_NAME(CHECKING_SEGMENT_CRC);
@property (readonly, class, nonnull) ComStSt25sdkFtmprotocolFtmProtocol_TestPoint *BEFORE_SENDING_ACK NS_SWIFT_NAME(BEFORE_SENDING_ACK);
@property (readonly, class, nonnull) ComStSt25sdkFtmprotocolFtmProtocol_TestPoint *AFTER_SENDING_ACK NS_SWIFT_NAME(AFTER_SENDING_ACK);
@property (readonly, class, nonnull) ComStSt25sdkFtmprotocolFtmProtocol_TestPoint *AFTER_READING_SEGMENT_START NS_SWIFT_NAME(AFTER_READING_SEGMENT_START);
@property (readonly, class, nonnull) ComStSt25sdkFtmprotocolFtmProtocol_TestPoint *AFTER_READING_SEGMENT_MIDDLE NS_SWIFT_NAME(AFTER_READING_SEGMENT_MIDDLE);
@property (readonly, class, nonnull) ComStSt25sdkFtmprotocolFtmProtocol_TestPoint *AFTER_READING_SEGMENT_END NS_SWIFT_NAME(AFTER_READING_SEGMENT_END);
+ (ComStSt25sdkFtmprotocolFtmProtocol_TestPoint * __nonnull)PACKET_PREPARED;

+ (ComStSt25sdkFtmprotocolFtmProtocol_TestPoint * __nonnull)BEFORE_READING_ACK;

+ (ComStSt25sdkFtmprotocolFtmProtocol_TestPoint * __nonnull)AFTER_READING_ACK;

+ (ComStSt25sdkFtmprotocolFtmProtocol_TestPoint * __nonnull)BEFORE_SENDING_SEGMENT_START;

+ (ComStSt25sdkFtmprotocolFtmProtocol_TestPoint * __nonnull)BEFORE_SENDING_SEGMENT_MIDDLE;

+ (ComStSt25sdkFtmprotocolFtmProtocol_TestPoint * __nonnull)BEFORE_SENDING_SEGMENT_END;

+ (ComStSt25sdkFtmprotocolFtmProtocol_TestPoint * __nonnull)BEFORE_SENDING_PACKET;

+ (ComStSt25sdkFtmprotocolFtmProtocol_TestPoint * __nonnull)BEFORE_RESENDING_PACKET;

+ (ComStSt25sdkFtmprotocolFtmProtocol_TestPoint * __nonnull)AFTER_SENDING_SEGMENT_START;

+ (ComStSt25sdkFtmprotocolFtmProtocol_TestPoint * __nonnull)AFTER_SENDING_SEGMENT_MIDDLE;

+ (ComStSt25sdkFtmprotocolFtmProtocol_TestPoint * __nonnull)AFTER_SENDING_SEGMENT_END;

+ (ComStSt25sdkFtmprotocolFtmProtocol_TestPoint * __nonnull)BEFORE_READING_PACKET;

+ (ComStSt25sdkFtmprotocolFtmProtocol_TestPoint * __nonnull)CHECKING_IF_MB_AVAILABLE_FOR_READING;

+ (ComStSt25sdkFtmprotocolFtmProtocol_TestPoint * __nonnull)CHECKING_SEGMENT_CRC;

+ (ComStSt25sdkFtmprotocolFtmProtocol_TestPoint * __nonnull)BEFORE_SENDING_ACK;

+ (ComStSt25sdkFtmprotocolFtmProtocol_TestPoint * __nonnull)AFTER_SENDING_ACK;

+ (ComStSt25sdkFtmprotocolFtmProtocol_TestPoint * __nonnull)AFTER_READING_SEGMENT_START;

+ (ComStSt25sdkFtmprotocolFtmProtocol_TestPoint * __nonnull)AFTER_READING_SEGMENT_MIDDLE;

+ (ComStSt25sdkFtmprotocolFtmProtocol_TestPoint * __nonnull)AFTER_READING_SEGMENT_END;

#pragma mark Public

+ (ComStSt25sdkFtmprotocolFtmProtocol_TestPoint *)valueOfWithNSString:(NSString *)name;

+ (IOSObjectArray *)values;

#pragma mark Package-Private

- (ComStSt25sdkFtmprotocolFtmProtocol_TestPoint_Enum)toNSEnum;

@end

J2OBJC_STATIC_INIT(ComStSt25sdkFtmprotocolFtmProtocol_TestPoint)

/*! INTERNAL ONLY - Use enum accessors declared below. */
FOUNDATION_EXPORT ComStSt25sdkFtmprotocolFtmProtocol_TestPoint *ComStSt25sdkFtmprotocolFtmProtocol_TestPoint_values_[];

inline ComStSt25sdkFtmprotocolFtmProtocol_TestPoint *ComStSt25sdkFtmprotocolFtmProtocol_TestPoint_get_PACKET_PREPARED(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkFtmprotocolFtmProtocol_TestPoint, PACKET_PREPARED)

inline ComStSt25sdkFtmprotocolFtmProtocol_TestPoint *ComStSt25sdkFtmprotocolFtmProtocol_TestPoint_get_BEFORE_READING_ACK(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkFtmprotocolFtmProtocol_TestPoint, BEFORE_READING_ACK)

inline ComStSt25sdkFtmprotocolFtmProtocol_TestPoint *ComStSt25sdkFtmprotocolFtmProtocol_TestPoint_get_AFTER_READING_ACK(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkFtmprotocolFtmProtocol_TestPoint, AFTER_READING_ACK)

inline ComStSt25sdkFtmprotocolFtmProtocol_TestPoint *ComStSt25sdkFtmprotocolFtmProtocol_TestPoint_get_BEFORE_SENDING_SEGMENT_START(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkFtmprotocolFtmProtocol_TestPoint, BEFORE_SENDING_SEGMENT_START)

inline ComStSt25sdkFtmprotocolFtmProtocol_TestPoint *ComStSt25sdkFtmprotocolFtmProtocol_TestPoint_get_BEFORE_SENDING_SEGMENT_MIDDLE(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkFtmprotocolFtmProtocol_TestPoint, BEFORE_SENDING_SEGMENT_MIDDLE)

inline ComStSt25sdkFtmprotocolFtmProtocol_TestPoint *ComStSt25sdkFtmprotocolFtmProtocol_TestPoint_get_BEFORE_SENDING_SEGMENT_END(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkFtmprotocolFtmProtocol_TestPoint, BEFORE_SENDING_SEGMENT_END)

inline ComStSt25sdkFtmprotocolFtmProtocol_TestPoint *ComStSt25sdkFtmprotocolFtmProtocol_TestPoint_get_BEFORE_SENDING_PACKET(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkFtmprotocolFtmProtocol_TestPoint, BEFORE_SENDING_PACKET)

inline ComStSt25sdkFtmprotocolFtmProtocol_TestPoint *ComStSt25sdkFtmprotocolFtmProtocol_TestPoint_get_BEFORE_RESENDING_PACKET(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkFtmprotocolFtmProtocol_TestPoint, BEFORE_RESENDING_PACKET)

inline ComStSt25sdkFtmprotocolFtmProtocol_TestPoint *ComStSt25sdkFtmprotocolFtmProtocol_TestPoint_get_AFTER_SENDING_SEGMENT_START(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkFtmprotocolFtmProtocol_TestPoint, AFTER_SENDING_SEGMENT_START)

inline ComStSt25sdkFtmprotocolFtmProtocol_TestPoint *ComStSt25sdkFtmprotocolFtmProtocol_TestPoint_get_AFTER_SENDING_SEGMENT_MIDDLE(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkFtmprotocolFtmProtocol_TestPoint, AFTER_SENDING_SEGMENT_MIDDLE)

inline ComStSt25sdkFtmprotocolFtmProtocol_TestPoint *ComStSt25sdkFtmprotocolFtmProtocol_TestPoint_get_AFTER_SENDING_SEGMENT_END(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkFtmprotocolFtmProtocol_TestPoint, AFTER_SENDING_SEGMENT_END)

inline ComStSt25sdkFtmprotocolFtmProtocol_TestPoint *ComStSt25sdkFtmprotocolFtmProtocol_TestPoint_get_BEFORE_READING_PACKET(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkFtmprotocolFtmProtocol_TestPoint, BEFORE_READING_PACKET)

inline ComStSt25sdkFtmprotocolFtmProtocol_TestPoint *ComStSt25sdkFtmprotocolFtmProtocol_TestPoint_get_CHECKING_IF_MB_AVAILABLE_FOR_READING(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkFtmprotocolFtmProtocol_TestPoint, CHECKING_IF_MB_AVAILABLE_FOR_READING)

inline ComStSt25sdkFtmprotocolFtmProtocol_TestPoint *ComStSt25sdkFtmprotocolFtmProtocol_TestPoint_get_CHECKING_SEGMENT_CRC(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkFtmprotocolFtmProtocol_TestPoint, CHECKING_SEGMENT_CRC)

inline ComStSt25sdkFtmprotocolFtmProtocol_TestPoint *ComStSt25sdkFtmprotocolFtmProtocol_TestPoint_get_BEFORE_SENDING_ACK(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkFtmprotocolFtmProtocol_TestPoint, BEFORE_SENDING_ACK)

inline ComStSt25sdkFtmprotocolFtmProtocol_TestPoint *ComStSt25sdkFtmprotocolFtmProtocol_TestPoint_get_AFTER_SENDING_ACK(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkFtmprotocolFtmProtocol_TestPoint, AFTER_SENDING_ACK)

inline ComStSt25sdkFtmprotocolFtmProtocol_TestPoint *ComStSt25sdkFtmprotocolFtmProtocol_TestPoint_get_AFTER_READING_SEGMENT_START(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkFtmprotocolFtmProtocol_TestPoint, AFTER_READING_SEGMENT_START)

inline ComStSt25sdkFtmprotocolFtmProtocol_TestPoint *ComStSt25sdkFtmprotocolFtmProtocol_TestPoint_get_AFTER_READING_SEGMENT_MIDDLE(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkFtmprotocolFtmProtocol_TestPoint, AFTER_READING_SEGMENT_MIDDLE)

inline ComStSt25sdkFtmprotocolFtmProtocol_TestPoint *ComStSt25sdkFtmprotocolFtmProtocol_TestPoint_get_AFTER_READING_SEGMENT_END(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkFtmprotocolFtmProtocol_TestPoint, AFTER_READING_SEGMENT_END)

FOUNDATION_EXPORT IOSObjectArray *ComStSt25sdkFtmprotocolFtmProtocol_TestPoint_values(void);

FOUNDATION_EXPORT ComStSt25sdkFtmprotocolFtmProtocol_TestPoint *ComStSt25sdkFtmprotocolFtmProtocol_TestPoint_valueOfWithNSString_(NSString *name);

FOUNDATION_EXPORT ComStSt25sdkFtmprotocolFtmProtocol_TestPoint *ComStSt25sdkFtmprotocolFtmProtocol_TestPoint_fromOrdinal(NSUInteger ordinal);

J2OBJC_TYPE_LITERAL_HEADER(ComStSt25sdkFtmprotocolFtmProtocol_TestPoint)

#endif

#if !defined (ComStSt25sdkFtmprotocolFtmProtocol_FtmProtocolHook_) && (INCLUDE_ALL_ComStSt25sdkFtmprotocolFtmProtocol || defined(INCLUDE_ComStSt25sdkFtmprotocolFtmProtocol_FtmProtocolHook))
#define ComStSt25sdkFtmprotocolFtmProtocol_FtmProtocolHook_

@class ComStSt25sdkFtmprotocolFtmProtocol_TestPoint;
@class IOSByteArray;

@protocol ComStSt25sdkFtmprotocolFtmProtocol_FtmProtocolHook < JavaObject >

- (void)ftmProtocolHookWithComStSt25sdkFtmprotocolFtmProtocol_TestPoint:(ComStSt25sdkFtmprotocolFtmProtocol_TestPoint *)testPoint
                                                          withByteArray:(IOSByteArray *)arg;

@end

J2OBJC_EMPTY_STATIC_INIT(ComStSt25sdkFtmprotocolFtmProtocol_FtmProtocolHook)

J2OBJC_TYPE_LITERAL_HEADER(ComStSt25sdkFtmprotocolFtmProtocol_FtmProtocolHook)

#endif

#if !defined (ComStSt25sdkFtmprotocolFtmProtocol_TransferProgressionListener_) && (INCLUDE_ALL_ComStSt25sdkFtmprotocolFtmProtocol || defined(INCLUDE_ComStSt25sdkFtmprotocolFtmProtocol_TransferProgressionListener))
#define ComStSt25sdkFtmprotocolFtmProtocol_TransferProgressionListener_

#define RESTRICT_JavaUtilEventListener 1
#define INCLUDE_JavaUtilEventListener 1
#include "java/util/EventListener.h"

@protocol ComStSt25sdkFtmprotocolFtmProtocol_TransferProgressionListener < JavaUtilEventListener, JavaObject >

- (void)transmissionProgressWithInt:(jint)transmittedBytes
                            withInt:(jint)acknowledgedBytes
                            withInt:(jint)totalSize;

- (void)receptionProgressWithInt:(jint)receivedBytes
                         withInt:(jint)acknowledgedBytes
                         withInt:(jint)totalSize;

@end

J2OBJC_EMPTY_STATIC_INIT(ComStSt25sdkFtmprotocolFtmProtocol_TransferProgressionListener)

J2OBJC_TYPE_LITERAL_HEADER(ComStSt25sdkFtmprotocolFtmProtocol_TransferProgressionListener)

#endif

#if !defined (ComStSt25sdkFtmprotocolFtmProtocol_TransferCompletionListener_) && (INCLUDE_ALL_ComStSt25sdkFtmprotocolFtmProtocol || defined(INCLUDE_ComStSt25sdkFtmprotocolFtmProtocol_TransferCompletionListener))
#define ComStSt25sdkFtmprotocolFtmProtocol_TransferCompletionListener_

#define RESTRICT_JavaUtilEventListener 1
#define INCLUDE_JavaUtilEventListener 1
#include "java/util/EventListener.h"

@class ComStSt25sdkFtmprotocolFtmProtocol_TransferStatus;
@class IOSByteArray;

@protocol ComStSt25sdkFtmprotocolFtmProtocol_TransferCompletionListener < JavaUtilEventListener, JavaObject >

- (void)transferDoneWithComStSt25sdkFtmprotocolFtmProtocol_TransferStatus:(ComStSt25sdkFtmprotocolFtmProtocol_TransferStatus *)transferStatus
                                                            withByteArray:(IOSByteArray *)response;

@end

J2OBJC_EMPTY_STATIC_INIT(ComStSt25sdkFtmprotocolFtmProtocol_TransferCompletionListener)

J2OBJC_TYPE_LITERAL_HEADER(ComStSt25sdkFtmprotocolFtmProtocol_TransferCompletionListener)

#endif

#if !defined (ComStSt25sdkFtmprotocolFtmProtocol_State_) && (INCLUDE_ALL_ComStSt25sdkFtmprotocolFtmProtocol || defined(INCLUDE_ComStSt25sdkFtmprotocolFtmProtocol_State))
#define ComStSt25sdkFtmprotocolFtmProtocol_State_

#define RESTRICT_JavaLangEnum 1
#define INCLUDE_JavaLangEnum 1
#include "java/lang/Enum.h"

@class IOSObjectArray;

typedef NS_ENUM(NSUInteger, ComStSt25sdkFtmprotocolFtmProtocol_State_Enum) {
  ComStSt25sdkFtmprotocolFtmProtocol_State_Enum_IDLE = 0,
  ComStSt25sdkFtmprotocolFtmProtocol_State_Enum_PREPARE_PACKET = 1,
  ComStSt25sdkFtmprotocolFtmProtocol_State_Enum_SEND_PACKET = 2,
  ComStSt25sdkFtmprotocolFtmProtocol_State_Enum_WAIT_FOR_ACK = 3,
  ComStSt25sdkFtmprotocolFtmProtocol_State_Enum_RECEIVE_PACKET = 4,
  ComStSt25sdkFtmprotocolFtmProtocol_State_Enum_SEND_ACK = 5,
};

@interface ComStSt25sdkFtmprotocolFtmProtocol_State : JavaLangEnum

@property (readonly, class, nonnull) ComStSt25sdkFtmprotocolFtmProtocol_State *IDLE NS_SWIFT_NAME(IDLE);
@property (readonly, class, nonnull) ComStSt25sdkFtmprotocolFtmProtocol_State *PREPARE_PACKET NS_SWIFT_NAME(PREPARE_PACKET);
@property (readonly, class, nonnull) ComStSt25sdkFtmprotocolFtmProtocol_State *SEND_PACKET NS_SWIFT_NAME(SEND_PACKET);
@property (readonly, class, nonnull) ComStSt25sdkFtmprotocolFtmProtocol_State *WAIT_FOR_ACK NS_SWIFT_NAME(WAIT_FOR_ACK);
@property (readonly, class, nonnull) ComStSt25sdkFtmprotocolFtmProtocol_State *RECEIVE_PACKET NS_SWIFT_NAME(RECEIVE_PACKET);
@property (readonly, class, nonnull) ComStSt25sdkFtmprotocolFtmProtocol_State *SEND_ACK NS_SWIFT_NAME(SEND_ACK);
+ (ComStSt25sdkFtmprotocolFtmProtocol_State * __nonnull)IDLE;

+ (ComStSt25sdkFtmprotocolFtmProtocol_State * __nonnull)PREPARE_PACKET;

+ (ComStSt25sdkFtmprotocolFtmProtocol_State * __nonnull)SEND_PACKET;

+ (ComStSt25sdkFtmprotocolFtmProtocol_State * __nonnull)WAIT_FOR_ACK;

+ (ComStSt25sdkFtmprotocolFtmProtocol_State * __nonnull)RECEIVE_PACKET;

+ (ComStSt25sdkFtmprotocolFtmProtocol_State * __nonnull)SEND_ACK;

#pragma mark Public

+ (ComStSt25sdkFtmprotocolFtmProtocol_State *)valueOfWithNSString:(NSString *)name;

+ (IOSObjectArray *)values;

#pragma mark Package-Private

- (ComStSt25sdkFtmprotocolFtmProtocol_State_Enum)toNSEnum;

@end

J2OBJC_STATIC_INIT(ComStSt25sdkFtmprotocolFtmProtocol_State)

/*! INTERNAL ONLY - Use enum accessors declared below. */
FOUNDATION_EXPORT ComStSt25sdkFtmprotocolFtmProtocol_State *ComStSt25sdkFtmprotocolFtmProtocol_State_values_[];

inline ComStSt25sdkFtmprotocolFtmProtocol_State *ComStSt25sdkFtmprotocolFtmProtocol_State_get_IDLE(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkFtmprotocolFtmProtocol_State, IDLE)

inline ComStSt25sdkFtmprotocolFtmProtocol_State *ComStSt25sdkFtmprotocolFtmProtocol_State_get_PREPARE_PACKET(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkFtmprotocolFtmProtocol_State, PREPARE_PACKET)

inline ComStSt25sdkFtmprotocolFtmProtocol_State *ComStSt25sdkFtmprotocolFtmProtocol_State_get_SEND_PACKET(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkFtmprotocolFtmProtocol_State, SEND_PACKET)

inline ComStSt25sdkFtmprotocolFtmProtocol_State *ComStSt25sdkFtmprotocolFtmProtocol_State_get_WAIT_FOR_ACK(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkFtmprotocolFtmProtocol_State, WAIT_FOR_ACK)

inline ComStSt25sdkFtmprotocolFtmProtocol_State *ComStSt25sdkFtmprotocolFtmProtocol_State_get_RECEIVE_PACKET(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkFtmprotocolFtmProtocol_State, RECEIVE_PACKET)

inline ComStSt25sdkFtmprotocolFtmProtocol_State *ComStSt25sdkFtmprotocolFtmProtocol_State_get_SEND_ACK(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkFtmprotocolFtmProtocol_State, SEND_ACK)

FOUNDATION_EXPORT IOSObjectArray *ComStSt25sdkFtmprotocolFtmProtocol_State_values(void);

FOUNDATION_EXPORT ComStSt25sdkFtmprotocolFtmProtocol_State *ComStSt25sdkFtmprotocolFtmProtocol_State_valueOfWithNSString_(NSString *name);

FOUNDATION_EXPORT ComStSt25sdkFtmprotocolFtmProtocol_State *ComStSt25sdkFtmprotocolFtmProtocol_State_fromOrdinal(NSUInteger ordinal);

J2OBJC_TYPE_LITERAL_HEADER(ComStSt25sdkFtmprotocolFtmProtocol_State)

#endif

#if !defined (ComStSt25sdkFtmprotocolFtmProtocol_ReceptionStatus_) && (INCLUDE_ALL_ComStSt25sdkFtmprotocolFtmProtocol || defined(INCLUDE_ComStSt25sdkFtmprotocolFtmProtocol_ReceptionStatus))
#define ComStSt25sdkFtmprotocolFtmProtocol_ReceptionStatus_

#define RESTRICT_JavaLangEnum 1
#define INCLUDE_JavaLangEnum 1
#include "java/lang/Enum.h"

@class IOSObjectArray;

typedef NS_ENUM(NSUInteger, ComStSt25sdkFtmprotocolFtmProtocol_ReceptionStatus_Enum) {
  ComStSt25sdkFtmprotocolFtmProtocol_ReceptionStatus_Enum_WAITING_FOR_FIRST_PACKET = 0,
  ComStSt25sdkFtmprotocolFtmProtocol_ReceptionStatus_Enum_WAITING_FOR_RETRANSMISSION = 1,
  ComStSt25sdkFtmprotocolFtmProtocol_ReceptionStatus_Enum_WAITING_FOR_FIRST_SEGMENT_PACKET = 2,
  ComStSt25sdkFtmprotocolFtmProtocol_ReceptionStatus_Enum_WAITING_FOR_NEXT_SEGMENT_PACKET = 3,
  ComStSt25sdkFtmprotocolFtmProtocol_ReceptionStatus_Enum_WAITING_FOR_PACKETS_WITHOUT_ACK = 4,
};

@interface ComStSt25sdkFtmprotocolFtmProtocol_ReceptionStatus : JavaLangEnum

@property (readonly, class, nonnull) ComStSt25sdkFtmprotocolFtmProtocol_ReceptionStatus *WAITING_FOR_FIRST_PACKET NS_SWIFT_NAME(WAITING_FOR_FIRST_PACKET);
@property (readonly, class, nonnull) ComStSt25sdkFtmprotocolFtmProtocol_ReceptionStatus *WAITING_FOR_RETRANSMISSION NS_SWIFT_NAME(WAITING_FOR_RETRANSMISSION);
@property (readonly, class, nonnull) ComStSt25sdkFtmprotocolFtmProtocol_ReceptionStatus *WAITING_FOR_FIRST_SEGMENT_PACKET NS_SWIFT_NAME(WAITING_FOR_FIRST_SEGMENT_PACKET);
@property (readonly, class, nonnull) ComStSt25sdkFtmprotocolFtmProtocol_ReceptionStatus *WAITING_FOR_NEXT_SEGMENT_PACKET NS_SWIFT_NAME(WAITING_FOR_NEXT_SEGMENT_PACKET);
@property (readonly, class, nonnull) ComStSt25sdkFtmprotocolFtmProtocol_ReceptionStatus *WAITING_FOR_PACKETS_WITHOUT_ACK NS_SWIFT_NAME(WAITING_FOR_PACKETS_WITHOUT_ACK);
+ (ComStSt25sdkFtmprotocolFtmProtocol_ReceptionStatus * __nonnull)WAITING_FOR_FIRST_PACKET;

+ (ComStSt25sdkFtmprotocolFtmProtocol_ReceptionStatus * __nonnull)WAITING_FOR_RETRANSMISSION;

+ (ComStSt25sdkFtmprotocolFtmProtocol_ReceptionStatus * __nonnull)WAITING_FOR_FIRST_SEGMENT_PACKET;

+ (ComStSt25sdkFtmprotocolFtmProtocol_ReceptionStatus * __nonnull)WAITING_FOR_NEXT_SEGMENT_PACKET;

+ (ComStSt25sdkFtmprotocolFtmProtocol_ReceptionStatus * __nonnull)WAITING_FOR_PACKETS_WITHOUT_ACK;

#pragma mark Public

+ (ComStSt25sdkFtmprotocolFtmProtocol_ReceptionStatus *)valueOfWithNSString:(NSString *)name;

+ (IOSObjectArray *)values;

#pragma mark Package-Private

- (ComStSt25sdkFtmprotocolFtmProtocol_ReceptionStatus_Enum)toNSEnum;

@end

J2OBJC_STATIC_INIT(ComStSt25sdkFtmprotocolFtmProtocol_ReceptionStatus)

/*! INTERNAL ONLY - Use enum accessors declared below. */
FOUNDATION_EXPORT ComStSt25sdkFtmprotocolFtmProtocol_ReceptionStatus *ComStSt25sdkFtmprotocolFtmProtocol_ReceptionStatus_values_[];

inline ComStSt25sdkFtmprotocolFtmProtocol_ReceptionStatus *ComStSt25sdkFtmprotocolFtmProtocol_ReceptionStatus_get_WAITING_FOR_FIRST_PACKET(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkFtmprotocolFtmProtocol_ReceptionStatus, WAITING_FOR_FIRST_PACKET)

inline ComStSt25sdkFtmprotocolFtmProtocol_ReceptionStatus *ComStSt25sdkFtmprotocolFtmProtocol_ReceptionStatus_get_WAITING_FOR_RETRANSMISSION(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkFtmprotocolFtmProtocol_ReceptionStatus, WAITING_FOR_RETRANSMISSION)

inline ComStSt25sdkFtmprotocolFtmProtocol_ReceptionStatus *ComStSt25sdkFtmprotocolFtmProtocol_ReceptionStatus_get_WAITING_FOR_FIRST_SEGMENT_PACKET(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkFtmprotocolFtmProtocol_ReceptionStatus, WAITING_FOR_FIRST_SEGMENT_PACKET)

inline ComStSt25sdkFtmprotocolFtmProtocol_ReceptionStatus *ComStSt25sdkFtmprotocolFtmProtocol_ReceptionStatus_get_WAITING_FOR_NEXT_SEGMENT_PACKET(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkFtmprotocolFtmProtocol_ReceptionStatus, WAITING_FOR_NEXT_SEGMENT_PACKET)

inline ComStSt25sdkFtmprotocolFtmProtocol_ReceptionStatus *ComStSt25sdkFtmprotocolFtmProtocol_ReceptionStatus_get_WAITING_FOR_PACKETS_WITHOUT_ACK(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkFtmprotocolFtmProtocol_ReceptionStatus, WAITING_FOR_PACKETS_WITHOUT_ACK)

FOUNDATION_EXPORT IOSObjectArray *ComStSt25sdkFtmprotocolFtmProtocol_ReceptionStatus_values(void);

FOUNDATION_EXPORT ComStSt25sdkFtmprotocolFtmProtocol_ReceptionStatus *ComStSt25sdkFtmprotocolFtmProtocol_ReceptionStatus_valueOfWithNSString_(NSString *name);

FOUNDATION_EXPORT ComStSt25sdkFtmprotocolFtmProtocol_ReceptionStatus *ComStSt25sdkFtmprotocolFtmProtocol_ReceptionStatus_fromOrdinal(NSUInteger ordinal);

J2OBJC_TYPE_LITERAL_HEADER(ComStSt25sdkFtmprotocolFtmProtocol_ReceptionStatus)

#endif


#if __has_feature(nullability)
#pragma clang diagnostic pop
#endif
#pragma pop_macro("INCLUDE_ALL_ComStSt25sdkFtmprotocolFtmProtocol")
