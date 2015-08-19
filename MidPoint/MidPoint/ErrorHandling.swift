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
        var  alertView1 =  JSSAlertView()
        
        switch error.code
        {
        case -1:
            return "Não conseguiu conectar com o banco de dados"
        case 0:
            return "Falha interna"
        case 1:
            return "Dados incompletos"
        case 2:
            return "Usuário não encontrado ou senha errada"
        case 3:
            return "Upload falhou"
        case 4:
            return "Usuario Já existe"
        case 5:
            return "Nenhum evento achado"
        case 6:
            return "Evento sem nenhuma pessoa"
        case -1009:
            return "Conexão com a internet parece estar offline"
        case -1001:
            return "Conexão com a internet ruim"
        default:
            return "Internal error"
            
        }
    }
}