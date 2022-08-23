//
//  MusicTypeController.swift
//  PeaceAround
//
//  Created by Henrique Batista de Assis on 13/07/22.
//

import Foundation
import UIKit

class MusicTypeController : UIViewController
{
    private var selectedSound: String
    
    // uiviews ////////////////////////
    var tableview: UITableView =
    {
        let table = UITableView(frame: CGRect.zero, style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        
        return table
        
    }()
    
    let leftCellImages: [UIImage] = [
        UIImage(systemName: "music.note")!,
        UIImage(systemName: "leaf")!,
        UIImage(systemName: "speaker.slash")!
    ]
    
    let titleLabelsCell: [String] = [
        "Músicas",
        "Efeitos sonoros",
        "Sem som"
    ]
    
    // init ////////////////
    init(_ selectedSound: String)
    {
        self.selectedSound = selectedSound
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // VIEWS ////////////////////////////////////////////////////////////////////
    override func viewWillAppear(_ animated: Bool)
    {
        tableview.reloadData()
    }
    
    override func viewDidLoad()
    {
        // navigation items
        navigationItem.title = "Adicionar Som"
        navigationItem.backButtonTitle = "Voltar"
        
        // tableview
        self.view.addSubview(tableview)
        tableview.register(MusicTypeCell.self, forCellReuseIdentifier: "MusicTypeCell")
        tableview.delegate = self
        tableview.dataSource = self
        tableview.rowHeight = 60
        tableConstraints()
        
        super.viewDidLoad()
    }
    
    private func tableConstraints()
    {
        NSLayoutConstraint.activate([
            tableview.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            tableview.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            tableview.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 0),
            tableview.heightAnchor.constraint(equalTo: self.view.heightAnchor, constant: 0)
        ])
    }
}

extension MusicTypeController : UITableViewDelegate
{
    // DID SELECT ROW AT /////////////////
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        // musics and sounds
        if indexPath.section == 0
        {
            let ssc = SoundSelectionController(titleLabelsCell[indexPath.row], self.selectedSound)
            navigationController?.pushViewController(ssc, animated: true)
        }
        
        // mute
        else
        {
            if selectedSound != "Mute"
            {
                let hvc = HomeViewController("Mute")
                NotificationCenter.default.post(name: Notification.Name("invalidateTime"), object: nil)
                navigationController?.setViewControllers([hvc], animated: true)
            }
            
            else
            {
                let noSoundAlert = UIAlertController(title: "Sem som", message: "Já não há nenhum som selecionado.", preferredStyle: .alert)
                noSoundAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] (_)in } ))
                
                present(noSoundAlert, animated: true, completion: nil)
                
                tableView.reloadData()
                
            }
        }
        
    }
    
    // NUMBER OF SECTIONS ///////////////
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
}

extension MusicTypeController : UITableViewDataSource
{
    // NUMBERS OF ROWS IN SECTION
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0
        {
            return 2
        }
        
        else
        {
            return 1
        }
    }
    
    // CELL FOR ROW AT
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicTypeCell", for: indexPath) as! MusicTypeCell

        if indexPath.section == 0
        {
            cell.leftImage.image = leftCellImages[indexPath.row]
            cell.leftImage.tintColor = UIColor.black
            cell.titleLabel.text = titleLabelsCell[indexPath.row]
            cell.titleLabel.sizeToFit()
            cell.rightImage.image = UIImage(systemName: "chevron.right")
            cell.rightImage.tintColor = UIColor.systemGray4
        }

        else
        {
            cell.leftImage.image = leftCellImages[indexPath.row + 2]
            cell.leftImage.tintColor = UIColor.black
            cell.titleLabel.text = titleLabelsCell[indexPath.row + 2]
            cell.titleLabel.sizeToFit()
            
            if self.selectedSound == "Mute"
            {
                cell.rightImage.image = UIImage(systemName: "checkmark.circle")
                cell.rightImage.tintColor = UIColor.black
            }
            
            else
            {
                cell.rightImage.image = nil
            }
        }
        
        return cell
    }
}
