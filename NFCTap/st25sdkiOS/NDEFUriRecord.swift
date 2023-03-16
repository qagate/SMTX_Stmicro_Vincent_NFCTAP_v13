//
//  NDEFUriRecord.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 13/10/2017.
//  Copyright © 2017 STMicroelectronics. All rights reserved.
//

import UIKit
import CoreNFC


enum UriType: Int {
    case kUrl   = 0
    case kTel   = 1
    case kMail  = 2
    case kMap   = 3
    case kNotSupported   = 4
}

class NDEFUriRecords: NDEFRecords{
    
    var mComStSt25sdkNdefNDEFUri:ComStSt25sdkNdefUriRecord!
    var NDEFUriRecordsType:UriType!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    
    override init() {
        super.init()
    }
    
    
    override init(ndefRecord:ComStSt25sdkNdefNDEFRecord){
        super.init()
        mComStSt25sdkNdefNDEFUri = ndefRecord as! ComStSt25sdkNdefUriRecord
        create()
    }
    
    override init(ndefMsg:ComStSt25sdkNdefNDEFMsg,payload:NFCNDEFPayload){
        super.init(ndefMsg: ndefMsg,payload: payload)
        
        mComStSt25sdkNdefNDEFUri =
            ndefMsg.getNDEFRecord(with: 0) as! ComStSt25sdkNdefUriRecord
        mComStSt25sdkNdefNDEFUri.setIdWith(IOSByteArray(nsData: payload.identifier))
        
        create()
    }
    
