//
//  HomeViewController.swift
//  PeaceAround
//
//  Created by Henrique Batista de Assis on 05/07/22.
//

import Foundation
import UIKit
import AVFoundation

class HomeViewController : UIViewController
{
    // vars and lets //////////////////////////////////////////////////////////
    private let navTitle = "Peace Around"
    lazy private var pullDownMenus = PullDownMenus()
    private var sb = UIStoryboard(name: "Main", bundle: nil)
    
    private var soundName: String
    
    private var xValue: Float = 0
    private var zValue: Float = 0
    
    private var isPaused: Bool
    private var toRight: Bool
    private var toFront: Bool
    private var isMoving: Bool
    
    private var sliderTime = Timer()
    
    // audio ////////
    let audioEngine = AVAudioEngine()
    let environment = AVAudioEnvironmentNode()
    let audioPlayer = AVAudioPlayerNode()
    
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
    
    // sliders ///////////////////////////////////////////////////////////////
    private let lrSlider: UISlider =
    {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = -5
        slider.maximumValue = 5
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
        slider.minimumValue = -5
        slider.maximumValue = 5
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
    
    lazy private var pauseBtn: UIButton =
    {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.configuration = .filled()
        btn.setTitle("Pausar", for: .normal)
        btn.configuration?.image = UIImage(systemName: "pause.fill")
        btn.configuration?.imagePlacement = .trailing
        btn.configuration?.imagePadding = 15
        btn.tintColor = .black
        btn.addTarget(self, action: #selector(pauseSound), for: .touchUpInside)
        
        
        return btn
    }()

//    private let muteItem: UIBarButtonItem =
//    {
//        let item = UIBarButtonItem()
//        item.title = "Mudo"
//        item.tintColor = UIColor.black
//
//        return item
//    }()
    
    // init /////////////////////////////////////////////////////////////////
    init(_ soundName: String)
    {
        self.soundName = soundName
        self.isPaused = false
        self.toRight = true
        self.toFront = true
        self.isMoving = false
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        self.configAudioEngine()
        
        if self.soundName != "Mute" && !self.isPaused
        {
            self.playSound()
            
            if !self.isMoving
            {
                self.sliderTime = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(callMove), userInfo: nil, repeats: true)

                self.isMoving = true
            }
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // notifications /////////////////////////////////////////
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushMusicType), name: Notification.Name("pushMusicType"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.moveSound(notification:)), name: Notification.Name("moveSound"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeToColorful), name: Notification.Name("changeToColorful"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeToBlackWhite), name: Notification.Name("changeToBlackWhite"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.invalidateTime), name: Notification.Name("invalidateTime"), object: nil)

        
        // navigation items
        navigationItem.title = navTitle
        navigationItem.backButtonTitle = "Voltar"
        
        // subviews
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(backheadImg)
        self.view.addSubview(lrSlider)
        self.view.addSubview(bfSlider)
        self.view.addSubview(pauseBtn)
        
        // constraints calls
        self.centerConstraints(backheadImg, -320, -320)
        self.centerYOffset(lrSlider, -150, -80, -660)
        self.centerYOffset(bfSlider, 150, -80, -660)
        self.centerYOffset(pauseBtn, 325, -80, -800)
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
    
    
    
    private func setLoadedSubviews()
    {
        switch soundColor
        {
        case .colorful:
            self.changeToColorful()
            
        case .blackWhite:
            self.changeToBlackWhite()
        }
    }
    
    private func configAudioEngine()
    {
        self.environment.listenerPosition = AVAudio3DPoint(x: 0, y: 0, z: 0)
        self.environment.listenerAngularOrientation = AVAudioMake3DAngularOrientation(0, 0, 0)

        self.audioEngine.attach(self.environment)
        
        let stereo = AVAudioFormat(standardFormatWithSampleRate: self.audioEngine.outputNode.outputFormat(forBus: 0).sampleRate, channels: 2)

        self.audioEngine.connect(self.environment, to: self.audioEngine.mainMixerNode, format: stereo)
        self.audioEngine.prepare()
        try! self.audioEngine.start()
    }
    
    private func playSound()
    {
        self.audioEngine.attach(self.audioPlayer)
        
        let mono = AVAudioFormat(standardFormatWithSampleRate: self.audioEngine.outputNode.outputFormat(forBus: 0).sampleRate, channels: 1)
        
        self.audioEngine.connect(self.audioPlayer, to: self.environment, format: mono)
        
        // file
        let url = Bundle.main.url(forResource: "\(self.soundName).wav", withExtension: nil)
        let file = try! AVAudioFile(forReading: url!)
        let audioFormat = file.processingFormat
        let audioFrameCount = UInt32(file.length)
        
        let audioFileBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: audioFrameCount)
        
        try! file.read(into: audioFileBuffer!)

        //self.audioPlayer.scheduleFile(file, at: nil, completionHandler: nil)
        self.audioPlayer.renderingAlgorithm = .HRTFHQ
        self.audioPlayer.scheduleBuffer(audioFileBuffer!, at: nil, options: .loops, completionHandler: nil)
        self.audioPlayer.position = AVAudio3DPoint(x: 0.0, y: 0.0, z: 0.0)
        self.audioPlayer.play()
        print("play")
    }

