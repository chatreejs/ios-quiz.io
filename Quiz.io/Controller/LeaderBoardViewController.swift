//
//  LeaderBoardViewController.swift
//  Quiz.io
//
//  Created by AnonyMac on 29/4/2561 BE.
//  Copyright © 2561 Chanon Treemeth. All rights reserved.
//

import UIKit
import Firebase

class LeaderBoardViewController: UIViewController {
    
    @IBOutlet weak var nameLabel1: UILabel!
    @IBOutlet weak var nameLabel2: UILabel!
    @IBOutlet weak var nameLabel3: UILabel!
    @IBOutlet weak var nameLabel4: UILabel!
    @IBOutlet weak var nameLabel5: UILabel!
    @IBOutlet weak var scoreLabel1: UILabel!
    @IBOutlet weak var scoreLabel2: UILabel!
    @IBOutlet weak var scoreLabel3: UILabel!
    @IBOutlet weak var scoreLabel4: UILabel!
    @IBOutlet weak var scoreLabel5: UILabel!
    
    var username: String!
    var uid: String!
    var highScore: Int!
    var ref: DatabaseReference?
    var handle: DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference().child("Leaderboard")
        handle = ref?.queryOrdered(byChild: "score").queryLimited(toFirst: 5).observe(.value, with: { snapshot in
            var scoresArray = [Int]()
            var usernameArray = [String]()
            
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let score = snap.childSnapshot(forPath: "score")
                let name = snap.childSnapshot(forPath: "username")
                scoresArray.append(score.value as! Int)
                usernameArray.append(name.value as! String)
            }

            //Set Leaderboard view
            self.nameLabel1.text = usernameArray[0]
            self.scoreLabel1.text = String(scoresArray[0] * -1)
            self.nameLabel2.text = usernameArray[1]
            self.scoreLabel2.text = String(scoresArray[1] * -1)
            self.nameLabel3.text = usernameArray[2]
            self.scoreLabel3.text = String(scoresArray[2] * -1)
            self.nameLabel4.text = usernameArray[3]
            self.scoreLabel4.text = String(scoresArray[3] * -1)
            self.nameLabel5.text = usernameArray[4]
            self.scoreLabel5.text = String(scoresArray[4] * -1)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func restartQuiz(_ sender: UIButton) {
        performSegue(withIdentifier: "restartQuiz", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ViewController {
            destination.highScore = highScore
            destination.username = username
            destination.uid = uid
        }
    }
}
