//
//  TitleViewController.swift
//  mineGame
//
//  Created by masapp on 2018/04/16.
//  Copyright © 2018 masapp. All rights reserved.
//

import UIKit

class TitleViewController: UIViewController {
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        let title = UIImageView(frame: UIScreen.main.bounds)
        title.image = UIImage(named: "title")
        self.view.addSubview(title)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let gameVC = GameViewController()
        self.present(gameVC, animated: false, completion: nil)
    }
}