    // selectors ////////////////////////////////////////////////////////////
    @objc private func pushMusicType()
    {
        //let mtcIdent = sb.instantiateViewController(withIdentifier: "MusicTypeController")
        let mtc = MusicTypeController(soundName)
        navigationController?.pushViewController(mtc, animated: true)
    }
    
    @objc private func moveSound(notification: NSNotification)
    {
        let moveNumber: Int = notification.object as! Int
        self.setSoundMovement(SoundMovement.init(rawValue: moveNumber) ?? .leftRight)
    }
    
    @objc private func callMove()
    {
        switch self.soundMovement
        {
        case .noMove:
            break
            
        default:
            doMove()
        }
    }
    
    private func doMove()
    {
        let incrementValue: Float = 0.05
        let maxLRValue = self.lrSlider.maximumValue
        let maxBFValue = self.bfSlider.maximumValue
        
        self.xValue = self.lrSlider.value
        self.zValue = self.bfSlider.value
        
        if !self.isPaused
        {
            switch self.soundMovement
            {
            // left right ///////////////////////////
            case .leftRight:
                if self.toRight
                {
                    self.lrSlider.setValue(self.lrSlider.value + incrementValue, animated: true)
                    self.xValue = self.lrSlider.value
                    
                    if self.lrSlider.value >= maxLRValue
                    {
                        self.toRight = false
                    }
                }
                
                else
                {
                    self.lrSlider.setValue(self.lrSlider.value - incrementValue, animated: true)
                    self.xValue = self.lrSlider.value
                    
                    if self.lrSlider.value <= -maxLRValue
                    {
                        self.toRight = true
                    }
                }
            
            // back front ////////////////////////////
            case .backFront:
                if self.toFront
                {
                    self.bfSlider.setValue(self.bfSlider.value + incrementValue, animated: true)
                    self.zValue = self.bfSlider.value
                    
                    if self.bfSlider.value >= maxBFValue
                    {
                        self.toFront = false
                    }
                }
                
                else
                {
                    self.bfSlider.setValue(self.bfSlider.value - incrementValue, animated: true)
                    self.zValue = self.bfSlider.value
                    
                    if self.bfSlider.value <= -maxBFValue
                    {
                        self.toFront = true
                    }
                }
            
            // around //////////////////////////////
            case .around:
                // left right /////////
                if self.toRight
                {
                    self.lrSlider.setValue(self.lrSlider.value + incrementValue, animated: true)
                    self.xValue = self.lrSlider.value
                    
                    if self.lrSlider.value >= maxLRValue
                    {
                        self.toRight = false
                    }
                }
                
                else
                {
                    self.lrSlider.setValue(self.lrSlider.value - incrementValue, animated: true)
                    self.xValue = self.lrSlider.value
                    
                    if self.lrSlider.value <= -maxLRValue
                    {
                        self.toRight = true
                    }
                }
                
                // back front ////////////////
                if self.toFront
                {
                    self.bfSlider.setValue(self.bfSlider.value + incrementValue, animated: true)
                    self.zValue = self.bfSlider.value
                    
                    if self.bfSlider.value >= maxBFValue
                    {
                        self.toFront = false
                    }
                }
                
                else
                {
                    self.bfSlider.setValue(self.bfSlider.value - incrementValue, animated: true)
                    self.zValue = self.bfSlider.value
                    
                    if self.bfSlider.value <= -maxBFValue
                    {
                        self.toFront = true
                    }
                }
                
            default:
                break
            }
            
            self.audioPlayer.position = AVAudio3DPoint(x: self.xValue, y: 0, z: self.zValue)
        }
    }
    
