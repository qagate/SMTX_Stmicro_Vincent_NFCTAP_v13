//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: st25sdk_ios/command/NdefVicinityCommand.java
//

#include "J2ObjC_header.h"

#pragma push_macro("INCLUDE_ALL_ComStSt25sdkCommandNdefVicinityCommand")
#ifdef RESTRICT_ComStSt25sdkCommandNdefVicinityCommand
#define INCLUDE_ALL_ComStSt25sdkCommandNdefVicinityCommand 0
#else
#define INCLUDE_ALL_ComStSt25sdkCommandNdefVicinityCommand 1
#endif
#undef RESTRICT_ComStSt25sdkCommandNdefVicinityCommand

#if __has_feature(nullability)
#pragma clang diagnostic push
#pragma GCC diagnostic ignored "-Wnullability"
#pragma GCC diagnostic ignored "-Wnullability-completeness"
#endif

#if !defined (ComStSt25sdkCommandNdefVicinityCommand_) && (INCLUDE_ALL_ComStSt25sdkCommandNdefVicinityCommand || defined(INCLUDE_ComStSt25sdkCommandNdefVicinityCommand))
#define ComStSt25sdkCommandNdefVicinityCommand_

#define RESTRICT_ComStSt25sdkCommandVicinityCommand 1
#define INCLUDE_ComStSt25sdkCommandVicinityCommand 1
#include "com/st/st25sdk/command/VicinityCommand.h"

@class ComStSt25sdkNdefNDEFMsg;
@class IOSByteArray;
@protocol ComStSt25sdkRFReaderInterface;

@interface ComStSt25sdkCommandNdefVicinityCommand : ComStSt25sdkCommandVicinityCommand

#pragma mark Public

- (instancetype __nonnull)initWithComStSt25sdkRFReaderInterface:(id<ComStSt25sdkRFReaderInterface>)reader
                                                  withByteArray:(IOSByteArray *)uid;

- (instancetype __nonnull)initWithComStSt25sdkRFReaderInterface:(id<ComStSt25sdkRFReaderInterface>)reader
                                                  withByteArray:(IOSByteArray *)uid
                                                       withByte:(jbyte)flag;

- (instancetype __nonnull)initWithComStSt25sdkRFReaderInterface:(id<ComStSt25sdkRFReaderInterface>)reader
                                                  withByteArray:(IOSByteArray *)uid
                                                       withByte:(jbyte)flag
                                                        withInt:(jint)nbrOfBytesPerBlock;

- (instancetype __nonnull)initWithComStSt25sdkRFReaderInterface:(id<ComStSt25sdkRFReaderInterface>)reader
                                                  withByteArray:(IOSByteArray *)uid
                                                        withInt:(jint)nbrOfBytesPerBlock;

- (ComStSt25sdkNdefNDEFMsg *)readNdefMessageWithInt:(jint)offsetInBlocks
                                           withByte:(jbyte)flag
                                      withByteArray:(IOSByteArray *)uid;

- (void)setTagMaxReadMultipleBlockLengthWithInt:(jint)tagMaxReadMultipleBlockLength;

- (void)writeNdefMessageWithInt:(jint)blockOffset
    withComStSt25sdkNdefNDEFMsg:(ComStSt25sdkNdefNDEFMsg *)msg
                       withByte:(jbyte)flag
                  withByteArray:(IOSByteArray *)uid;

@end

J2OBJC_EMPTY_STATIC_INIT(ComStSt25sdkCommandNdefVicinityCommand)

FOUNDATION_EXPORT void ComStSt25sdkCommandNdefVicinityCommand_initWithComStSt25sdkRFReaderInterface_withByteArray_(ComStSt25sdkCommandNdefVicinityCommand *self, id<ComStSt25sdkRFReaderInterface> reader, IOSByteArray *uid);

FOUNDATION_EXPORT ComStSt25sdkCommandNdefVicinityCommand *new_ComStSt25sdkCommandNdefVicinityCommand_initWithComStSt25sdkRFReaderInterface_withByteArray_(id<ComStSt25sdkRFReaderInterface> reader, IOSByteArray *uid) NS_RETURNS_RETAINED;

