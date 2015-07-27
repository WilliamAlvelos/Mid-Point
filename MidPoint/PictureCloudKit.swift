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
    func upload(image : UIImage , id : Int) {
//        let image = CKRecord(recordType: <#String!#>))
//        
//        let modifyOperation = CKModifyRecordsOperation(recordsToSave: <#[AnyObject]!#>, recordIDsToDelete: <#[AnyObject]!#>))
//        
    }
}
