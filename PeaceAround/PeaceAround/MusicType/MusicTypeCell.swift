//
//  MusicTypeCell.swift
//  PeaceAround
//
//  Created by Henrique Batista de Assis on 19/07/22.
//

import Foundation
import UIKit

class MusicTypeCell : UITableViewCell
{
    let leftImage: UIImageView =
    {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.contentMode = .scaleAspectFit
        
        return imageview
    }()
    
    let rightImage: UIImageView =
    {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.contentMode = .scaleAspectFit
        
        return imageview
    }()
    
    let titleLabel: UILabel =
    {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(leftImage)
        addSubview(titleLabel)
        addSubview(rightImage)
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func constraints()
    {
        // left image
        NSLayoutConstraint.activate([
            leftImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            leftImage.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -130),
            leftImage.widthAnchor.constraint(equalTo: widthAnchor, constant: -100),
            leftImage.heightAnchor.constraint(equalTo: heightAnchor, constant: -30)
        ])
        
        // label
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            titleLabel.leadingAnchor.constraint(equalTo: leftImage.trailingAnchor, constant: -80),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
//            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        
        // right image
        NSLayoutConstraint.activate([
            rightImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightImage.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 130),
            rightImage.widthAnchor.constraint(equalTo: widthAnchor, constant: -100),
            rightImage.heightAnchor.constraint(equalTo: heightAnchor, constant: -30)
        ])
    }
}
