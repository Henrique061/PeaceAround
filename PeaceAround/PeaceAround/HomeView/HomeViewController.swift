//
//  HomeViewController.swift
//  PeaceAround
//
//  Created by Henrique Batista de Assis on 05/07/22.
//

import Foundation
import UIKit
import AVFoundation
import MediaPlayer

class HomeViewController : UIViewController
{
    // vars and lets //////////////////////////////////////////////////////////
    private let navTitle = "Peace Around"
    private let toolBarAppearance = UIToolbarAppearance()
    private let pullDownMenus = PullDownMenus()
    
    //enums
    private var soundType: SoundType = SoundType.circle
    private var soundMovement: SoundMovement = SoundMovement.leftRight
    private var soundColor: SoundColor = SoundColor.colorful
    
    // ImageViews //////////////////////////////////////////////////////////////
    private let backheadImg: UIImageView =
    {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "backhead")
        image.contentMode = .scaleAspectFit
        
        return image
    }()
    
    private let circleColor: UIImageView =
    {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "circulo_color")
        image.contentMode = .scaleAspectFit
        
        return image
    }()
    
    // NavItem ///////////////////////////////////////////////////////////////
    private let moreMenu: UIBarButtonItem =
    {
        let barItem = UIBarButtonItem()
        barItem.image = UIImage(systemName: "ellipsis.circle")
        barItem.tintColor = .black
        
        return barItem
    }()
    
    // toolbar //////////////////////////////////////////////////////////////
    private let volumeItem: UIBarButtonItem =
    {
        let item = UIBarButtonItem()
        item.title = "Volume"
        item.tintColor = UIColor.black
        
        return item
    }()
    
    private let pausePlayItem: UIBarButtonItem =
    {
        let item = UIBarButtonItem()
        item.title = "Pausar"
        item.tintColor = UIColor.black
        
        return item
    }()

    private let muteItem: UIBarButtonItem =
    {
        let item = UIBarButtonItem()
        item.title = "Mudo"
        item.tintColor = UIColor.black
        
        return item
    }()
    
    private var tbItems = [UIBarButtonItem]()
    
    // VIEWS ////////////////////////////////////////////////////////////////
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // navigation items
        navigationItem.title = navTitle
        navigationItem.backButtonTitle = navTitle
        navigationItem.rightBarButtonItem = moreMenu
        moreMenu.menu = pullDownMenus.createMenu()
        
        // toolbar
        navigationController?.setToolbarHidden(false, animated: false)
        self.setToolbarAppearance()
        self.setToolbarItems()
        
        // subviews
        self.view.addSubview(backheadImg)
        self.view.addSubview(circleColor)
        
        // constraints calls
        self.centerConstraints(backheadImg, -320, -320)
        self.centerConstraints(circleColor, -40, -40)
    }
    
    // methods //////////////////////////////////////////////////////////////
    private func saveData()
    {
        UserDefaults().setValue(soundType, forKey: "soundEnums")
        UserDefaults().setValue(soundMovement, forKey: "soundEnums")
        UserDefaults().setValue(soundColor, forKey: "soundEnums")
    }
    
    private func loadData()
    {
        if let loadType = UserDefaults().value(forKey: "soundEnums") as? SoundType {
            soundType = loadType }
        
        if let loadMovement = UserDefaults().value(forKey: "soundEnums") as? SoundMovement {
            soundMovement = loadMovement }
        
        if let loadColor = UserDefaults().value(forKey: "soundEnums") as? SoundColor {
            soundColor = loadColor }
    }
    
    private func setToolbarAppearance()
    {
        toolBarAppearance.backgroundColor = UIColor.systemGray6
        
        navigationController?.toolbar.standardAppearance = toolBarAppearance
        navigationController?.toolbar.scrollEdgeAppearance = toolBarAppearance
        navigationController?.toolbar.compactAppearance = toolBarAppearance
    }
    
    private func setToolbarItems()
    {
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        tbItems.append(volumeItem)
        tbItems.append(flexSpace)
        tbItems.append(pausePlayItem)
        tbItems.append(flexSpace)
        tbItems.append(muteItem)
        
        toolbarItems = tbItems
    }
    
    // constraints //////////////////////////////////////////////////////////
    private func centerConstraints(_ obj: UIView ,_ width: CGFloat, _ height: CGFloat)
    {
        NSLayoutConstraint.activate([
            obj.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            obj.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
            obj.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, constant: width),
            obj.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, constant: height)
        ])
    }
    
    // setters ///////////////////////////////////////////////////////////////
    public func setSoundType(_ soundType: SoundType) {
        self.soundType = soundType
        self.saveData()
    }
    
    public func setSoundMovement(_ soundMovement: SoundMovement) {
        self.soundMovement = soundMovement
        self.saveData()
    }
    
    public func setSoundColor(_ soundColor: SoundColor) {
        self.soundColor = soundColor
        self.saveData()
    }
}
