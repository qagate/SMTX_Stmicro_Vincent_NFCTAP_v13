//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: st25sdk_ios/ndef/TextRecord.java
//

#include "IOSPrimitiveArray.h"
#include "J2ObjC_source.h"
#include "com/st/st25sdk/ndef/NDEFRecord.h"
#include "com/st/st25sdk/ndef/TextRecord.h"
#include "java/io/ByteArrayInputStream.h"
#include "java/lang/Exception.h"
#include "java/lang/IllegalArgumentException.h"
#include "java/nio/ByteBuffer.h"
#include "java/nio/charset/Charset.h"
#include "java/util/Locale.h"

static id (*ComStSt25sdkNdefTextRecord_super$_getPayload)(id, SEL);

@interface ComStSt25sdkNdefTextRecord () {
 @public
  NSString *mText_;
  JavaUtilLocale *mLocale_;
  jboolean mUtf8_;
}

@end

J2OBJC_FIELD_SETTER(ComStSt25sdkNdefTextRecord, mText_, NSString *)
J2OBJC_FIELD_SETTER(ComStSt25sdkNdefTextRecord, mLocale_, JavaUtilLocale *)

J2OBJC_INITIALIZED_DEFN(ComStSt25sdkNdefTextRecord)

@implementation ComStSt25sdkNdefTextRecord

J2OBJC_IGNORE_DESIGNATED_BEGIN
- (instancetype)init {
  ComStSt25sdkNdefTextRecord_init(self);
  return self;
}
J2OBJC_IGNORE_DESIGNATED_END

- (instancetype)initWithNSString:(NSString *)text {
  ComStSt25sdkNdefTextRecord_initWithNSString_(self, text);
  return self;
}

- (instancetype)initWithNSString:(NSString *)text
              withJavaUtilLocale:(JavaUtilLocale *)locale
                     withBoolean:(jboolean)utf8 {
  ComStSt25sdkNdefTextRecord_initWithNSString_withJavaUtilLocale_withBoolean_(self, text, locale, utf8);
  return self;
}

- (instancetype)initWithJavaIoByteArrayInputStream:(JavaIoByteArrayInputStream *)inputStream {
  ComStSt25sdkNdefTextRecord_initWithJavaIoByteArrayInputStream_(self, inputStream);
  return self;
}

- (void)setTextWithNSString:(NSString *)text {
  if (text == nil) {
    @throw new_JavaLangIllegalArgumentException_init();
  }
  mText_ = text;
}

- (NSString *)getText {
  return mText_;
}

- (JavaUtilLocale *)getLanguageCode {
  return mLocale_;
}

- (jboolean)getUTF {
  return mUtf8_;
}

- (IOSByteArray *)getPayload {
  IOSByteArray *langBytes = nil;
  jint langBytesLength = 0;
  JavaNioCharsetCharset *utfEncoding;
  JavaNioByteBuffer *payload;
  if (mText_ != nil) {
    if (mLocale_ != JreLoadStatic(JavaUtilLocale, ROOT)) {
      langBytes = [((NSString *) nil_chk([((JavaUtilLocale *) nil_chk(mLocale_)) getLanguage])) java_getBytesWithCharset:JavaNioCharsetCharset_forNameWithNSString_(@"US-ASCII")];
      langBytesLength = ((IOSByteArray *) nil_chk(langBytes))->size_;
    }
    else {
      langBytesLength = 0;
    }
    utfEncoding = mUtf8_ ? JavaNioCharsetCharset_forNameWithNSString_(@"UTF-8") : JavaNioCharsetCharset_forNameWithNSString_(@"UTF-16");
    IOSByteArray *textBytes = [((NSString *) nil_chk(mText_)) java_getBytesWithCharset:utfEncoding];
    payload = JavaNioByteBuffer_allocateWithInt_(1 + langBytesLength + ((IOSByteArray *) nil_chk(textBytes))->size_);
    jint utfBit = mUtf8_ ? 0 : (JreLShift32(1, 7));
    jchar status = (jchar) (utfBit + langBytesLength);
    (void) [((JavaNioByteBuffer *) nil_chk(payload)) putWithByte:(jbyte) status];
    if (mLocale_ != JreLoadStatic(JavaUtilLocale, ROOT)) {
      (void) [payload putWithByteArray:langBytes];
    }
    (void) [payload putWithByteArray:textBytes];
    return [payload array];
  }
  return nil;
}

- (NSString *)description {
  NSString *txt = @"Text Record:\n";
  (void) JreStrAppendStrong(&txt, "$$C", @"- Text : ", mText_, 0x000a);
  return txt;
}

