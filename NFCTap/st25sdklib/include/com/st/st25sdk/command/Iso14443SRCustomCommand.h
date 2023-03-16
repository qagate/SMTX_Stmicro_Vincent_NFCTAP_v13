//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: st25sdk_ios/command/Iso14443SRCustomCommand.java
//

#include "J2ObjC_header.h"

#pragma push_macro("INCLUDE_ALL_ComStSt25sdkCommandIso14443SRCustomCommand")
#ifdef RESTRICT_ComStSt25sdkCommandIso14443SRCustomCommand
#define INCLUDE_ALL_ComStSt25sdkCommandIso14443SRCustomCommand 0
#else
#define INCLUDE_ALL_ComStSt25sdkCommandIso14443SRCustomCommand 1
#endif
#undef RESTRICT_ComStSt25sdkCommandIso14443SRCustomCommand

#if __has_feature(nullability)
#pragma clang diagnostic push
#pragma GCC diagnostic ignored "-Wnullability"
#pragma GCC diagnostic ignored "-Wnullability-completeness"
#endif

#if !defined (ComStSt25sdkCommandIso14443SRCustomCommand_) && (INCLUDE_ALL_ComStSt25sdkCommandIso14443SRCustomCommand || defined(INCLUDE_ComStSt25sdkCommandIso14443SRCustomCommand))
#define ComStSt25sdkCommandIso14443SRCustomCommand_

#define RESTRICT_ComStSt25sdkCommandIso14443SRCustomCommandInterface 1
#define INCLUDE_ComStSt25sdkCommandIso14443SRCustomCommandInterface 1
#include "com/st/st25sdk/command/Iso14443SRCustomCommandInterface.h"

@class IOSByteArray;
@protocol ComStSt25sdkRFReaderInterface;

@interface ComStSt25sdkCommandIso14443SRCustomCommand : NSObject < ComStSt25sdkCommandIso14443SRCustomCommandInterface > {
 @public
  id<ComStSt25sdkRFReaderInterface> mReaderInterface_;
}
@property (readonly, class) jint ISO14443SR_CUSTOM_CMD_INITIATE NS_SWIFT_NAME(ISO14443SR_CUSTOM_CMD_INITIATE);
@property (readonly, class) jint ISO14443SR_CUSTOM_CMD_PCALL16 NS_SWIFT_NAME(ISO14443SR_CUSTOM_CMD_PCALL16);
@property (readonly, class) jint ISO14443SR_CUSTOM_CMD_SLOT_MARKER NS_SWIFT_NAME(ISO14443SR_CUSTOM_CMD_SLOT_MARKER);
@property (readonly, class) jint ISO14443SR_CUSTOM_CMD_SELECT NS_SWIFT_NAME(ISO14443SR_CUSTOM_CMD_SELECT);
@property (readonly, class) jint ISO14443SR_CUSTOM_CMD_COMPLETION NS_SWIFT_NAME(ISO14443SR_CUSTOM_CMD_COMPLETION);
@property (readonly, class) jint ISO14443SR_CUSTOM_CMD_RESET_TO_INVENTORY NS_SWIFT_NAME(ISO14443SR_CUSTOM_CMD_RESET_TO_INVENTORY);
@property (readonly, class) jint ISO14443SR_CUSTOM_CMD_READ_BLOCK NS_SWIFT_NAME(ISO14443SR_CUSTOM_CMD_READ_BLOCK);
@property (readonly, class) jint ISO14443SR_CUSTOM_CMD_WRITE_BLOCK NS_SWIFT_NAME(ISO14443SR_CUSTOM_CMD_WRITE_BLOCK);
@property (readonly, class) jint ISO14443SR_CUSTOM_CMD_GET_UID NS_SWIFT_NAME(ISO14443SR_CUSTOM_CMD_GET_UID);

+ (jint)ISO14443SR_CUSTOM_CMD_INITIATE;

+ (jint)ISO14443SR_CUSTOM_CMD_PCALL16;

+ (jint)ISO14443SR_CUSTOM_CMD_SLOT_MARKER;

+ (jint)ISO14443SR_CUSTOM_CMD_SELECT;

+ (jint)ISO14443SR_CUSTOM_CMD_COMPLETION;

