//
//  ServersListViewController.swift
//  PartySwift
//
//  Created by Arturas Kuciauskas on 24.11.2019.
//  Copyright © 2019 Party. All rights reserved.
//

import UIKit

class ServersListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{

    enum SortingType
    {
        case byAlphanumerical
        case byDistance
    }
    
    var servers: [Server] = []
    
    let logoImageView: UIImageView =
    {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "logo-dark")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let headerView: UIView =
    {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()

    
    let backgroundView: UIView =
    {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        
        return view
    }()
    
    let logoutButton: UIButton =
    {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.setImage(UIImage(named:"ico-logout"), for: .normal)
        button.addTarget(self, action: #selector(didTapLogout(sender:)), for: .touchUpInside)
        button.layer.cornerRadius = 5.0
        button.setTitle("Log In", for: .normal)

        return button
    }()
    
    let nameLabel: UILabel =
    {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.clear
        label.text = "SERVER"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.init(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1.0)
    
        return label
    }()
    
    let distanceLabel: UILabel =
    {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.clear
        label.text = "DISTANCE"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.init(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1.0)
    
        return label
    }()
    
    
    let serversCollectionView: UICollectionView =
    {
        let layout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(ServerCell.self, forCellWithReuseIdentifier: "cell")
      
        return collectionView
    }()
    
    let sortingButton: UIButton =
    {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.init(red: 64.0/255.0, green: 67.0/255.0, blue: 98.0/255.0, alpha: 1.0)
        button.setImage(UIImage(named:"ico-sort-light"), for: .normal)
        
        button.addTarget(self, action: #selector(didTapSort(sender:)), for: .touchUpInside)
        button.setTitle("  Sort", for: .normal)

        return button
    }()
    

    // MARK: - View
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(self.logoImageView)
        self.view.addSubview(self.logoutButton)
        self.view.addSubview(self.sortingButton)
        self.view.addSubview(self.headerView)
        self.headerView.addSubview(self.nameLabel)
        self.headerView.addSubview(self.distanceLabel)
        
        self.view.addSubview(self.serversCollectionView)
        self.serversCollectionView.delegate = self
        self.serversCollectionView.dataSource = self

        self.view.layerGradient()
        
        self.configConstraints()
    }
    
    func configConstraints()
    {
       NSLayoutConstraint.activate([
         
        self.headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 60.0),
        self.headerView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0.0),
        self.headerView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0.0),
        self.headerView.heightAnchor.constraint(equalToConstant: 35.0),
        
        self.nameLabel.centerYAnchor.constraint(equalTo: self.headerView.centerYAnchor, constant: 0.0),
        self.nameLabel.leftAnchor.constraint(equalTo: self.headerView.leftAnchor, constant: 15.0),
        self.nameLabel.heightAnchor.constraint(equalToConstant: 15.0),
        
        self.distanceLabel.centerYAnchor.constraint(equalTo: self.headerView.centerYAnchor, constant: 0.0),
        self.distanceLabel.leftAnchor.constraint(equalTo: self.headerView.rightAnchor, constant: -90.0),
        self.distanceLabel.heightAnchor.constraint(equalToConstant: 15.0),
        
        self.logoImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 23.0),
        self.logoImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15.0),
        self.logoImageView.widthAnchor.constraint(equalToConstant: 65.0),
        self.logoImageView.heightAnchor.constraint(equalToConstant: 17.0),

        self.logoutButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 23.0),
        self.logoutButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15.0),
        self.logoutButton.widthAnchor.constraint(equalToConstant: 25.0),
        self.logoutButton.heightAnchor.constraint(equalToConstant: 25.0),
        
        self.sortingButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0),
        self.sortingButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0.0),
        self.sortingButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0.0),
        self.sortingButton.heightAnchor.constraint(equalToConstant: 45.0),
        
        self.serversCollectionView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: 0.0),
        self.serversCollectionView.bottomAnchor.constraint(equalTo: self.sortingButton.topAnchor, constant: 0.0),
        self.serversCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0.0),
        self.serversCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0.0),
       ])
    }
    
    // MARK: - Actions
    
    @objc func didTapLogout(sender: UIButton)
    {
        UIView.animate(withDuration: 0.1, animations: {
            self.logoutButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { (_) in
            UIView.animate(withDuration: 0.1, animations: {
                self.logoutButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }) { (_) in
                self.logout()
            }
        }
        
    }
    
    @objc func didTapSort(sender: UIButton)
    {
        UIView.animate(withDuration: 0.1, animations: {
            self.sortingButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { (_) in
            UIView.animate(withDuration: 0.1, animations: {
                self.sortingButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }) { (_) in
                self.showActionSheet()
            }
        }
        
    }
    
    func logout()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showActionSheet()
    {
       
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let firstAction: UIAlertAction = UIAlertAction(title: "By Distance", style: .default) { action -> Void in

            self.sort(by: .byDistance)
        }

        let secondAction: UIAlertAction = UIAlertAction(title: "Alphanumerical", style: .default) { action -> Void in

            self.sort(by: .byAlphanumerical)
        }

        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }

        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(secondAction)
        actionSheetController.addAction(cancelAction)
        
        actionSheetController.popoverPresentationController?.sourceView = self.view

        present(actionSheetController, animated: true)
    }
    
    func sort(by sortingType: SortingType)
    {
        switch sortingType
        {
            case .byAlphanumerical:
                self.servers = self.servers.sorted(by: { $0.name < $1.name })
            case .byDistance:
                self.servers = self.servers.sorted(by: { $0.distance < $1.distance })
        }
 
        self.serversCollectionView.reloadData()
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation)
    {
         self.view.layerGradient()
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval)
    {
         self.serversCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    
// MARK: - UICollectionView Delegate Datasource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.servers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! ServerCell
        let serverObject: Server = self.servers[indexPath.row]
        cell.serverObject = serverObject
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: self.view.frame.size.width, height: 40)
    }

}


extension UIView {
    func layerGradient() {
        let layer : CAGradientLayer = CAGradientLayer()
        var size = self.frame.size
        size.height = 200
        layer.frame.size = size
        layer.frame.origin = CGPoint(x: 0, y: 0)

        let color0 = UIColor(red:235.0/255.0, green:235.0/255.0, blue:235.0/255.0, alpha:1.0).cgColor
        let color1 = UIColor.white.cgColor
       
        layer.startPoint = CGPoint(x: 0.0, y: 0.0)
        layer.endPoint = CGPoint(x: 0.0, y: 1.0)

        layer.colors = [color0,color1]
        self.layer.insertSublayer(layer, at: 0)
    }
}
