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
    let navBarAppearance = UINavigationBarAppearance()
    
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
    
    let credits: UILabel =
    {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        label.text = "Sons por: Eryc Matias \nwww.soundimage.org"
        
        return label
    }()
    
    let prosseguirBtn: UIButton =
    {
        let button = UIButton(type: .system)
        let titleBold = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 23)]
        let titleString = NSMutableAttributedString(string: "Prosseguir", attributes: titleBold)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(titleString, for: .normal)
        button.configuration = .filled()
        button.addTarget(self, action: #selector(prosseguirAction), for: .touchUpInside)
        
        return button
    }()
    
    // Views ////////////////////////////////////////////////////////////////
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.addSubview(self.headsetImage)
        self.view.addSubview(self.headsetLabel)
        self.view.addSubview(self.prosseguirBtn)
        self.view.addSubview(self.credits)
        
        self.firstConstraints()
        self.bottomConstraints(actualObj: headsetLabel, topObj: headsetImage.bottomAnchor, topCons: 0, bottomCons: -300, leadingCons: 20, trailingCons: -20)
        self.bottomConstraints(actualObj: prosseguirBtn, topObj: headsetLabel.bottomAnchor, topCons: 220, bottomCons: -30, leadingCons: 20, trailingCons: -20)
        self.creditsConstraints()
    }
    
    // Button Actions /////////////////////////////////////////////////////
    @objc func prosseguirAction()
    {
        navBarAppearance.backgroundColor = UIColor.systemGray6
        
        self.navigationController?.navigationBar.standardAppearance = navBarAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        self.navigationController?.navigationBar.compactAppearance = navBarAppearance
        
        let hvc = HomeViewController("Mute")

        navigationController?.setViewControllers([hvc], animated: true)

        
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
    
    private func bottomConstraints(actualObj: UIView, topObj: NSLayoutYAxisAnchor, topCons: CGFloat, bottomCons: CGFloat, leadingCons: CGFloat, trailingCons: CGFloat)
    {
        NSLayoutConstraint.activate([
            actualObj.topAnchor.constraint(equalTo: topObj, constant: topCons),
            actualObj.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: bottomCons),
            actualObj.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: leadingCons),
            actualObj.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: trailingCons)
        ])
    }
    
    private func creditsConstraints()
    {
        NSLayoutConstraint.activate([
            self.credits.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.credits.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -330),
            self.credits.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -50),
            self.credits.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -100)
        ])
    }


}
