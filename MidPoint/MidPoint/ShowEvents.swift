//
//  ShowEvents.swift
//  MidPoint
//
//  Created by Joao Sisanoski on 8/4/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import UIKit

class ShowEvents: UIViewController, EventManagerDelegate {
    
    @IBOutlet weak var scroll: UIScrollView!
    private var y =  Float(10)
    private var x:Float = 10
    var eventManager: EventManager?
    var events : Array<Event>?
    var activity : activityIndicator?
    override func viewDidLoad() {
        self.activity = activityIndicator(view: self.navigationController!, texto: "Buscando Grupos", inverse: false, viewController: self)
                super.viewDidLoad()
        self.eventManager = EventManager()
        eventManager?.delegate = self
        self.scroll.showsVerticalScrollIndicator = false
        self.scroll.showsHorizontalScrollIndicator = false
        self.eventManager!.getEventsFromUser(UserDAODefault.getLoggedUser(), usuario: .All)

        
        // Do any additional setup after loading the view.
    }
    func errorThrowedServer(stringError: String) {
        
    }
    func errorThrowedSystem(error: NSError) {
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        activity?.removeActivityViewWithName(self)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func prepareScroll(){
        let width = CGFloat((UIScreen.mainScreen().bounds.size.width - 30) / 2)
        let screenHeight = UIScreen.mainScreen().bounds.size.height + 10
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let scrollBarHeight = self.navigationController?.navigationBar.frame.height
        self.scroll.contentSize = CGSizeMake(screenWidth , CGFloat(events!.count/2) *  CGFloat(width + 10))
    
        x = 10
        y = 10
        for (var i = 0 ; i < events!.count ; i++){
            let soundView = SoundView(frame: CGRectMake(CGFloat(x), CGFloat(y), width, width))
            soundView.image.image = events![i].image
            soundView.label.text = events![i].name
            soundView.number.text = "\(events![i].numberOfPeople!) pessoa(s)."
            soundView.button.tag = i
            soundView.button.addTarget(self, action: "buttonTapped:", forControlEvents: .TouchUpInside)
            x = alterna(x)
            self.scroll.addSubview(soundView)
        }
        
        activity?.removeActivityViewWithName(self)
    }
    
    private func alterna(number : Float)->Float{
        let width = CGFloat((UIScreen.mainScreen().bounds.size.width - 30) / 2) + 20
        if Float(width) == x {
             y = y + Float(width) - 10
            return 10
        }
        return Float(width)
    }
    func buttonTapped(sender : UIButton){
        let nextView = TransitionManager.creatView("changeMidPoint") as! ChangeMidPointViewController
        nextView.event = events![sender.tag]
        nextView.conversa = events![sender.tag].id
        self.navigationController?.pushViewController(nextView, animated: true)    }
    func getEventsFinished(events: Array<Event>) {
        self.eventManager!.getImages(events)
    }
    func downloadImageEventsFinshed(images: Array<Event>) {
        self.events = images
        self.prepareScroll()
    }
}
