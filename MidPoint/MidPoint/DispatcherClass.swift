//
//  DispatcherClass.swift
//  MidPoint
//
//  Created by Joao Sisanoski on 7/27/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import Foundation

class DispatcherClass {
    class func dispatcher(functionToRunOnMainThread: () -> ())
    {
        dispatch_async(dispatch_get_main_queue(), functionToRunOnMainThread)
    }
    class func concurrentThread(functionToRunOnMainThread: () -> ())
    {
        
    }
    
}