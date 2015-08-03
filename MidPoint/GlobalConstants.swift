//
//  GlobalConstants.swift
//  MidPoint
//
//  Created by Joao Sisanoski on 7/27/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import Foundation

struct Colors {
    static let Rosa = UIColor(red: 226/255, green: 27/255, blue: 94/255, alpha: 1)
    static let Azul = UIColor(red: 25/255, green: 25/255, blue: 89/255, alpha: 1)
    static let Branco = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
}


struct UserGlobalConstants {
    static let Id = "user_id"
    static let Name = "user_name"
    static let Email = "user_email"
    static let Password = "user_password"
    static let Image = "user_picture"
    static let Latitude = "user_latitude"
    static let Longitude = "user_longitude"
        static let Location = "user_location"
    
}
struct EventGlobalConstants {
    static let Id = "event_id"
    static let Name = "event_name"
    static let Description = "event_description"
    static let Date = "event_date"
    static let Latitude = "event_latitude"
    static let Longitude = "event_longitude"

    static let UserToInvite = "user_to_invite"
    static let UserSender = "user_sender"
    static let UserState = "user_state"
    static let Image = "event_picture"
    static let Pending = "pending"
    static let Total = "total"
    static let Accepted = "accepted"
    static let Refused = "refused"
    static let Number = "number"
    


}
struct LocationGlobalConstants{
    static let  NameLocation = "name_location"
    static let  LocationName = "localizacao_name"
    
    static let  Latitude = "latitude"
    static let  Longitude = "longitude"
    
}
struct LinkAccessGlobalConstants {
    
    static let LinkImagesUsers = "http://alvelos.wc.lt/MidPoint/users/user_images/"
    static let LinkImagesEvents = "http://alvelos.wc.lt/MidPoint/events/events_images/"
    static let LinkEvents = "http://alvelos.wc.lt/MidPoint/events/"
    static let LinkUsers = "http://www.alvelos.wc.lt/MidPoint/users/"
    

}

struct ParseGlobalConstants {
    static let Id = "user_id"
    static let Event_Id = "event_id"
    static let Logged = "logged"
    static let Group_id = "group_id"
    
}
struct FontName{
    static let ButtonFont = "Helvetica-Light"
    static let LabelFont = "Helvetica-Light"
    
}