+ (jint)ISO14443SR_CUSTOM_CMD_RESET_TO_INVENTORY;

+ (jint)ISO14443SR_CUSTOM_CMD_READ_BLOCK;

+ (jint)ISO14443SR_CUSTOM_CMD_WRITE_BLOCK;

+ (jint)ISO14443SR_CUSTOM_CMD_GET_UID;

#pragma mark Public

- (instancetype __nonnull)initWithComStSt25sdkRFReaderInterface:(id<ComStSt25sdkRFReaderInterface>)reader;

- (instancetype __nonnull)initWithComStSt25sdkRFReaderInterface:(id<ComStSt25sdkRFReaderInterface>)reader
                                                        withInt:(jint)nbrOfBytesPerBlock;

- (IOSByteArray *)anticollisionIso14443SR;

- (void)completion;

- (IOSByteArray *)decrementCounterWithByte:(jbyte)counterAddress
                                   withInt:(jint)decrementValue;

- (IOSByteArray *)decrementReloadCounterWithInt:(jint)decrementValue;

- (IOSByteArray *)getUid;

- (jbyte)initiate OBJC_METHOD_FAMILY_NONE;

- (jbyte)pCall16;

- (IOSByteArray *)readBlockWithByte:(jbyte)blockAddress;

- (IOSByteArray *)readBlocksWithByte:(jbyte)firstBlockAddress
                            withByte:(jbyte)sizeInBlocks;

- (void)resetToInventory;

- (jbyte)selectWithByte:(jbyte)chipID;

- (jbyte)slotMarkerWithByte:(jbyte)slotNumber;

- (IOSByteArray *)transceiveWithNSString:(NSString *)commandName
                           withByteArray:(IOSByteArray *)data;

- (void)writeBlockWithByte:(jbyte)blockAddress
             withByteArray:(IOSByteArray *)buffer;

- (void)writeBlocksWithByte:(jbyte)firstBlockAddress
              withByteArray:(IOSByteArray *)data;

// Disallowed inherited constructors, do not use.

- (instancetype __nonnull)init NS_UNAVAILABLE;

@end

J2OBJC_EMPTY_STATIC_INIT(ComStSt25sdkCommandIso14443SRCustomCommand)

J2OBJC_FIELD_SETTER(ComStSt25sdkCommandIso14443SRCustomCommand, mReaderInterface_, id<ComStSt25sdkRFReaderInterface>)

inline jint ComStSt25sdkCommandIso14443SRCustomCommand_get_ISO14443SR_CUSTOM_CMD_INITIATE(void);
#define ComStSt25sdkCommandIso14443SRCustomCommand_ISO14443SR_CUSTOM_CMD_INITIATE 1536
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkCommandIso14443SRCustomCommand, ISO14443SR_CUSTOM_CMD_INITIATE, jint)

inline jint ComStSt25sdkCommandIso14443SRCustomCommand_get_ISO14443SR_CUSTOM_CMD_PCALL16(void);
#define ComStSt25sdkCommandIso14443SRCustomCommand_ISO14443SR_CUSTOM_CMD_PCALL16 1540
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkCommandIso14443SRCustomCommand, ISO14443SR_CUSTOM_CMD_PCALL16, jint)

inline jint ComStSt25sdkCommandIso14443SRCustomCommand_get_ISO14443SR_CUSTOM_CMD_SLOT_MARKER(void);
#define ComStSt25sdkCommandIso14443SRCustomCommand_ISO14443SR_CUSTOM_CMD_SLOT_MARKER 6
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkCommandIso14443SRCustomCommand, ISO14443SR_CUSTOM_CMD_SLOT_MARKER, jint)

inline jint ComStSt25sdkCommandIso14443SRCustomCommand_get_ISO14443SR_CUSTOM_CMD_SELECT(void);
#define ComStSt25sdkCommandIso14443SRCustomCommand_ISO14443SR_CUSTOM_CMD_SELECT 14
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkCommandIso14443SRCustomCommand, ISO14443SR_CUSTOM_CMD_SELECT, jint)

