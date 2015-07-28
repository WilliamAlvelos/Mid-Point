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
    func errorCloudKit(error: NSError)
}
class PictureCloudKit : NSObject{
    private var container: CKContainer
    private var publicDB: CKDatabase
    
    var delegate: PictureCloudKitDelegate?
    
    override init(){
        container = CKContainer.defaultContainer()
        publicDB = container.publicCloudDatabase
    }
    func downloadProfileImage(user: User){
        let predicate = NSPredicate(format: "\(UserGlobalConstants.Id)) == %d", user.id!)
        
        let query = CKQuery(recordType: "\(CloudKitGlobalConstants.ProfileTable)", predicate: predicate)

        self.publicDB.performQuery(query, inZoneWithID: nil) { (records: [AnyObject]!, error: NSError!) -> Void in
            if error != nil {
                self.delegate?.errorCloudKit(error)
                return
            }
                let picture = records[0] as! CKRecord
                user.image = picture.objectForKey("\(UserGlobalConstants.Image)") as? UIImage
        }
    }
    func downloadEventImage(event: Event){
        let predicate = NSPredicate(format: "\(EventGlobalConstants.Id)) == %d", event.id!)
        
        let query = CKQuery(recordType: "\(CloudKitGlobalConstants.EventTable)", predicate: predicate)
        
        self.publicDB.performQuery(query, inZoneWithID: nil) { (records: [AnyObject]!, error: NSError!) -> Void in
            if error != nil {
                self.delegate?.errorCloudKit(error)
                return
            }
            let picture = records[0] as! CKRecord
            event.image = picture.objectForKey("\(EventGlobalConstants.Image)") as? UIImage
        }
    }
    func uploadProfileImage(url : NSURL , id : Int, perRecordProgressBlock: ((CKRecord!, Double) -> Void),  perRecordCompletionBlock: ((CKRecord!, NSError!) -> Void)) {
        let imageAsset = CKAsset(fileURL: url)
        let record = CKRecord(recordType: "\(CloudKitGlobalConstants.ProfileTable)")
        record.setObject(id, forKey: "\(UserGlobalConstants.Id)")
        record.setObject(imageAsset, forKey: "\(UserGlobalConstants.Image)")
        
        let modifyOperation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        modifyOperation.perRecordCompletionBlock = perRecordCompletionBlock
        modifyOperation.perRecordProgressBlock = perRecordProgressBlock
        self.publicDB.addOperation(modifyOperation)
        
    }
    func uploadEventImage(url : NSURL , id : Int, perRecordProgressBlock: ((CKRecord!, Double) -> Void),  perRecordCompletionBlock: ((CKRecord!, NSError!) -> Void)) {
        let imageAsset = CKAsset(fileURL: url)
        let record = CKRecord(recordType: "\(CloudKitGlobalConstants.EventTable)")
        record.setObject(id, forKey: "\(EventGlobalConstants.Id)")
        record.setObject(imageAsset, forKey: "\(EventGlobalConstants.Image)")
        
        let modifyOperation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        modifyOperation.perRecordCompletionBlock = perRecordCompletionBlock
        modifyOperation.perRecordProgressBlock = perRecordProgressBlock
        self.publicDB.addOperation(modifyOperation)
        
    }
}
