//
//  ErrorHandling.swift
//  MidPoint
//
//  Created by Joao Sisanoski on 7/28/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import Foundation

class ErrorHandling {
    class func stringForError(error : NSError)-> String{
        switch error.code
        {
        case 0:
            return "Internal error"
        case 1:
            return "Dados incompletos"
        case 2:
            return "Usuário não encontrado ou senha errada"
        case 3:
            return "Array vazio"
        case 4:
            return "Internal error"
        case 5:
            return "Internal error"
        case 6:
            return "Internal error"
        case 7:
            return "Internal error"
        case 8:
            return "Internal error"
            
        default:
            return "Internal error"
            
        }
    }
}