//
//  PartidaTableViewController.swift
//  
//
//  Created by Joao Sisanoski on 8/1/15.
//
//

import UIKit

class PartidaTableViewController: UITableViewController, UITableViewDataSource , UITableViewDelegate, UserManagerDelegate {
           private var locations:Array<Localizacao> = Array()
    var user : User?
    private var  alertView1 =  JSSAlertView()
    private var  alertView2 =  JSSAlertView()
    var event: Event?
    var location: CLLocationCoordinate2D?
    var userManager = UserManager()
    override func  viewDidLoad() {
        self.title = "Pontos de Partida"
        var logButton : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: Selector("adicionarNovaLocalizacao"))
        self.navigationItem.rightBarButtonItem = logButton
                     self.tableView.delegate = self
        self.tableView.dataSource = self
        userManager.delegate = self
       
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.user = UserDAODefault.getLoggedUser()
        alertView1.show(self.navigationController!.view!, title: "Carregando", text: "Aguarde enquanto carregamos algumas informações", buttonText: nil, color: UIColorFromHex(0x9b59b6, alpha: 1))
        alertView1.setTextTheme(.Light)

        userManager.getAllLocation(self.user!)
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let nextView = TransitionManager.creatView("CreateConversation") as! CreateConversationViewController
        nextView.startLocation = locations[indexPath.row]
        if(self.location != nil){
            nextView.location = self.location
        }

        nextView.event = Event()
        self.navigationController?.pushViewController(nextView, animated: true)
        
    }
    func adicionarNovaLocalizacao(){
        let nextView = TransitionManager.creatView("PartidaSelectVC") as! PartidaSelectVC
        nextView.locations = self.locations
        self.presentViewController(nextView, animated: true, completion: nil)
    }
    override func  tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:PartidaViewCell = self.tableView.dequeueReusableCellWithIdentifier("PartidaCell") as! PartidaViewCell
        cell.name.text = self.locations[indexPath.row].name
        cell.selectionStyle = .None
        cell.local.text = "Latitude: \(self.locations[indexPath.row].latitude!) Latitude: \(self.locations[indexPath.row].longitude!)"
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locations.count
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func getLocationFinished(users: Array<Localizacao>) {
        alertView1.removeView()
        
        
        if (users.count == 0 ){
            var customIcon = UIImage(named: "lightbulb")
            var alertview = self.alertView2.show(self.navigationController!.view, title: "Erro", text: "Voce não possui nenhum local de partida", buttonText: "adicionar", cancelButtonText: "Depois", color: UIColor.redColor(), iconImage: customIcon)
            alertview.addAction(closeCallback)
            alertview.addCancelAction(cancelCallback)
            alertview.setTitleFont("ClearSans-Bold")
            alertview.setTextFont("ClearSans")
            alertview.setButtonFont("ClearSans-Light")
            alertview.setTextTheme(.Light)
        }
        
        self.locations = users
        self.tableView.reloadData()
    }


    func closeCallback() {
        self.adicionarNovaLocalizacao()
    }
    
    func cancelCallback() {
        println("Cancelar")
    }
    func errorThrowedServer(stringError: String) {
        alertView1.removeView()
        alertView2.danger(self.navigationController!.view, title: "Oh, shit.", text: stringError)
    }
    func errorThrowedSystem(error: NSError) {
    
        self.alertView1.removeView()
    }
    
}