    @objc private func changeToColorful()
    {
        DispatchQueue.main.async
        {
            self.setSoundColor(SoundColor.colorful)
            
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
            
            self.lrSlider.minimumTrackTintColor = UIColor.systemGray2
            self.lrSlider.maximumTrackTintColor = UIColor.systemGray5
            
            self.bfSlider.minimumTrackTintColor = UIColor.systemGray2
            self.bfSlider.maximumTrackTintColor = UIColor.systemGray5
        }
    }
    
    @objc private func lrSliderChange(_ sender: UISlider!)
    {
        self.xValue = sender.value
        self.audioPlayer.position = AVAudio3DPoint(x: self.xValue, y: 0, z: self.zValue)
    }
    
    @objc private func bfSliderChange(_ sender: UISlider!)
    {
        self.zValue = sender.value
        self.audioPlayer.position = AVAudio3DPoint(x: self.xValue, y: 0, z: self.zValue)
    }
    
    @objc private func pauseSound()
    {
        if self.soundName != "Mute"
        {
            // pausa a musica
            if !self.isPaused
            {
                self.isPaused = true
                self.pauseBtn.setTitle("Reproduzir", for: .normal)
                self.pauseBtn.configuration?.image = UIImage(systemName: "play.fill")
                self.audioPlayer.pause()
            }
            
            // despausa
            else
            {
                self.isPaused = false
                self.pauseBtn.setTitle("Pausar", for: .normal)
                self.pauseBtn.configuration?.image = UIImage(systemName: "pause.fill")
                self.audioPlayer.play()
            }
        }
    }
    
    @objc private func invalidateTime() {
        self.sliderTime.invalidate()
    }
    
    // constraints //////////////////////////////////////////////////////////
    private func centerConstraints(_ obj: UIView ,_ width: CGFloat, _ height: CGFloat)
    {
        NSLayoutConstraint.activate([
            obj.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            obj.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            obj.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: width),
            obj.heightAnchor.constraint(equalTo: self.view.heightAnchor, constant: height)
        ])
    }
    
    private func centerYOffset(_ obj: UIView, _ offset: CGFloat, _ width: CGFloat, _ height: CGFloat)
    {
        NSLayoutConstraint.activate([
            obj.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            obj.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: offset),
            obj.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: width),
            obj.heightAnchor.constraint(equalTo: self.view.heightAnchor, constant: height)
        ])
    }
    
    // getters ///////////////////////////////////////////////////////////////
    public func getNavTitle() -> String {
        return self.navTitle }
    
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
    
    
    
//    private func setToolbarAppearance()
//    {
//        let toolBarAppearance = UIToolbarAppearance()
//        toolBarAppearance.backgroundColor = UIColor.systemGray6
//
//        navigationController?.toolbar.standardAppearance = toolBarAppearance
//        navigationController?.toolbar.scrollEdgeAppearance = toolBarAppearance
//        navigationController?.toolbar.compactAppearance = toolBarAppearance
//    }
//
//    private func setToolbarItems()
//    {
//        var tbItems = [UIBarButtonItem]()
//        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
//
//        tbItems.append(contentsOf: [flexSpace, pausePlayItem, flexSpace, muteItem, flexSpace])
//
//        toolbarItems = tbItems
//    }
}