inline jint ComStSt25sdkCommandIso14443SRCustomCommand_get_ISO14443SR_CUSTOM_CMD_COMPLETION(void);
#define ComStSt25sdkCommandIso14443SRCustomCommand_ISO14443SR_CUSTOM_CMD_COMPLETION 15
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkCommandIso14443SRCustomCommand, ISO14443SR_CUSTOM_CMD_COMPLETION, jint)

inline jint ComStSt25sdkCommandIso14443SRCustomCommand_get_ISO14443SR_CUSTOM_CMD_RESET_TO_INVENTORY(void);
#define ComStSt25sdkCommandIso14443SRCustomCommand_ISO14443SR_CUSTOM_CMD_RESET_TO_INVENTORY 12
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkCommandIso14443SRCustomCommand, ISO14443SR_CUSTOM_CMD_RESET_TO_INVENTORY, jint)

inline jint ComStSt25sdkCommandIso14443SRCustomCommand_get_ISO14443SR_CUSTOM_CMD_READ_BLOCK(void);
#define ComStSt25sdkCommandIso14443SRCustomCommand_ISO14443SR_CUSTOM_CMD_READ_BLOCK 8
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkCommandIso14443SRCustomCommand, ISO14443SR_CUSTOM_CMD_READ_BLOCK, jint)

inline jint ComStSt25sdkCommandIso14443SRCustomCommand_get_ISO14443SR_CUSTOM_CMD_WRITE_BLOCK(void);
#define ComStSt25sdkCommandIso14443SRCustomCommand_ISO14443SR_CUSTOM_CMD_WRITE_BLOCK 9
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkCommandIso14443SRCustomCommand, ISO14443SR_CUSTOM_CMD_WRITE_BLOCK, jint)

inline jint ComStSt25sdkCommandIso14443SRCustomCommand_get_ISO14443SR_CUSTOM_CMD_GET_UID(void);
#define ComStSt25sdkCommandIso14443SRCustomCommand_ISO14443SR_CUSTOM_CMD_GET_UID 11
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkCommandIso14443SRCustomCommand, ISO14443SR_CUSTOM_CMD_GET_UID, jint)

FOUNDATION_EXPORT void ComStSt25sdkCommandIso14443SRCustomCommand_initWithComStSt25sdkRFReaderInterface_(ComStSt25sdkCommandIso14443SRCustomCommand *self, id<ComStSt25sdkRFReaderInterface> reader);

FOUNDATION_EXPORT ComStSt25sdkCommandIso14443SRCustomCommand *new_ComStSt25sdkCommandIso14443SRCustomCommand_initWithComStSt25sdkRFReaderInterface_(id<ComStSt25sdkRFReaderInterface> reader) NS_RETURNS_RETAINED;

FOUNDATION_EXPORT ComStSt25sdkCommandIso14443SRCustomCommand *create_ComStSt25sdkCommandIso14443SRCustomCommand_initWithComStSt25sdkRFReaderInterface_(id<ComStSt25sdkRFReaderInterface> reader);

FOUNDATION_EXPORT void ComStSt25sdkCommandIso14443SRCustomCommand_initWithComStSt25sdkRFReaderInterface_withInt_(ComStSt25sdkCommandIso14443SRCustomCommand *self, id<ComStSt25sdkRFReaderInterface> reader, jint nbrOfBytesPerBlock);

FOUNDATION_EXPORT ComStSt25sdkCommandIso14443SRCustomCommand *new_ComStSt25sdkCommandIso14443SRCustomCommand_initWithComStSt25sdkRFReaderInterface_withInt_(id<ComStSt25sdkRFReaderInterface> reader, jint nbrOfBytesPerBlock) NS_RETURNS_RETAINED;

FOUNDATION_EXPORT ComStSt25sdkCommandIso14443SRCustomCommand *create_ComStSt25sdkCommandIso14443SRCustomCommand_initWithComStSt25sdkRFReaderInterface_withInt_(id<ComStSt25sdkRFReaderInterface> reader, jint nbrOfBytesPerBlock);

J2OBJC_TYPE_LITERAL_HEADER(ComStSt25sdkCommandIso14443SRCustomCommand)

#endif


#if __has_feature(nullability)
#pragma clang diagnostic pop
#endif
#pragma pop_macro("INCLUDE_ALL_ComStSt25sdkCommandIso14443SRCustomCommand")
