//
//  PullDownMenus.swift
//  PeaceAround
//
//  Created by Henrique Batista de Assis on 07/07/22.
//

import Foundation
import UIKit

class PullDownMenus
{
    // attributes /////////////////////////////////////////////////////////////
    private var soundMenuTitle = "Adicionar Som"
    lazy private var hvc = HomeViewController()
    let sb: UIStoryboard
    let hvcIdent: UIViewController
    
    //enums
    private var soundType: SoundType = SoundType.circle
    private var soundMovement: SoundMovement = SoundMovement.leftRight
    private var soundColor: SoundColor = SoundColor.colorful
    
    init()
    {
        self.sb = UIStoryboard(name: "Main", bundle: nil)
        self.hvcIdent = sb.instantiateViewController(withIdentifier: "HomeViewController")
    }
    
    // methods ////////////////////////////////////////////////////////////////
    private func saveData()
    {
        UserDefaults().setValue(self.soundType.rawValue, forKey: "soundType")
        UserDefaults().setValue(self.soundMovement.rawValue, forKey: "soundMovement")
        UserDefaults().setValue(self.soundColor.rawValue, forKey: "soundColor")
    }
    
    private func loadData()
    {
        if let loadType = UserDefaults().value(forKey: "soundType") as? Int
        {
            self.soundType = SoundType(rawValue: loadType) ?? .circle
        }
        
        if let loadMovement = UserDefaults().value(forKey: "soundMovement") as? Int
        {
            self.soundMovement = SoundMovement(rawValue: loadMovement) ?? .leftRight
        }
        
        if let loadColor = UserDefaults().value(forKey: "soundColor") as? Int
        {
            self.soundColor = SoundColor(rawValue: loadColor) ?? .colorful
        }
    }
    
    public func createMenu() -> UIMenu
    {
        var mainMenu = UIMenu()
        var divider: [UIMenu] = []
        
        // actions ////////////////////////////////////////////////////////////
        let addSoundAction = [
            UIAction(title: self.soundMenuTitle, image: UIImage(systemName: "music.note.list")) {(action) in self.addSoundHandler()}
        ]
        
        let typeActions = [
            UIAction(title: "Direção circular") { (action) in self.typeHandler(true) },
            UIAction(title: "Direção por sliders") { (action) in self.typeHandler(false) }
        ]
        
        let moveActions = [
            UIAction(title: "Movimentação Esquerda-Direita") { (action) in self.moveHandler(0) },
            UIAction(title: "Movimentação Atrás-Frente") { (action) in self.moveHandler(1) },
            UIAction(title: "Movimentação Em volta") { (action) in self.moveHandler(2) },
            UIAction(title: "Sem movimentação") { (action) in self.moveHandler(3) }
        ]
        
        let colorActions = [
            UIAction(title: "Colorido") { (action) in self.colorHandler(true) },
            UIAction(title: "Preto e Branco") { (action) in self.colorHandler(false) }
        ]
        
        // states ////////////////////
        loadData()
        switch self.soundType
        {
        case .circle:
            typeActions[0].state = .on
        case .sliders:
            typeActions[1].state = .on
        }
        
        switch self.soundMovement
        {
        case .leftRight:
            moveActions[0].state = .on
        case .backFront:
            moveActions[1].state = .on
        case .around:
            moveActions[2].state = .on
        case .noMove:
            moveActions[3].state = .on
        }
        
        switch self.soundColor
        {
        case .colorful:
            colorActions[0].state = .on
        case .blackWhite:
            colorActions[1].state = .on
        }
        
        divider.append(UIMenu(title: "", options: .displayInline, children: addSoundAction))
        divider.append(UIMenu(title: "", options: [.displayInline, .singleSelection], children: typeActions))
        divider.append(UIMenu(title: "", options: [.displayInline, .singleSelection], children: moveActions))
        divider.append(UIMenu(title: "", options: [.displayInline, .singleSelection], children: colorActions))
        
        mainMenu = UIMenu(children: [
            divider[0],
            divider[1],
            divider[2],
            divider[3]
        ])
        
        return mainMenu
    }
    
    // handlers ///////////////////////////////////////////////////////////////
    private func addSoundHandler()
    {
        NotificationCenter.default.post(name: Notification.Name("pushMusicType"), object: nil)
    }
    
    private func typeHandler(_ circle: Bool)
    {
        DispatchQueue.main.async
        {
            // muda pra circulo
            if circle
            {
                self.soundType = .circle
                self.saveData()
                
                NotificationCenter.default.post(name: Notification.Name("changeToCircle"), object: nil)
            }
            
            // muda pra sliders
            else
            {
                self.soundType = .sliders
                self.saveData()
                
                NotificationCenter.default.post(name: Notification.Name("changeToSliders"), object: nil)
            }
        }
        
    }
    
    private func moveHandler(_ moveType: Int)
    {
        // 0 = L-R
        // 1 = B-F
        // 2 = Around
        // 3 = No Move
        
        print("teste move \(moveType)")
    }
    
    private func colorHandler(_ colorful: Bool)
    {
        DispatchQueue.main.async
        {
            // muda pra colorido
            if colorful
            {
                self.soundColor = .colorful
                self.saveData()
                
                NotificationCenter.default.post(name: Notification.Name("changeToColorful"), object: nil)
            }
            
            // muda pra preto e branco
            else
            {
                self.soundColor = .blackWhite
                self.saveData()
                
                NotificationCenter.default.post(name: Notification.Name("changeToBlackWhite"), object: nil)
            }
        }
    }
    
    // setters ////////////////////////////////////////////////////////////////
    public func setSoundMenuTitle(_ soundMenuTitle: String)
    {
        self.soundMenuTitle = soundMenuTitle
    }
}
