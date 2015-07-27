//
//  PictureCloudKit.swift
//  MidPoint
//
//  Created by Joao Sisanoski on 7/27/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import Foundation
import CloudKit
protocol PictureCloudKitDelegate{
    
}
class PictureCloudKit : NSObject{
    private var container: CKContainer
    private var publicDB: CKDatabase
    
    var delegate: PictureCloudKitDelegate?
    
    override init(){
        container = CKContainer.defaultContainer()
        publicDB = container.publicCloudDatabase
    }
    func uploadProfile(url : NSURL , id : Int, perRecordProgressBlock: ((CKRecord!, Double) -> Void),  perRecordCompletionBlock: ((CKRecord!, NSError!) -> Void)) {
        let imageAsset = CKAsset(fileURL: url)
        let record = CKRecord(recordType: "\(CloudKitGlobalConstants.ProfileTable)")
        record.setObject(id, forKey: "\(UserGlobalConstants.Id)")
        record.setObject(imageAsset, forKey: "\(UserGlobalConstants.Image)")
        
        let modifyOperation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        modifyOperation.perRecordCompletionBlock = perRecordCompletionBlock
        modifyOperation.perRecordProgressBlock = perRecordProgressBlock
        self.publicDB.addOperation(modifyOperation)
        
    }
}
