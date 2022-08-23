//
//  SoundSelectionController.swift
//  PeaceAround
//
//  Created by Henrique Batista de Assis on 20/07/22.
//

import Foundation
import UIKit

class SoundSelectionController : UITableViewController
{
    // cell data ///////////
    let musics: [String] = [
        "Banho de Sol",
        "Cura ao Ar Livre",
        "Encosta da Montanha",
        "Geada Matinal",
        "Lagoa Escondida",
        "Manhã de Inverno",
        "Montanhas Distantes",
        "Reino de Coral",
        "Serenidade nos Céus",
        "Tranquilidade a 30000 Pés"
    ]
    
    let sounds: [String] = [
        "Beira do Oceano",
        "Chuva e Trovão",
        "Chuva em Metal",
        "Chuvisco com Pássaros",
        "Pássaros Matinais",
        "Vento Fino"
    ]
    
    private let soundType: String
    private let selectedSound: String
    
    // inits ////////////////////
    init(_ soundType: String, _ selectedSound: String)
    {
        self.soundType = soundType
        self.selectedSound = selectedSound
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // views ///////////////////////
    override func viewWillAppear(_ animated: Bool)
    {
        tableView.reloadData()
    }
    
    override func viewDidLoad()
    {
        navigationItem.title = soundType
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        super.viewDidLoad()
    }
    
    // tableviews ///////////////////////////
    
    // DID SELECT ROW AT //////////////////////
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let hvc: HomeViewController
        if self.soundType == "Músicas"
        {
            if selectedSound != musics[indexPath.row]
            {
                hvc = HomeViewController(musics[indexPath.row])
                NotificationCenter.default.post(name: Notification.Name("invalidateTime"), object: nil)
                navigationController?.setViewControllers([hvc], animated: true)
            }
            
            else
            {
                let playingSoundALert = UIAlertController(title: "Música tocando", message: "Esta música já está sendo reproduzida.", preferredStyle: .alert)
                playingSoundALert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] (_)in } ))
                
                present(playingSoundALert, animated: true, completion: nil)
                
                tableView.reloadData()
            }
        }
        
        else
        {
            if selectedSound != sounds[indexPath.row]
            {
                hvc = HomeViewController(sounds[indexPath.row])
                NotificationCenter.default.post(name: Notification.Name("invalidateTime"), object: nil)
                navigationController?.setViewControllers([hvc], animated: true)
            }
            
            else
            {
                let playingSoundALert = UIAlertController(title: "Efeito sonoro tocando", message: "Este efeito sonoro já está sendo reproduzido.", preferredStyle: .alert)
                playingSoundALert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] (_)in } ))
                
                present(playingSoundALert, animated: true, completion: nil)
                
                tableView.reloadData()
            }
        }
        
        
    }
    
    // NUMBER OF SECTIONS //////////////////////
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    // NUMBER OF ROWS IN SECTION ///////////////
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.soundType == "Músicas"
        {
            return musics.count
        }
        
        else
        {
            return sounds.count
        }
    }
    
    // CELL FOR ROW AT ////////////////////
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        if soundType == "Músicas"
        {
            content.text = musics[indexPath.row]
            
            if selectedSound == self.musics[indexPath.row]
            {
                content.image = UIImage(systemName: "checkmark.circle")
                content.imageProperties.tintColor = .black
            }
        }
        
        else
        {
            content.text = sounds[indexPath.row]
            
            if selectedSound == self.sounds[indexPath.row]
            {
                content.image = UIImage(systemName: "checkmark.circle")
                content.imageProperties.tintColor = .black
            }
        }
        
        cell.contentConfiguration = content
        return cell
    }
}
