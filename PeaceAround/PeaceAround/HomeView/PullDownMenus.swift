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
    
    // methods ////////////////////////////////////////////////////////////////
    public func createMenu() -> UIMenu
    {
        var mainMenu = UIMenu()
        
        var divider: [UIMenu] = []
        
        let addSoundAction = [
            UIAction(title: self.soundMenuTitle, image: UIImage(systemName: "music.note.list")) {(action) in self.addSoundHandler()}
        ]
        
        let typeActions = [
            UIAction(title: "Direção circular", state: .on) { (action) in self.typeHandler(true) },
            UIAction(title: "Direção por sliders") { (action) in self.typeHandler(false) }
        ]
        
        let moveActions = [
            UIAction(title: "Movimentação Esquerda-Direita", state: .on) { (action) in self.moveHandler(0) },
            UIAction(title: "Movimentação Atrás-Frente") { (action) in self.moveHandler(1) },
            UIAction(title: "Movimentação Em volta") { (action) in self.moveHandler(2) },
            UIAction(title: "Sem movimentação") { (action) in self.moveHandler(3) }
        ]
        
        let colorActions = [
            UIAction(title: "Colorido", state: .on) { (action) in self.colorHandler(true) },
            UIAction(title: "Preto e Branco") { (action) in self.colorHandler(false) }
        ]
        
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
    private func colorHandler(_ colorful: Bool)
    {
        print("teste color \(colorful)")
    }
    
    private func moveHandler(_ moveType: Int)
    {
        // 0 = L-R
        // 1 = B-F
        // 2 = Around
        // 3 = No Move
        
        print("teste move \(moveType)")
    }
    
    private func typeHandler(_ circle: Bool)
    {
        print("teste type \(circle)")
    }
    
    private func addSoundHandler()
    {
        print("teste add")
    }
    
    // setters ////////////////////////////////////////////////////////////////
    public func setSoundMenuTitle(_ soundMenuTitle: String)
    {
        self.soundMenuTitle = soundMenuTitle
    }
}
