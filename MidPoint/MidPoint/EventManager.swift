//
//  UserManager.swift
//  MidPoint
//
//  Created by William Alvelos on 07/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//
@objc protocol EventManagerDelegate{
    optional func saveEventFinished(event: Event)
    optional func eventNotFound(event : Event)
    optional func getEventFinished(event: Event)
   optional func getEventsFinished(events: Array<Event>)
    //optional func inviteFinished(event: Event)
    optional func uploadImageFinished()
    optional func progressUpload(float : Float)
    func errorThrowedSystem(error: NSError)
    optional func errorThrowedServer(stringError: String)
    optional func downloadImageEventFinshed(event: Event)
    //ptional func downloadImageEventFinished(images: Array<Event>)
}
class EventManager: EventoDAOCloudKitDelegate, PictureCloudKitDelegate{
    private var eventDao : EventDAOCloudKit?
    private var pictureDao : PictureCloudKit?
    var delegate : EventManagerDelegate?
    init(){
        eventDao = EventDAOCloudKit()
        
        eventDao?.delegate = self
        pictureDao = PictureCloudKit()
        pictureDao?.delegate = self
    }
    func errorThrowed(error: NSError){
        self.delegate?.errorThrowedServer?(ErrorHandling.stringForError(error))
    }
    func saveEventFinished(event: Event){
        self.pictureDao?.uploadImageEvent(event)
        self.delegate?.saveEventFinished?(event)
    }
    func eventNotFound(event : Event){
        self.delegate?.eventNotFound?(event)
    }
    func getEventFinished(event: Event){
        self.delegate?.getEventFinished?(event)
    }
    func getEventsFinished(events: Array<Event>){
        self.delegate?.getEventsFinished?(events)
    }
    func progressUpload(float : Float){
        self.delegate?.progressUpload?(float)
    }
    func saveImageFinished(){
        self.delegate?.uploadImageFinished?()
    }
    
    
     func saveEvent(event: Event, usuario: User, friends: Array<User>, localizacaoUsuario: Localizacao ){
        if friends.count == 0 {
            let error = NSError(domain: "Event error", code: 1, userInfo: nil)
            self.delegate?.errorThrowedSystem(error)
            return
        }
        eventDao?.saveEvent(event, usuario: usuario, friends : friends, localizacaoUsuario : localizacaoUsuario)
        
    }
    func getEventsFromUser(user : User, usuario : Option){
        eventDao?.getEventsFromUser(user, usuario: usuario)
    }
    
    func getEventInformations(event: Event){
        eventDao?.getEventInformations(event)
    }
    func getImage(event :Event){
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue, {
            event.image = self.eventDao?.downloadImage(event.id!)
            DispatcherClass.dispatcher({ () -> () in
                self.delegate?.downloadImageEventFinshed?(event)
            })
        
        })
    
    }
}