+ (const J2ObjcClassInfo *)__metadata {
  static J2ObjcMethodInfo methods[] = {
    { NULL, NULL, 0x1, -1, -1, -1, -1, -1, -1 },
    { NULL, NULL, 0x1, -1, 0, -1, -1, -1, -1 },
    { NULL, NULL, 0x1, -1, 1, -1, -1, -1, -1 },
    { NULL, NULL, 0x1, -1, 2, 3, -1, -1, -1 },
    { NULL, "V", 0x1, 4, 0, -1, -1, -1, -1 },
    { NULL, "LNSString;", 0x1, -1, -1, -1, -1, -1, -1 },
    { NULL, "LJavaUtilLocale;", 0x1, -1, -1, -1, -1, -1, -1 },
    { NULL, "Z", 0x1, -1, -1, -1, -1, -1, -1 },
    { NULL, "[B", 0x1, -1, -1, -1, -1, -1, -1 },
    { NULL, "LNSString;", 0x1, 5, -1, -1, -1, -1, -1 },
  };
  #pragma clang diagnostic push
  #pragma clang diagnostic ignored "-Wobjc-multiple-method-names"
  #pragma clang diagnostic ignored "-Wundeclared-selector"
  methods[0].selector = @selector(init);
  methods[1].selector = @selector(initWithNSString:);
  methods[2].selector = @selector(initWithNSString:withJavaUtilLocale:withBoolean:);
  methods[3].selector = @selector(initWithJavaIoByteArrayInputStream:);
  methods[4].selector = @selector(setTextWithNSString:);
  methods[5].selector = @selector(getText);
  methods[6].selector = @selector(getLanguageCode);
  methods[7].selector = @selector(getUTF);
  methods[8].selector = @selector(getPayload);
  methods[9].selector = @selector(description);
  #pragma clang diagnostic pop
  static const J2ObjcFieldInfo fields[] = {
    { "mText_", "LNSString;", .constantValue.asLong = 0, 0x2, -1, -1, -1, -1 },
    { "mLocale_", "LJavaUtilLocale;", .constantValue.asLong = 0, 0x2, -1, -1, -1, -1 },
    { "mUtf8_", "Z", .constantValue.asLong = 0, 0x2, -1, -1, -1, -1 },
  };
  static const void *ptrTable[] = { "LNSString;", "LNSString;LJavaUtilLocale;Z", "LJavaIoByteArrayInputStream;", "LJavaLangException;", "setText", "toString" };
  static const J2ObjcClassInfo _ComStSt25sdkNdefTextRecord = { "TextRecord", "com.st.st25sdk.ndef", ptrTable, methods, fields, 7, 0x1, 10, 3, -1, -1, -1, -1, -1 };
  return &_ComStSt25sdkNdefTextRecord;
}

+ (void)initialize {
  if (self == [ComStSt25sdkNdefTextRecord class]) {
    ComStSt25sdkNdefTextRecord_super$_getPayload = (id (*)(id, SEL))[ComStSt25sdkNdefNDEFRecord instanceMethodForSelector:@selector(getPayload)];
    J2OBJC_SET_INITIALIZED(ComStSt25sdkNdefTextRecord)
  }
}

@end

void ComStSt25sdkNdefTextRecord_init(ComStSt25sdkNdefTextRecord *self) {
  ComStSt25sdkNdefTextRecord_initWithNSString_(self, @"");
}

ComStSt25sdkNdefTextRecord *new_ComStSt25sdkNdefTextRecord_init() {
  J2OBJC_NEW_IMPL(ComStSt25sdkNdefTextRecord, init)
}

ComStSt25sdkNdefTextRecord *create_ComStSt25sdkNdefTextRecord_init() {
  J2OBJC_CREATE_IMPL(ComStSt25sdkNdefTextRecord, init)
}

void ComStSt25sdkNdefTextRecord_initWithNSString_(ComStSt25sdkNdefTextRecord *self, NSString *text) {
  ComStSt25sdkNdefTextRecord_initWithNSString_withJavaUtilLocale_withBoolean_(self, text, JavaUtilLocale_getDefault(), true);
}

ComStSt25sdkNdefTextRecord *new_ComStSt25sdkNdefTextRecord_initWithNSString_(NSString *text) {
  J2OBJC_NEW_IMPL(ComStSt25sdkNdefTextRecord, initWithNSString_, text)
}

ComStSt25sdkNdefTextRecord *create_ComStSt25sdkNdefTextRecord_initWithNSString_(NSString *text) {
  J2OBJC_CREATE_IMPL(ComStSt25sdkNdefTextRecord, initWithNSString_, text)
}

