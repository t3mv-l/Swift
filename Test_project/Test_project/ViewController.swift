//
//  ViewController.swift
//  Test_project
//
//  Created by Артём on 15.11.2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var labelOutlet: UILabel!
    @IBOutlet weak var labelOutlet2: UILabel!
    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var buttonOutlet: UIButton!
    @IBOutlet weak var viewControllerOutlet: UIActivityIndicatorView!
    
    @IBAction func buttonAction(_ sender: Any) {
        buttonOutlet.isHidden = true
        viewControllerOutlet.startAnimating()
        labelOutlet.text = "ЧТООООООООООО"
        labelOutlet2.text = "КАК ТЫ ЭТО СДЕЛАЛ"
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.viewControllerOutlet.stopAnimating()
            self.imageOutlet.image = UIImage(named: "mem.png")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }


}

