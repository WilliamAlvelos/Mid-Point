//
//  TestVC.swift
//  MidPoint
//
//  Created by Danilo Mative on 24/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import UIKit

class TestVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ETBNavigationTitle {

    
    @IBOutlet weak var testView: UIView!
    @IBOutlet weak var table: UITableView!
    var ocView: OCView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        testView.backgroundColor = Colors.Rosa
        
//        table.delegate = self
//        table.dataSource = self
//        table.reloadData()
        
        //* THIS CLASS IS A GIFT FOR WILL AND JOHN *
        
        // ** ETBScrollView ** --------------------
        
        //Criando uma nova ETBScrollView
        
        /* Cria uma nova ETB, com a quantidade de botões 
        na barra e a imagem de cada um deles */
                
        var newETB = ETBScrollView(numberOfButtons: 3, images:[UIImage(named: "user_historico")!, UIImage(named: "user_locais_favoritos")!,UIImage(named: "user_chat")!], backgroundImage:UIImage(named: "testbg.png")!)
        
        //Cor de fundo da barra
        newETB.toolbarBackgroundColor = UIColor.blackColor()
        
        //Foto do usuário
        newETB.profileImage = UIImage(named: "4user.png")
        
        //Nome do usuário
        newETB.profileName = "Felipe Viana Teruel"
        
        //Local do usuário
        newETB.profileLocation = "Diadema, SP"
        
        //View de teste
        var viewTeste = UIView(frame:self.view.frame)
        viewTeste.backgroundColor = UIColor.redColor()
        
        //Prepara a ETB, passando a view com o conteúdo que ela terá normalmente e o frame da view onde a ETB será inserida
        newETB.prepareScrollViewWithContentView(testView, frame: self.view.frame, navigationBar: self.navigationController!.navigationBar)
        
        //Mude a cor da view que irá inserir a ETB para a mesma da toolbar
        self.view.backgroundColor = UIColor.blackColor()
        
        newETB.ETBNavigationDelegate = self
        
        //Adiciona a ETB na view
        self.view.addSubview(newETB)
        
        //Adiciona um seletor para o botão no indice passado
        newETB.addSelectorToButton(2,target:self, selector: Selector("holyTest"))
        
        
        // ** UBA ** --------------------
        
        
        //Inicia a UBA com o numero de botoões
        //var uba = UBAView(buttonsQuantity: 3)
        
        //Prepara os botões na view passada
        //uba.prepareAnimationOnView(self.view)
        
        //Adiciona um seletor para o botão no indice passado
       // uba.addSelectorToButton(1,target:self, selector: Selector("holyTest"))
        
        
        // ** OCView ** --------------------
        
        var main = UIImage(named: "test.png")
        var images = [UIImage]()
        
        for var x = 0.3; x < 1.0; x = x + 0.2 {
            
            var newImage = getImageWithColor(UIColor(red: 0.8, green: 0.2, blue: CGFloat(x), alpha: 1.0), size: CGSizeMake(100.0,100.0))
            images.append(newImage)
            
        }
        
        var rect = CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height / 3.0)
        
        
        //Cria uma OCView, passando a imagem de capa, as imagens dentro da scrollview e o frame da OCVIew
        ocView = OCView(mainImage: main, insideImages: images, frame: rect)
        
        //Neste caso, todo o código acima é para criar imagens coloridas de teste para a OCView. Ele não é importante.
        
        
        //Adiciona a OCView
        //self.view.addSubview(ocView)
        
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    
    //For OCView test
    func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        var rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func holyTest() {
        println("hell yea")
    }

    //MARK: TableView delegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("Teste", forIndexPath: indexPath) as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Teste")
        }
        
        cell!.textLabel?.text = String(indexPath.row)
        
        return cell!
    }
    
    //MARK: ETB Delegate
    
    func shouldDisplayTitle(title:String!) {
        self.title = title
    }
    
    func shouldHideTitle() {
        self.title = ""
    }

}
