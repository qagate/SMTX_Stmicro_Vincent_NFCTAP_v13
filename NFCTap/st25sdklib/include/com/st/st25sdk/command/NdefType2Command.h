//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: st25sdk_ios/command/NdefType2Command.java
//

#include "J2ObjC_header.h"

#pragma push_macro("INCLUDE_ALL_ComStSt25sdkCommandNdefType2Command")
#ifdef RESTRICT_ComStSt25sdkCommandNdefType2Command
#define INCLUDE_ALL_ComStSt25sdkCommandNdefType2Command 0
#else
#define INCLUDE_ALL_ComStSt25sdkCommandNdefType2Command 1
#endif
#undef RESTRICT_ComStSt25sdkCommandNdefType2Command

#if __has_feature(nullability)
#pragma clang diagnostic push
#pragma GCC diagnostic ignored "-Wnullability"
#pragma GCC diagnostic ignored "-Wnullability-completeness"
#endif

#if !defined (ComStSt25sdkCommandNdefType2Command_) && (INCLUDE_ALL_ComStSt25sdkCommandNdefType2Command || defined(INCLUDE_ComStSt25sdkCommandNdefType2Command))
#define ComStSt25sdkCommandNdefType2Command_

#define RESTRICT_ComStSt25sdkCommandType2Command 1
#define INCLUDE_ComStSt25sdkCommandType2Command 1
#include "com/st/st25sdk/command/Type2Command.h"

@class ComStSt25sdkNdefNDEFMsg;
@class IOSByteArray;
@protocol ComStSt25sdkRFReaderInterface;
@protocol JavaUtilList;

@interface ComStSt25sdkCommandNdefType2Command : ComStSt25sdkCommandType2Command

#pragma mark Public

- (instancetype __nonnull)initWithComStSt25sdkRFReaderInterface:(id<ComStSt25sdkRFReaderInterface>)reader;

- (IOSByteArray *)readBytesFromTlvsAreaWithInt:(jint)byteAddress
                                       withInt:(jint)nbOfBytesToRead
                              withJavaUtilList:(id<JavaUtilList>)areasToSkip;

- (ComStSt25sdkNdefNDEFMsg *)readNdefMessageWithInt:(jint)ndefStartAddress
                                   withJavaUtilList:(id<JavaUtilList>)areasToSkip;

- (void)writeBytesInTlvsAreaWithInt:(jint)byteAddress
                      withByteArray:(IOSByteArray *)data
                   withJavaUtilList:(id<JavaUtilList>)areasToSkip;

- (void)writeNdefMessageWithInt:(jint)byteAddress
    withComStSt25sdkNdefNDEFMsg:(ComStSt25sdkNdefNDEFMsg *)msg;

- (void)writeNdefMessageWithInt:(jint)ndefStartAddress
    withComStSt25sdkNdefNDEFMsg:(ComStSt25sdkNdefNDEFMsg *)msg
               withJavaUtilList:(id<JavaUtilList>)areasToSkip;

// Disallowed inherited constructors, do not use.

- (instancetype __nonnull)initWithComStSt25sdkRFReaderInterface:(id<ComStSt25sdkRFReaderInterface>)arg0
                                                        withInt:(jint)arg1
                                                        withInt:(jint)arg2
                                                        withInt:(jint)arg3 NS_UNAVAILABLE;

@end

J2OBJC_EMPTY_STATIC_INIT(ComStSt25sdkCommandNdefType2Command)

FOUNDATION_EXPORT void ComStSt25sdkCommandNdefType2Command_initWithComStSt25sdkRFReaderInterface_(ComStSt25sdkCommandNdefType2Command *self, id<ComStSt25sdkRFReaderInterface> reader);

FOUNDATION_EXPORT ComStSt25sdkCommandNdefType2Command *new_ComStSt25sdkCommandNdefType2Command_initWithComStSt25sdkRFReaderInterface_(id<ComStSt25sdkRFReaderInterface> reader) NS_RETURNS_RETAINED;

FOUNDATION_EXPORT ComStSt25sdkCommandNdefType2Command *create_ComStSt25sdkCommandNdefType2Command_initWithComStSt25sdkRFReaderInterface_(id<ComStSt25sdkRFReaderInterface> reader);

J2OBJC_TYPE_LITERAL_HEADER(ComStSt25sdkCommandNdefType2Command)

#endif


#if __has_feature(nullability)
#pragma clang diagnostic pop
#endif
#pragma pop_macro("INCLUDE_ALL_ComStSt25sdkCommandNdefType2Command")
