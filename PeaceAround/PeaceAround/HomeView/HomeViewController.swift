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
    lazy private var pullDownMenus = PullDownMenus()
    private var sb = UIStoryboard(name: "Main", bundle: nil)
    
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
    
    private let circle: UIImageView =
    {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "circulo_color")
        image.contentMode = .scaleAspectFit
        
        return image
    }()
    
    // sliders ///////////////////////////////////////////////////////////////
    private let lrSlider: UISlider =
    {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = -1
        slider.maximumValue = 1
        slider.isContinuous = true
        slider.minimumTrackTintColor = UIColor.systemBlue
        slider.maximumTrackTintColor = UIColor.systemOrange
        slider.minimumValueImage = UIImage(systemName: "e.circle")?.withTintColor(UIColor.black, renderingMode: .alwaysOriginal)
        slider.maximumValueImage = UIImage(systemName: "d.circle")?.withTintColor(UIColor.black, renderingMode: .alwaysOriginal)
        slider.addTarget(self, action: #selector(lrSliderChange(_:)), for: .valueChanged)
        
        return slider
    }()
    
    private let bfSlider: UISlider =
    {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = -1
        slider.maximumValue = 1
        slider.isContinuous = true
        slider.minimumTrackTintColor = UIColor.systemPurple
        slider.maximumTrackTintColor = UIColor.systemYellow
        slider.minimumValueImage = UIImage(systemName: "a.circle")?.withTintColor(UIColor.black, renderingMode: .alwaysOriginal)
        slider.maximumValueImage = UIImage(systemName: "f.circle")?.withTintColor(UIColor.black, renderingMode: .alwaysOriginal)
        slider.addTarget(self, action: #selector(bfSliderChange(_:)), for: .valueChanged)
        
        return slider
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
    
    // VIEWS ////////////////////////////////////////////////////////////////
    override func viewWillAppear(_ animated: Bool)
    {
        if UserDefaults.standard.object(forKey: "soundType") != nil &&
           UserDefaults.standard.object(forKey: "soundMovement") != nil &&
           UserDefaults.standard.object(forKey: "soundColor") != nil
        {
            self.loadData()
        }
        
        else
        {
            self.saveData()
        }
        
        // load views
        self.setLoadedSubviews()
        
        navigationItem.rightBarButtonItem = moreMenu
        moreMenu.menu = pullDownMenus.createMenu()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // notifications /////////////////////////////////////////
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushMusicType), name: Notification.Name("pushMusicType"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeToSliders), name: Notification.Name("changeToSliders"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeToCircle), name: Notification.Name("changeToCircle"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeToColorful), name: Notification.Name("changeToColorful"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeToBlackWhite), name: Notification.Name("changeToBlackWhite"), object: nil)

        
        // navigation items
        navigationItem.title = navTitle
        navigationItem.backButtonTitle = "Voltar"
        
        // toolbar
        navigationController?.setToolbarHidden(false, animated: false)
        self.setToolbarAppearance()
        self.setToolbarItems()
        
        // subviews
        self.view.addSubview(backheadImg)
        self.view.addSubview(circle)
        self.view.addSubview(lrSlider)
        self.view.addSubview(bfSlider)
        lrSlider.isHidden = true
        bfSlider.isHidden = true
        
        // constraints calls
        self.centerConstraints(backheadImg, -320, -320)
        self.centerConstraints(circle, -40, -40)
        self.centerYOffset(lrSlider, -150, -80, -660)
        self.centerYOffset(bfSlider, 150, -80, -660)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
    }
    
    // methods //////////////////////////////////////////////////////////////
    private func saveData()
    {
        print("saved")
        UserDefaults().setValue(self.soundType.rawValue, forKey: "soundType")
        UserDefaults().setValue(self.soundMovement.rawValue, forKey: "soundMovement")
        UserDefaults().setValue(self.soundColor.rawValue, forKey: "soundColor")
    }
    
    private func loadData()
    {
        print("loaded")
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
    
    private func setToolbarAppearance()
    {
        let toolBarAppearance = UIToolbarAppearance()
        toolBarAppearance.backgroundColor = UIColor.systemGray6
        
        navigationController?.toolbar.standardAppearance = toolBarAppearance
        navigationController?.toolbar.scrollEdgeAppearance = toolBarAppearance
        navigationController?.toolbar.compactAppearance = toolBarAppearance
    }
    
    private func setToolbarItems()
    {
        var tbItems = [UIBarButtonItem]()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        tbItems.append(flexSpace)
        tbItems.append(pausePlayItem)
        tbItems.append(flexSpace)
        tbItems.append(muteItem)
        tbItems.append(flexSpace)
        
        toolbarItems = tbItems
    }
    
    private func setLoadedSubviews()
    {
        switch soundType
        {
        case .circle:
            self.changeToCircle()
            
        case .sliders:
            self.changeToSliders()
        }
        
        switch soundColor
        {
        case .colorful:
            self.changeToColorful()
            
        case .blackWhite:
            self.changeToBlackWhite()
        }
    }

    // selectors ////////////////////////////////////////////////////////////
    @objc private func pushMusicType()
    {
        let mtcIdent = sb.instantiateViewController(withIdentifier: "MusicTypeController")
        navigationController?.pushViewController(mtcIdent, animated: true)
    }
    
    @objc private func changeToSliders()
    {
        DispatchQueue.main.async
        {
            self.setSoundType(SoundType.sliders)
            
            self.circle.isHidden = true
            
            self.lrSlider.isHidden = false
            self.bfSlider.isHidden = false
        }
            
    }
    
    @objc private func changeToCircle()
    {
        DispatchQueue.main.async
        {
            self.setSoundType(SoundType.circle)
            
            self.lrSlider.isHidden = true
            self.bfSlider.isHidden = true
            
            self.circle.isHidden = false
        }
    }
    
    @objc private func changeToColorful()
    {
        DispatchQueue.main.async
        {
            self.setSoundColor(SoundColor.colorful)
            
            self.circle.image = UIImage(named: "circulo_color")
            
            self.lrSlider.minimumTrackTintColor = UIColor.systemBlue
            self.lrSlider.maximumTrackTintColor = UIColor.systemOrange
            
            self.bfSlider.minimumTrackTintColor = UIColor.systemPurple
            self.bfSlider.maximumTrackTintColor = UIColor.systemYellow
        }
    }
    
    @objc private func changeToBlackWhite()
    {
        DispatchQueue.main.async
        {
            self.setSoundColor(SoundColor.blackWhite)
            
            self.circle.image = UIImage(named: "circulo_bw")
            
            self.lrSlider.minimumTrackTintColor = UIColor.systemGray2
            self.lrSlider.maximumTrackTintColor = UIColor.systemGray5
            
            self.bfSlider.minimumTrackTintColor = UIColor.systemGray2
            self.bfSlider.maximumTrackTintColor = UIColor.systemGray5
        }
    }
    
    @objc private func lrSliderChange(_ sender: UISlider!)
    {
        
    }
    
    @objc private func bfSliderChange(_ sender: UISlider!)
    {
        
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
    
    private func centerYOffset(_ obj: UIView, _ offset: CGFloat, _ width: CGFloat, _ height: CGFloat)
    {
        NSLayoutConstraint.activate([
            obj.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            obj.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor, constant: offset),
            obj.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, constant: width),
            obj.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, constant: height)
        ])
    }
    
    // getters ///////////////////////////////////////////////////////////////
    public func getNavTitle() -> String {
        return self.navTitle }
    
    public func getCircleColor() -> UIImageView {
        return self.circle }
    
    public func getLrSlider() -> UISlider {
        return self.lrSlider }
    
    public func getBfSlider() -> UISlider {
        return self.bfSlider }
    
    public func getSoundType() -> SoundType {
        return self.soundType }
    
    public func getSoundMovement() -> SoundMovement {
        return self.soundMovement }
    
    public func getSoundColor() -> SoundColor {
        return self.soundColor }
    
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