    private func create() {
        print ("URI content = "+(mComStSt25sdkNdefNDEFUri.getContent()))
        let uriSchemeString:String

        self.mRecordTypeString = "NDEF URI"
        self.mImage = UIImage(named: "Safari")!
        self.NDEFUriRecordsType = UriType.kNotSupported

        // URL by default
        var body = mComStSt25sdkNdefNDEFUri.getContent()!
    
       switch (mComStSt25sdkNdefNDEFUri.getUriID().toNSEnum()) {
        case ComStSt25sdkNdefUriRecord_NdefUriIdCode_Enum.NDEF_RTD_URI_ID_IMAP:
            uriSchemeString = ""
            if body.starts(with:"geo:") {
                body = body.replacingOccurrences(of: "geo:", with: "http://maps.apple.com/?q=")
                self.mRecordTypeString = "NDEF Map"
                self.mImage = UIImage(named: "GeoIoT")!
                self.NDEFUriRecordsType = UriType.kMap
            }
            else if body.starts(with:"nfctap:") {
                self.NDEFUriRecordsType = UriType.kUrl
            }
            
            self.mRecordValue = "\(uriSchemeString)\(body)"
            break
            
        case ComStSt25sdkNdefUriRecord_NdefUriIdCode_Enum.NDEF_RTD_URI_ID_HTTP_WWW:
            uriSchemeString = "http://www."
            self.NDEFUriRecordsType = UriType.kUrl
            let ulrString = "\(uriSchemeString)\(body)"
            self.mRecordValue = createURLWithComponents(url: ulrString)
            break
            
        case ComStSt25sdkNdefUriRecord_NdefUriIdCode_Enum.NDEF_RTD_URI_ID_HTTPS_WWW :
            uriSchemeString = "https://www."
            let ulrString = "\(uriSchemeString)\(body)"
            self.NDEFUriRecordsType = UriType.kUrl
            self.mRecordValue = createURLWithComponents(url: ulrString)
            break
            
        case ComStSt25sdkNdefUriRecord_NdefUriIdCode_Enum.NDEF_RTD_URI_ID_HTTP  :
            uriSchemeString = "http://"
            // Check if geo scheme
            if body.starts(with:"maps.apple.com") {
                self.mRecordTypeString = "NDEF Map"
                self.mImage = UIImage(named: "GeoIoT")!
                self.NDEFUriRecordsType = UriType.kMap
                self.mRecordValue = "\(uriSchemeString)\(body)"
            }else{
                let ulrString = "\(uriSchemeString)\(body)"
                self.NDEFUriRecordsType = UriType.kUrl
                self.mRecordValue = createURLWithComponents(url: ulrString)
            }
            break;
            
         case ComStSt25sdkNdefUriRecord_NdefUriIdCode_Enum.NDEF_RTD_URI_ID_HTTPS :
            uriSchemeString = "https://"
            // Check if geo scheme
            if body.starts(with:"maps.apple.com") {
                self.mRecordTypeString = "NDEF Map"
                self.mImage = UIImage(named: "GeoIoT")!
                self.NDEFUriRecordsType = UriType.kMap
                self.mRecordValue = "\(uriSchemeString)\(body)"
            }else{
                let ulrString = "\(uriSchemeString)\(body)"
                self.NDEFUriRecordsType = UriType.kUrl
                self.mRecordValue = createURLWithComponents(url: ulrString)
            }
            break
            
        case ComStSt25sdkNdefUriRecord_NdefUriIdCode_Enum.NDEF_RTD_URI_ID_TEL :
            uriSchemeString = "tel:"
            self.mRecordTypeString = "NDEF Call"
            self.mImage = UIImage(named: "call")!
            self.NDEFUriRecordsType = UriType.kTel
            self.mRecordValue = "\(uriSchemeString)\(body)"
            break
            
        case ComStSt25sdkNdefUriRecord_NdefUriIdCode_Enum.NDEF_RTD_URI_ID_MAILTO :
            uriSchemeString = "mailto:"
            self.mRecordTypeString = "NDEF Mail"
            self.NDEFUriRecordsType = UriType.kMail
            
            let mComStSt25sdkNdefNDEFMail = self.mNdefRecord as! ComStSt25sdkNdefEmailRecord
                //ndefMsg.getNDEFRecord(with: 0) as! ComStSt25sdkNdefEmailRecord
            
            self.mImage = UIImage(named: "mail")!
            let mailToString = mComStSt25sdkNdefNDEFMail.getContact()
            let mailSubjectString = mComStSt25sdkNdefNDEFMail.getSubject()
            let mailMessageString = mComStSt25sdkNdefNDEFMail.getMessage()
            
            self.mRecordValue = "mailto:\(mailToString!)?subject=\(mailSubjectString!)&body=\(mailMessageString!)"
            break
            
        case ComStSt25sdkNdefUriRecord_NdefUriIdCode_Enum.NDEF_RTD_URI_ID_NEWS:
            uriSchemeString = "news:"
            self.mRecordValue = "\(uriSchemeString)\(body)"
            break
        
/* iOS13
        case ComStSt25sdkNdefUriRecord_NdefUriIdCode_Enum.NDEF_RTD_URI_ID_BTGOEP:
            self.mRecordValue = "\(uriSchemeString)\(body)"
            break
        case ComStSt25sdkNdefUriRecord_NdefUriIdCode_Enum.NDEF_RTD_URI_ID_BTL2CAP:
            self.mRecordValue = "\(uriSchemeString)\(body)"
            break
        case ComStSt25sdkNdefUriRecord_NdefUriIdCode_Enum.NDEF_RTD_URI_ID_BTSPP:
            self.mRecordValue = "\(uriSchemeString)\(body)"
            break
        case ComStSt25sdkNdefUriRecord_NdefUriIdCode_Enum.NDEF_RTD_URI_ID_DAV:
            self.mRecordValue = "\(uriSchemeString)\(body)"
            break
        case ComStSt25sdkNdefUriRecord_NdefUriIdCode_Enum.NDEF_RTD_URI_ID_FILE:
            self.mRecordValue = "\(uriSchemeString)\(body)"
            break
        case ComStSt25sdkNdefUriRecord_NdefUriIdCode_Enum.NDEF_RTD_URI_ID_FTP:
            self.mRecordValue = "\(uriSchemeString)\(body)"
            break
        case ComStSt25sdkNdefUriRecord_NdefUriIdCode_Enum.NDEF_RTD_URI_ID_FTP_ANONYMOUS:
            self.mRecordValue = "\(uriSchemeString)\(body)"
            break
        case ComStSt25sdkNdefUriRecord_NdefUriIdCode_Enum.NDEF_RTD_URI_ID_FTP_FTP:
            self.mRecordValue = "\(uriSchemeString)\(body)"
            break
        case ComStSt25sdkNdefUriRecord_NdefUriIdCode_Enum.NDEF_RTD_URI_ID_FTPS:
            self.mRecordValue = "\(uriSchemeString)\(body)"
            break
        case ComStSt25sdkNdefUriRecord_NdefUriIdCode_Enum.NDEF_RTD_URI_ID_IMAP:
            self.mRecordValue = "\(uriSchemeString)\(body)"
            break
        case ComStSt25sdkNdefUriRecord_NdefUriIdCode_Enum.NDEF_RTD_URI_ID_IRDA_OBEX:
            self.mRecordValue = "\(uriSchemeString)\(body)"
            break
        case ComStSt25sdkNdefUriRecord_NdefUriIdCode_Enum.NDEF_RTD_URI_ID_NFS:
            self.mRecordValue = "\(uriSchemeString)\(body)"
            break
        case ComStSt25sdkNdefUriRecord_NdefUriIdCode_Enum.NDEF_RTD_URI_ID_POP:
            self.mRecordValue = "\(uriSchemeString)\(body)"
            break
        case ComStSt25sdkNdefUriRecord_NdefUriIdCode_Enum.NDEF_RTD_URI_ID_RTSP:
            self.mRecordValue = "\(uriSchemeString)\(body)"
            break
        case ComStSt25sdkNdefUriRecord_NdefUriIdCode_Enum.NDEF_RTD_URI_ID_SFTP:
            self.mRecordValue = "\(uriSchemeString)\(body)"
            break
        case ComStSt25sdkNdefUriRecord_NdefUriIdCode_Enum.NDEF_RTD_URI_ID_SIP:
            self.mRecordValue = "\(uriSchemeString)\(body)"
            break
        case ComStSt25sdkNdefUriRecord_NdefUriIdCode_Enum.NDEF_RTD_URI_ID_SIPS:
            self.mRecordValue = "\(uriSchemeString)\(body)"
            break
        case ComStSt25sdkNdefUriRecord_NdefUriIdCode_Enum.NDEF_RTD_URI_ID_SMB:
            self.mRecordValue = "\(uriSchemeString)\(body)"
            break
        case ComStSt25sdkNdefUriRecord_NdefUriIdCode_Enum.NDEF_RTD_URI_ID_TCP_OBEX:
            self.mRecordValue = "\(uriSchemeString)\(body)"
            break
        case ComStSt25sdkNdefUriRecord_NdefUriIdCode_Enum.NDEF_RTD_URI_ID_TELNET:
            self.mRecordValue = "\(uriSchemeString)\(body)"
            break
        case ComStSt25sdkNdefUriRecord_NdefUriIdCode_Enum.NDEF_RTD_URI_ID_TFTP:
            self.mRecordValue = "\(uriSchemeString)\(body)"
            break
        case ComStSt25sdkNdefUriRecord_NdefUriIdCode_Enum.NDEF_RTD_URI_ID_URN:
            self.mRecordValue = "\(uriSchemeString)\(body)"
            break
        case ComStSt25sdkNdefUriRecord_NdefUriIdCode_Enum.NDEF_RTD_URI_ID_URN_EPC:
            self.mRecordValue = "\(uriSchemeString)\(body)"
            break
        case ComStSt25sdkNdefUriRecord_NdefUriIdCode_Enum.NDEF_RTD_URI_ID_URN_EPC_PAT:
            self.mRecordValue = "\(uriSchemeString)\(body)"
            break
        case ComStSt25sdkNdefUriRecord_NdefUriIdCode_Enum.NDEF_RTD_URI_ID_URN_EPC_ID:
            self.mRecordValue = "\(uriSchemeString)\(body)"
            break
        case ComStSt25sdkNdefUriRecord_NdefUriIdCode_Enum.NDEF_RTD_URI_ID_URN_EPC_RAW:
            self.mRecordValue = "\(uriSchemeString)\(body)"
            break
        case ComStSt25sdkNdefUriRecord_NdefUriIdCode_Enum.NDEF_RTD_URI_ID_URN_NFC:
            self.mRecordValue = "\(uriSchemeString)\(body)"
            break
  */
        default:
            uriSchemeString = "not supported"
            self.mRecordValue = "\(uriSchemeString)\(body)"
            break
        }
    }
    
    
    private func createURLWithComponents(url: String) -> String {
        let urlNSString = NSString(string : url)
        let urlEncoded = urlNSString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlUserAllowed)
        let urlComponents = NSURLComponents(string: urlEncoded!)!
        
        
        // Check if AddURL options are valids
        let AddTimeStampToURL = UserDefaults.standard.bool(forKey:"AddTimeStampToURL")
        let AddGeolocationToURL = UserDefaults.standard.bool(forKey: "AddGeolocationToURL")
        
        // add params
        var dateQuery:URLQueryItem!
        var geoQuery:URLQueryItem!
        
        var queryItems = [URLQueryItem]()
        
        if (AddTimeStampToURL == true){
            let today = NSDate()
            dateQuery = URLQueryItem(name: "date", value: dateToString(date: today))
            queryItems.append(dateQuery)
        }
        if (AddGeolocationToURL == true){
            let latitude = UserDefaults.standard.string(forKey: "latitude")
            let longitude = UserDefaults.standard.string(forKey: "longitude")
            
            geoQuery = URLQueryItem(name: "latitude", value: latitude)
            queryItems.append(geoQuery)
            geoQuery = URLQueryItem(name: "longitude", value: longitude)
            queryItems.append(geoQuery)
        }
        
        if(AddGeolocationToURL || AddTimeStampToURL){
            //urlComponents.queryItems = []
            urlComponents.queryItems = queryItems
        }
        
        return urlComponents.url!.absoluteString.removingPercentEncoding!
    }
    
    private func dateToString(date: NSDate) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-hh:mm:ss"
        return dateFormatter.string(from: date as Date)
    }
    
}

