//
//  LoadingViewController.swift
//  ServersList
//
//  Created by Tomas Stasiulionis on 23/10/2017.
//  Copyright © 2017 Tomas Stasiulionis. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    
    @IBOutlet weak var loadingImageView: UIImageView!
    @IBOutlet weak var loadingTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.rotateLoadingImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setLoadingText(loadingText: String){
        self.loadingTextLabel.text = loadingText
    }
    
    func rotateLoadingImage(){
        UIView.animate(withDuration: 2.0, delay: 0.0, options: .curveLinear, animations: {
            self.loadingImageView.transform = self.loadingImageView.transform.rotated(by: CGFloat(Double.pi
            ))
        }) { finished in
            self.rotateLoadingImage()
        }
    }
}