void ComStSt25sdkNdefTextRecord_initWithNSString_withJavaUtilLocale_withBoolean_(ComStSt25sdkNdefTextRecord *self, NSString *text, JavaUtilLocale *locale, jboolean utf8) {
  ComStSt25sdkNdefNDEFRecord_init(self);
  self->mUtf8_ = true;
  if ((text == nil) || (locale == nil)) {
    @throw new_JavaLangIllegalArgumentException_init();
  }
  [self setTnfWithShort:ComStSt25sdkNdefNDEFRecord_TNF_WELLKNOWN];
  [self setTypeWithByteArray:JreLoadStatic(ComStSt25sdkNdefNDEFRecord, RTD_TEXT)];
  self->mText_ = text;
  self->mLocale_ = locale;
  self->mUtf8_ = utf8;
  [self setSR];
}

ComStSt25sdkNdefTextRecord *new_ComStSt25sdkNdefTextRecord_initWithNSString_withJavaUtilLocale_withBoolean_(NSString *text, JavaUtilLocale *locale, jboolean utf8) {
  J2OBJC_NEW_IMPL(ComStSt25sdkNdefTextRecord, initWithNSString_withJavaUtilLocale_withBoolean_, text, locale, utf8)
}

ComStSt25sdkNdefTextRecord *create_ComStSt25sdkNdefTextRecord_initWithNSString_withJavaUtilLocale_withBoolean_(NSString *text, JavaUtilLocale *locale, jboolean utf8) {
  J2OBJC_CREATE_IMPL(ComStSt25sdkNdefTextRecord, initWithNSString_withJavaUtilLocale_withBoolean_, text, locale, utf8)
}

void ComStSt25sdkNdefTextRecord_initWithJavaIoByteArrayInputStream_(ComStSt25sdkNdefTextRecord *self, JavaIoByteArrayInputStream *inputStream) {
  ComStSt25sdkNdefNDEFRecord_initWithJavaIoByteArrayInputStream_(self, inputStream);
  self->mUtf8_ = true;
  IOSByteArray *payload = ComStSt25sdkNdefTextRecord_super$_getPayload(self, @selector(getPayload));
  NSString *text = nil;
  if (payload == nil) {
    @throw new_JavaLangException_initWithNSString_(@"Invalid ndef data");
  }
  [self setTnfWithShort:ComStSt25sdkNdefNDEFRecord_TNF_WELLKNOWN];
  [self setTypeWithByteArray:JreLoadStatic(ComStSt25sdkNdefNDEFRecord, RTD_TEXT)];
  if (payload->size_ == 0) {
    @throw new_JavaLangException_initWithNSString_(@"Invalid ndef data");
  }
  jbyte statusByte = IOSByteArray_Get(payload, 0);
  jint lengthOfLanguageCode = statusByte & (jint) 0x3F;
  if (lengthOfLanguageCode < payload->size_) {
    if (lengthOfLanguageCode > 0) {
      NSString *languageCode = [NSString java_stringWithBytes:payload offset:1 length:lengthOfLanguageCode charsetName:@"US-ASCII"];
      self->mLocale_ = new_JavaUtilLocale_initWithNSString_(languageCode);
      self->mUtf8_ = (JreRShift32(IOSByteArray_Get(payload, 0), 7) == 0);
    }
    else {
      self->mLocale_ = JreLoadStatic(JavaUtilLocale, ROOT);
      self->mUtf8_ = true;
    }
  }
  else {
    @throw new_JavaLangException_initWithNSString_(@"Invalid ndef data");
  }
  if (self->mUtf8_) {
    text = [NSString java_stringWithBytes:payload charset:JavaNioCharsetCharset_forNameWithNSString_(@"UTF-8")];
  }
  else {
    text = [NSString java_stringWithBytes:payload charset:JavaNioCharsetCharset_forNameWithNSString_(@"UTF-16")];
  }
  if ((lengthOfLanguageCode + 1) < [text java_length]) {
    self->mText_ = [text java_substring:lengthOfLanguageCode + 1 endIndex:[text java_length]];
  }
  else {
    self->mText_ = @"";
  }
  if (JreLoadStatic(ComStSt25sdkNdefNDEFRecord, DBG_NDEF_RECORD)) {
    [self dbgCheckNdefRecordContentWithByteArray:payload];
  }
}

ComStSt25sdkNdefTextRecord *new_ComStSt25sdkNdefTextRecord_initWithJavaIoByteArrayInputStream_(JavaIoByteArrayInputStream *inputStream) {
  J2OBJC_NEW_IMPL(ComStSt25sdkNdefTextRecord, initWithJavaIoByteArrayInputStream_, inputStream)
}

ComStSt25sdkNdefTextRecord *create_ComStSt25sdkNdefTextRecord_initWithJavaIoByteArrayInputStream_(JavaIoByteArrayInputStream *inputStream) {
  J2OBJC_CREATE_IMPL(ComStSt25sdkNdefTextRecord, initWithJavaIoByteArrayInputStream_, inputStream)
}

J2OBJC_CLASS_TYPE_LITERAL_SOURCE(ComStSt25sdkNdefTextRecord)