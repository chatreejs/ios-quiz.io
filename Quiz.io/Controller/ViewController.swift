//
//  ViewController.swift
//  Quiz.io
//
//  Created by AnonyMac on 24/4/2561 BE.
//  Copyright © 2561 Chanon Treemeth. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var questionCounter: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var answerCheckLabel: UILabel!
    @IBOutlet weak var addPoint: UILabel!
    
    //Outlet for buttons
    @IBOutlet weak var optionA: UIButton!
    @IBOutlet weak var optionB: UIButton!
    @IBOutlet weak var optionC: UIButton!
    @IBOutlet weak var optionD: UIButton!
    
    let allQuestion = QuestionBank()
    let numQuestion = 10
    var questionList: [Int] = []
    var shuffle = [Int]()
    var buttonsPressed: [UIButton] = []
    
    var questionNumber: Int = 0
    var score: Int = 0
    var highScore: Int = 0
    var pointToAdd: Int = 0
    var selectedAnswer: Int = 0
    var correctStreak: Int = 0
    var seconds: Int = 10
    var username: String!
    var uid: String!
    
    var timer = Timer()
    var isTimerRunning = false
    var correctSound: AVAudioPlayer?
    var wrongSound: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let path = Bundle.main.path(forResource: "correct.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        let path2 = Bundle.main.path(forResource: "Ba Dum Tss.mp3", ofType:nil)!
        let url2 = URL(fileURLWithPath: path2)
        
        do {
            correctSound = try AVAudioPlayer(contentsOf: url)
            wrongSound = try AVAudioPlayer(contentsOf: url2)
        } catch {
            //couldn't load file
        }
        
        //init quetionList
        for i in 0..<allQuestion.list.count {
            questionList.append(i)
        }
        buttonShadow()
        shuffleQuestion()
        updateQuestion()
        updateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    let notification = UINotificationFeedbackGenerator()
    let impact = UIImpactFeedbackGenerator(style: .medium)
    
    @IBAction func answerPressed(_ sender: UIButton) {
        //Correct
        if sender.tag == selectedAnswer {
            correctSound?.play()
            impact.impactOccurred()
            timer.invalidate()
            disableButton()
            switch selectedAnswer {
            case 1:
                UIView.animate(withDuration: 0.25, animations: {
                    self.optionA.backgroundColor = UIColor(red:0.61, green:1.00, blue:0.60, alpha:1.0)
                }, completion: nil)
            case 2:
                UIView.animate(withDuration: 0.25, animations: {
                    self.optionB.backgroundColor = UIColor(red:0.61, green:1.00, blue:0.60, alpha:1.0)
                }, completion: nil)
            case 3:
                UIView.animate(withDuration: 0.25, animations: {
                    self.optionC.backgroundColor = UIColor(red:0.61, green:1.00, blue:0.60, alpha:1.0)
                }, completion: nil)
            case 4:
                UIView.animate(withDuration: 0.25, animations: {
                    self.optionD.backgroundColor = UIColor(red:0.61, green:1.00, blue:0.60, alpha:1.0)
                }, completion: nil)
            default:
                print("")
            }
            
            correctStreak += 1
            let streakScore = (pow(2, correctStreak) as NSDecimalNumber).intValue
            pointToAdd = 800 + (seconds * 20) + streakScore
            score += pointToAdd
            
            //Show answer view
            answerView.isHidden = !answerView.isHidden
            questionCounter.isHidden = !questionCounter.isHidden
            scoreLabel.isHidden = !scoreLabel.isHidden
            progressView.isHidden = !progressView.isHidden
            headerView.backgroundColor = UIColor(red:0.47, green:0.89, blue:0.40, alpha:1.0)
            answerCheckLabel.text = "ถูกต้อง"
            addPoint.text = "+\(pointToAdd)"
        //Wrong
        } else {
            //Haptic feedback to user
            wrongSound?.play()
            notification.notificationOccurred(.warning)
            timer.invalidate()
            disableButton()
            
            //Show correct answer
            switch selectedAnswer {
            case 1:
                UIView.animate(withDuration: 0.25, animations: {
                    self.optionA.backgroundColor = UIColor(red:0.61, green:1.00, blue:0.60, alpha:1.0)
                }, completion: nil)
            case 2:
                UIView.animate(withDuration: 0.25, animations: {
                    self.optionB.backgroundColor = UIColor(red:0.61, green:1.00, blue:0.60, alpha:1.0)
                }, completion: nil)
            case 3:
                UIView.animate(withDuration: 0.25, animations: {
                    self.optionC.backgroundColor = UIColor(red:0.61, green:1.00, blue:0.60, alpha:1.0)
                }, completion: nil)
            case 4:
                UIView.animate(withDuration: 0.25, animations: {
                    self.optionD.backgroundColor = UIColor(red:0.61, green:1.00, blue:0.60, alpha:1.0)
                }, completion: nil)
            default:
                print("")
            }

            //Show answer that user selected
            let userSelected = sender.tag
            switch userSelected {
            case 1:
                UIView.animate(withDuration: 0.25, animations: {
                    self.optionA.backgroundColor = UIColor(red:1.00, green:0.29, blue:0.38, alpha:1.0)
                }, completion: nil)
            case 2:
                UIView.animate(withDuration: 0.25, animations: {
                    self.optionB.backgroundColor = UIColor(red:1.00, green:0.29, blue:0.38, alpha:1.0)
                }, completion: nil)
            case 3:
                UIView.animate(withDuration: 0.25, animations: {
                    self.optionC.backgroundColor = UIColor(red:1.00, green:0.29, blue:0.38, alpha:1.0)
                }, completion: nil)
            case 4:
                UIView.animate(withDuration: 0.25, animations: {
                    self.optionD.backgroundColor = UIColor(red:1.00, green:0.29, blue:0.38, alpha:1.0)
                }, completion: nil)
            default:
                print("")
            }
            //Show answer view
            answerView.isHidden = !answerView.isHidden
            questionCounter.isHidden = !questionCounter.isHidden
            scoreLabel.isHidden = !scoreLabel.isHidden
            progressView.isHidden = !progressView.isHidden
            headerView.backgroundColor = UIColor(red:1.00, green:0.29, blue:0.38, alpha:1.0)
            answerCheckLabel.text = "ผิด"
            if correctStreak >= 4 {
                addPoint.text = "ไม่น่าพลาดเลย"
            } else if correctStreak >= 1 {
                addPoint.text = "เกือบดีแล้ว"
            } else {
                addPoint.text = "ลองใหม่ข้อต่อไปละกัน"
            }
            
            correctStreak = 0
        }
        
        //Delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.optionA.backgroundColor = UIColor(red:0.86, green:0.95, blue:1.00, alpha:1.0)
            self.optionB.backgroundColor = UIColor(red:0.86, green:0.95, blue:1.00, alpha:1.0)
            self.optionC.backgroundColor = UIColor(red:0.86, green:0.95, blue:1.00, alpha:1.0)
            self.optionD.backgroundColor = UIColor(red:0.86, green:0.95, blue:1.00, alpha:1.0)
            self.questionNumber += 1
            self.updateQuestion()
        }
    }
    
    func updateQuestion() {
        answerView.isHidden = true
        questionCounter.isHidden = false
        scoreLabel.isHidden = false
        progressView.isHidden = false
        headerView.backgroundColor = UIColor(red:0.33, green:1.00, blue:0.70, alpha:1.0)
        
        seconds = 10
        progressView.frame.size.width = view.frame.size.width
        
        //Load question from questionBank
        if questionNumber < shuffle.count {
            imgView.image = UIImage(named: (allQuestion.list[shuffle[questionNumber]].questionImage))
            questionLabel.text = allQuestion.list[shuffle[questionNumber]].question
            optionA.setTitle(allQuestion.list[shuffle[questionNumber]].optionA, for: UIControlState.normal)
            optionB.setTitle(allQuestion.list[shuffle[questionNumber]].optionB, for: UIControlState.normal)
            optionC.setTitle(allQuestion.list[shuffle[questionNumber]].optionC, for: UIControlState.normal)
            optionD.setTitle(allQuestion.list[shuffle[questionNumber]].optionD, for: UIControlState.normal)
            selectedAnswer = allQuestion.list[shuffle[questionNumber]].correctAnswer
        } else {
            performSegue(withIdentifier: "showScore", sender: self)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.timer.invalidate()
            }
        }
        runTimer()
        updateUI()
        enableButton()
    }
    
    func updateUI() {
        scoreLabel.text = "คะแนน: \(score)"
        if questionNumber <= (shuffle.count - 1) {
            questionCounter.text = "\(questionNumber + 1)/\(numQuestion)"
        } else {
            //Fix bug for last question
            questionCounter.text = "\(numQuestion)/\(numQuestion)"
        }
    }
    
    func disableButton(){
        optionA.isEnabled = false
        optionB.isEnabled = false
        optionC.isEnabled = false
        optionD.isEnabled = false
    }
    
    func enableButton(){
        optionA.isEnabled = true
        optionB.isEnabled = true
        optionC.isEnabled = true
        optionD.isEnabled = true
    }
    
    func shuffleQuestion() {
        for _ in 0..<numQuestion
        {
            let rand = Int(arc4random_uniform(UInt32(questionList.count)))
            shuffle.append(questionList[rand])
            questionList.remove(at: rand)
        }
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
        isTimerRunning = true
    }
    
    @objc func updateTimer() {
        seconds -= 1
        UIView.animate(withDuration: 0.2, animations: {
            self.progressView.frame.size.width -= CGFloat(self.view.frame.size.width / 10)
        }, completion: nil)
        
        if seconds == 0 {
            timer.invalidate()
            disableButton()
            seconds = 10
            notification.notificationOccurred(.warning)
            
            //Show answer view
            answerView.isHidden = !answerView.isHidden
            questionCounter.isHidden = !questionCounter.isHidden
            scoreLabel.isHidden = !scoreLabel.isHidden
            progressView.isHidden = !progressView.isHidden
            headerView.backgroundColor = UIColor(red:1.00, green:0.29, blue:0.38, alpha:1.0)
            answerCheckLabel.text = "หมดเวลา!"
            addPoint.text = "คุณมีเวลา 10 วินาทีนะ ตั้งใจหน่อย"
            correctStreak = 0
            
            //Delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.questionNumber += 1
                self.updateQuestion()
            }
        }
    }
    
    func buttonShadow() {
        optionA.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        optionA.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        optionA.layer.shadowOpacity = 1.0
        optionA.layer.shadowRadius = 0.0
        optionA.layer.masksToBounds = false
        optionA.layer.cornerRadius = 30
        optionB.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        optionB.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        optionB.layer.shadowOpacity = 1.0
        optionB.layer.shadowRadius = 0.0
        optionB.layer.masksToBounds = false
        optionB.layer.cornerRadius = 30
        optionC.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        optionC.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        optionC.layer.shadowOpacity = 1.0
        optionC.layer.shadowRadius = 0.0
        optionC.layer.masksToBounds = false
        optionC.layer.cornerRadius = 30
        optionD.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        optionD.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        optionD.layer.shadowOpacity = 1.0
        optionD.layer.shadowRadius = 0.0
        optionD.layer.masksToBounds = false
        optionD.layer.cornerRadius = 30
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ScoreViewController {
            destination.score = score
            destination.highScore = highScore
            destination.username = username
            destination.uid = uid
        }
    }
}

