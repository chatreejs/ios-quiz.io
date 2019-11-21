//
//  UserViewController.swift
//  Quiz.io
//
//  Created by AnonyMac on 28/4/2561 BE.
//  Copyright © 2561 Chanon Treemeth. All rights reserved.
//

import UIKit
import Firebase

class UserViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var playButton: UIButton!
    
    var ref: DatabaseReference!
    var uid: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        playButton.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        playButton.layer.shadowOpacity = 1.0
        playButton.layer.shadowRadius = 0.0
        playButton.layer.masksToBounds = false
        playButton.layer.cornerRadius = 0
        nameTextField.delegate = self
        configTapGesture()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Check internet connection
        if Reachability.isConnectedToNetwork() {
            
        } else {
            let alert = UIAlertController(title: "Connection Error", message: "กรุณาเชื่อมต่ออินเทอร์เน็ต", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ตกลง", style: .cancel, handler: { (action: UIAlertAction!) in
                exit(0)
            }))
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func play(_ sender: UIButton) {
        view.endEditing(true)
        
        //Check not nil
        if nameTextField.text?.isEmpty ?? true {
            let alert = UIAlertController(title: "กรุณาป้อนชื่อ", message: "กรุณาป้อนชื่อก่อนเข้าเล่นเกมส์", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ตกลง", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        } else {
            ref = Database.database().reference()
            let score = 0
            if let username = nameTextField.text {
                uid = self.ref.child("Leaderboard").childByAutoId().key
                let userObj = ["username": username,
                               "score": score] as [String : Any]
                self.ref.child("Leaderboard").child(uid).setValue(userObj)
            }
            performSegue(withIdentifier: "playQuiz", sender: self)
        }
    }
    
    private func configTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UserViewController.handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ViewController {
            destination.username = nameTextField.text
            destination.uid = uid
        }
    }
}

extension UserViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return true
    }
}
