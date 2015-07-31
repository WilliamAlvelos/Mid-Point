//
//  ConfigurationViewController.swift
//  MidPoint
//
//  Created by Danilo Mative on 27/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import UIKit

class ConfigurationViewController: UIViewController {

    @IBOutlet weak var vehicleSwitch: UISwitch!
    
    @IBOutlet weak var favoritePrivate: UIButton!
    @IBOutlet weak var favoriteFriends: UIButton!
    @IBOutlet weak var favoritePublic: UIButton!
    
    @IBOutlet weak var historicPrivate: UIButton!
    @IBOutlet weak var historicFriends: UIButton!
    @IBOutlet weak var historicPublic: UIButton!
    
    var favoriteButtons:[UIButton]!
    var historicButtons:[UIButton]!
    
    @IBOutlet weak var eventNotifSwitch: UISwitch!
    @IBOutlet weak var friendLocalizeSwitch: UISwitch!
    @IBOutlet weak var placesNotifSwitch: UISwitch!
    
    var favoritesVisibility:VisibilityType!
    var historicVisibility:VisibilityType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoriteButtons = [favoritePublic, favoriteFriends, favoritePrivate]
        historicButtons = [historicPublic, historicFriends, historicPrivate]
        
        vehicleSwitch.on = UserConfigurations.sharedInstance().hasVehicle
        
        eventNotifSwitch.on = UserConfigurations.sharedInstance().eventsNotifications
        
        placesNotifSwitch.on = UserConfigurations.sharedInstance().placesNotifications
        
        friendLocalizeSwitch.on = UserConfigurations.sharedInstance().canBeLocalized
        
        activeButtonOnArray(favoriteButtons, index: numberFromVisibility(UserConfigurations.sharedInstance().favoritesVisibility) - 1)
        activeButtonOnArray(historicButtons, index: numberFromVisibility(UserConfigurations.sharedInstance().historicVisibility) - 1)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        UserConfigurations.sharedInstance().hasVehicle = vehicleSwitch.on
        
        UserConfigurations.sharedInstance().eventsNotifications = eventNotifSwitch.on
        
        UserConfigurations.sharedInstance().placesNotifications = placesNotifSwitch.on
        
        UserConfigurations.sharedInstance().canBeLocalized = friendLocalizeSwitch.on
    }
    
    
    func activeButtonOnArray(array:[AnyObject], index:Int!) {
        
        var button = array[index] as! UIButton
        //Active button *******
        //*******
    }
    
    @IBAction func changeFavoritesVisibility(sender:UIButton) {
        clearFavoriteButtons()
        
        UserConfigurations.sharedInstance().favoritesVisibility = visibilityByNumber(sender.tag)
        
        ///******
        //Change sender to active ***
    }
    
    @IBAction func changeHistoricVisibility(sender:UIButton) {
        clearFavoriteButtons()
        
        UserConfigurations.sharedInstance().historicVisibility = visibilityByNumber(sender.tag)
        
        //*******
        //Change sender to active ***
    }
    
    func clearFavoriteButtons() {
        
        //*******
        //Change buttons to desactive *****
    }
    
    private func visibilityByNumber(value:Int!)->VisibilityType {
        
        //Public
        if value == 1 {
            return .Public
        }
        //Friends
        else if value == 2 {
            return .Friends
        }
        //Private
        else {
            return .Private
        }
        
    }
    
    private func numberFromVisibility(value:VisibilityType!)-> Int {
        
        if value == VisibilityType.Public {
            return 1
        }
            
        else if value == VisibilityType.Friends {
            return 2
        }
            
        else {
            return 3
        }
        
    }

}
