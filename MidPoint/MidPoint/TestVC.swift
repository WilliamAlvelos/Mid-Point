//
//  TestVC.swift
//  MidPoint
//
//  Created by Danilo Mative on 24/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import UIKit

class TestVC: UIViewController {

    
    var ocView: OCView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //* THIS CLASS IS A GIFT FOR WILL AND JOHN *
        
        // ** ETBScrollView ** --------------------
        
        //Criando uma nova ETBScrollView
        
        /* Cria uma nova ETB, com a quantidade de botões 
        na barra e a imagem de cada um deles */
        
        var newETB = ETBScrollView(numberOfButtons: 3, images:[UIImage(named: "btest1.png")!, UIImage(named: "btest2.png")!,UIImage(named: "btest3.png")!])
        
        //Cor de fundo da barra
        newETB.toolbarBackgroundColor = UIColor.blackColor()
        
        //Foto do usuário
        newETB.profileImage = UIImage(named: "b_search.png")
        
        //Nome do usuário
        newETB.profileName = "William Chola"
        
        //Local do usuário
        newETB.profileLocation = "Terra dos feeders"
        
        //View de teste
        var viewTeste = UIView(frame:self.view.frame)
        viewTeste.backgroundColor = UIColor.redColor()
        
        //Prepara a ETB, passando a view com o conteúdo que ela terá normalmente e o frame da view onde a ETB será inserida
        newETB.prepareScrollViewWithContent(viewTeste, frame: self.view.frame)
        
        //Mude a cor da view que irá inserir a ETB para a mesma da toolbar
        self.view.backgroundColor = UIColor.blackColor()
        
        //Adiciona a ETB na view
        //self.view.addSubview(newETB)
        
        //Adiciona um seletor para o botão no indice passado
        newETB.addSelectorToButton(2,target:self, selector: Selector("holyTest"))
        
        
        // ** UBA ** --------------------
        
        
        //Inicia a UBA com o numero de botoões
        var uba = UBAView(buttonsQuantity: 3)
        
        //Prepara os botões na view passada
        //uba.prepareAnimationOnView(self.view)
        
        //Adiciona um seletor para o botão no indice passado
        uba.addSelectorToButton(1,target:self, selector: Selector("holyTest"))
        
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
