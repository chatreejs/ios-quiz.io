//
//  ScoreViewController.swift
//  Quiz.io
//
//  Created by AnonyMac on 25/4/2561 BE.
//  Copyright © 2561 Chanon Treemeth. All rights reserved.
//

import UIKit
import Firebase

class ScoreViewController: UIViewController {
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var levelLabel: UILabel!
    
    var username: String!
    var uid: String!
    var score: Int!
    var highScore: Int!
    var scoreLevel: Int = 0
    var ref: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let scoreToDisplay = score {
            scoreLabel.text = String(scoreToDisplay)
            scoreLevel = score!
        }
        
        if scoreLevel <= 3000 {
            backgroundView.backgroundColor = UIColor(red:1.00, green:0.29, blue:0.38, alpha:1.0)
            levelLabel.text = "อ่อนมากลูก!"
        } else if scoreLevel <= 4500 {
            backgroundView.backgroundColor = UIColor(red:1.00, green:0.42, blue:0.26, alpha:1.0)
            levelLabel.text = "อ่อน!"
        } else if scoreLevel <= 10000 {
            backgroundView.backgroundColor = UIColor(red:0.82, green:1.00, blue:0.42, alpha:1.0)
            levelLabel.text = "ดีแล้ว!"
        } else if scoreLevel > 10000 {
            backgroundView.backgroundColor = UIColor(red:1.00, green:0.85, blue:0.23, alpha:1.0)
            levelLabel.text = "เก่งมากลูก!"
        }
        
        if score > highScore {
            highScore = score
            saveScoreToFirebase()
        }
        
        //Delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.performSegue(withIdentifier: "showLeaderBoard", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveScoreToFirebase() {
        ref = Database.database().reference()
        let userObj = ["username": username,
                       "score": -(score)] as [String : Any]
        if let id = uid {
            let childUpdate = ["/Leaderboard/\(id)": userObj]
            ref?.updateChildValues(childUpdate)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? LeaderBoardViewController {
            destination.highScore = highScore
            destination.username = username
            destination.uid = uid
        }
    }
    
}