FOUNDATION_EXPORT ComStSt25sdkCommandNdefVicinityCommand *create_ComStSt25sdkCommandNdefVicinityCommand_initWithComStSt25sdkRFReaderInterface_withByteArray_(id<ComStSt25sdkRFReaderInterface> reader, IOSByteArray *uid);

FOUNDATION_EXPORT void ComStSt25sdkCommandNdefVicinityCommand_initWithComStSt25sdkRFReaderInterface_withByteArray_withByte_(ComStSt25sdkCommandNdefVicinityCommand *self, id<ComStSt25sdkRFReaderInterface> reader, IOSByteArray *uid, jbyte flag);

FOUNDATION_EXPORT ComStSt25sdkCommandNdefVicinityCommand *new_ComStSt25sdkCommandNdefVicinityCommand_initWithComStSt25sdkRFReaderInterface_withByteArray_withByte_(id<ComStSt25sdkRFReaderInterface> reader, IOSByteArray *uid, jbyte flag) NS_RETURNS_RETAINED;

FOUNDATION_EXPORT ComStSt25sdkCommandNdefVicinityCommand *create_ComStSt25sdkCommandNdefVicinityCommand_initWithComStSt25sdkRFReaderInterface_withByteArray_withByte_(id<ComStSt25sdkRFReaderInterface> reader, IOSByteArray *uid, jbyte flag);

FOUNDATION_EXPORT void ComStSt25sdkCommandNdefVicinityCommand_initWithComStSt25sdkRFReaderInterface_withByteArray_withInt_(ComStSt25sdkCommandNdefVicinityCommand *self, id<ComStSt25sdkRFReaderInterface> reader, IOSByteArray *uid, jint nbrOfBytesPerBlock);

FOUNDATION_EXPORT ComStSt25sdkCommandNdefVicinityCommand *new_ComStSt25sdkCommandNdefVicinityCommand_initWithComStSt25sdkRFReaderInterface_withByteArray_withInt_(id<ComStSt25sdkRFReaderInterface> reader, IOSByteArray *uid, jint nbrOfBytesPerBlock) NS_RETURNS_RETAINED;

FOUNDATION_EXPORT ComStSt25sdkCommandNdefVicinityCommand *create_ComStSt25sdkCommandNdefVicinityCommand_initWithComStSt25sdkRFReaderInterface_withByteArray_withInt_(id<ComStSt25sdkRFReaderInterface> reader, IOSByteArray *uid, jint nbrOfBytesPerBlock);

FOUNDATION_EXPORT void ComStSt25sdkCommandNdefVicinityCommand_initWithComStSt25sdkRFReaderInterface_withByteArray_withByte_withInt_(ComStSt25sdkCommandNdefVicinityCommand *self, id<ComStSt25sdkRFReaderInterface> reader, IOSByteArray *uid, jbyte flag, jint nbrOfBytesPerBlock);

FOUNDATION_EXPORT ComStSt25sdkCommandNdefVicinityCommand *new_ComStSt25sdkCommandNdefVicinityCommand_initWithComStSt25sdkRFReaderInterface_withByteArray_withByte_withInt_(id<ComStSt25sdkRFReaderInterface> reader, IOSByteArray *uid, jbyte flag, jint nbrOfBytesPerBlock) NS_RETURNS_RETAINED;

FOUNDATION_EXPORT ComStSt25sdkCommandNdefVicinityCommand *create_ComStSt25sdkCommandNdefVicinityCommand_initWithComStSt25sdkRFReaderInterface_withByteArray_withByte_withInt_(id<ComStSt25sdkRFReaderInterface> reader, IOSByteArray *uid, jbyte flag, jint nbrOfBytesPerBlock);

J2OBJC_TYPE_LITERAL_HEADER(ComStSt25sdkCommandNdefVicinityCommand)

#endif


#if __has_feature(nullability)
#pragma clang diagnostic pop
#endif
#pragma pop_macro("INCLUDE_ALL_ComStSt25sdkCommandNdefVicinityCommand")