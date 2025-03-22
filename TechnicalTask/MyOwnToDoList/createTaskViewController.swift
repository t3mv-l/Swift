//
//  createTaskViewController.swift
//  MyOwnToDoList
//
//  Created by Артём on 22.03.2025.
//

import UIKit

class createTaskViewController: UIViewController {

    @IBOutlet weak var createTaskTextView: UITextView!
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        createTaskTextView.backgroundColor = .black
        createTaskTextView.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        createTaskTextView.textColor = .white
        self.overrideUserInterfaceStyle = .dark
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        createTaskTextView.becomeFirstResponder()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
