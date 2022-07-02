//
//  HeadsetAlertController.swift
//  PeaceAround
//
//  Created by Henrique Batista de Assis on 01/07/22.
//

import Foundation
import UIKit

class HeadsetAlertController: UIViewController
{
    // UIViews /////////////////////////////////////////////////////////////
    let headsetImage: UIImageView =
    {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "headphones")
        image.tintColor = .black
        image.contentMode = .scaleAspectFit
        
        return image
    }()
    
    let headsetLabel: UILabel =
    {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 30)
        label.text = "Use headphones para uma melhor experiência"
        
        return label
    }()
    
    // Views ////////////////////////////////////////////////////////////////
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.addSubview(self.headsetImage)
        self.view.addSubview(self.headsetLabel)
        self.firstConstraints()
        self.bottomConstraints(actualObj: headsetLabel, topObj: headsetImage.bottomAnchor, bottomCons: -300, leadingCons: 20, trailingCons: -20)
    }
    
    // Constraints //////////////////////////////////////////////////////
    private func firstConstraints()
    {
        NSLayoutConstraint.activate([
            self.headsetImage.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            self.headsetImage.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor, constant: -150),
            self.headsetImage.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, constant: -450),
            self.headsetImage.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, constant: -150)
        ])
    }
    
    private func bottomConstraints<T>(actualObj: T, topObj: NSLayoutYAxisAnchor, bottomCons: CGFloat, leadingCons: CGFloat, trailingCons: CGFloat) where T: UIView
    {
        NSLayoutConstraint.activate([
            actualObj.topAnchor.constraint(equalTo: topObj),
            actualObj.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: bottomCons),
            actualObj.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: leadingCons),
            actualObj.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: trailingCons)
        ])
    }


}
