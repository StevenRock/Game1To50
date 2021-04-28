//
//  FirstViewController.swift
//  Game1to50
//
//  Created by Steven Lin on 2020/5/19.
//  Copyright © 2020 xiaoping. All rights reserved.
//

import UIKit
import SCLAlertView

class FirstViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource {

//    MARK: - PROPERTIES
    @IBOutlet weak var gameCollectionView: UICollectionView!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    @IBOutlet weak var wrongLabel: UILabel!
    @IBOutlet weak var difficultyTextField: UITextField!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var showDiffLabel: UILabel!
    @IBOutlet weak var btnAbort: UIButton!
    @IBOutlet weak var bgView: UIView!
    
    var picker = UIPickerView()
    private var timer: Timer? = .init()
    private var elapseTimeInSecond: Int = 0
    
    var maxNum = 50
    var itemCount = 25 //16 9 4
    var valueArray:[Int] = []
    var backUpArray:[Int] = []
    var rightNowNum = 1
    var choice: DifficultyInfo?
    var gameInfo: GameInfo?
    var userData: Userdata?
    var difficultyArray = ["EASY","MEDIUM","HARD","MASTER"]
    
    var gameTime:Int = 0
    var gameLevel: String = ""
    var gameDate:String = ""
    var gameUser:String = ""
    
//   MARK: - LIFE CIRCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.dataSource = self
        gameCollectionView.dataSource = self
        gameCollectionView.delegate = self
                        
        bgView.backgroundColor = .gray
        timerLabel.isHidden = true
        showDiffLabel.isHidden = true
        countDownLabel.text = "1to50"
        difficultyTextField.inputView = picker
        
        valueArray = Array(1...25).shuffled()
        backUpArray = Array(26...50)
        wrongLabel.isHidden = true
                
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
        
        print("ValueArray: \(valueArray)\nbackUpArray:\(backUpArray)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer?.invalidate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setCollectionView(size: 5, padding: 40)
        keepRandom()
    }
//MARK: - COLLECTIONVIEW
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCell", for: indexPath) as! GameCollectionViewCell
        if valueArray[indexPath.row] == 0 {
            cell.numLabel.text = ""
            cell.backgroundColor = .clear
            cell.isUserInteractionEnabled = false
        }else{
            cell.backgroundColor = .orange
            cell.numLabel.text = "\(valueArray[indexPath.row])"
            cell.isUserInteractionEnabled = true
        }
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("Tapped!: you tapped \(indexPath.row + 1) item")

        if String(valueArray[indexPath.row]) != String(rightNowNum){
            print("Wrong!")
            wrongLabel.isHidden = false
        }else{
            if backUpArray.count == 0 {
                valueArray[indexPath.row] = 0
            }else{
                valueArray[indexPath.row] = backUpArray[0]
                backUpArray.remove(at: 0)
            }
            gameCollectionView.reloadData()
            print("ValueArray: \(valueArray)\nbackUpArray:\(backUpArray)")
            rightNowNum += 1
            wrongLabel.isHidden = true
        }
        
        let isPass = valueArray.allSatisfy { (value) -> Bool in
            value == 0
        }
        if isPass{
            timer?.invalidate()
            gameTime = elapseTimeInSecond
            countDownLabel.text = "Clear!"
            blurView.isHidden = false
            difficultyTextField.isHidden = false
            btnStart.isHidden = false
            addAlert()
        }
    }
    
    func setCollectionView(size: CGFloat, padding: CGFloat){
        let padding: CGFloat = padding
        let width = gameCollectionView.frame.size.width - padding
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: width/size, height: width/size)
    }
//    MARK: - PICKERVIEW
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return difficultyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        difficultyTextField.text = difficultyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return difficultyArray[row]
    }
    
//MARK: - ACTION
    
    @IBAction func gameStart(_ sender: Any) {
        self.view.endEditing(false)
        timer?.invalidate()

        var str = difficultyTextField.text
        if str == ""{
            str = "MASTER"
        }
        gameLevel = str!
        elapseTimeInSecond = 0
        showDiffLabel.text = "Difficulty: \(str ?? "MASTER")"
        showDiffLabel.sizeToFit()
        showDiffLabel.isHidden = false
        let padding:CGFloat = CGFloat(setDifficultyUI(str: str!))
        
        gameDate = getTimeStamp()
        difficultyTextField.isHidden = true
        btnStart.isHidden = true
        rightNowNum = 1
        valueArray = Array(1...itemCount).shuffled()
        backUpArray = Array(itemCount+1 ... maxNum)
        let num = sqrt(Double(itemCount))
        setCollectionView(size: CGFloat(num), padding: padding)
        gameCollectionView.reloadData()
        countDown()
    }
    
    @IBAction func abort(_ sender: Any) {
        timer?.invalidate()
        timerLabel.isHidden = true
        showDiffLabel.isHidden = true
        wrongLabel.isHidden = true
        blurView.isHidden = false
        difficultyTextField.isHidden = false
        btnStart.isHidden = false
        countDownLabel.text = "1to50"
        changeBg(red: 134, green: 134, blue: 139)

        keepRandom()
    }
    
    @objc func closeKeyboard(){
        self.view.endEditing(true)
    }
    
    func keepRandom() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (_) in
            self.valueArray = Array(1...25).shuffled()
            self.backUpArray = Array(26...50)
            self.gameCollectionView.reloadData()
        })
    }
    
    func setDifficultyUI(str: String) -> Int{
        switch str {
            case "EASY":
                itemCount = DifficultyInfo.Easy.itemCount
                changeBg(red: 94, green: 255, blue: 211)
                return 10
            case "MEDIUM":
                itemCount = DifficultyInfo.Medium.itemCount
                changeBg(red: 142, green: 255, blue: 109)
                return 20
            case "HARD":
                itemCount = DifficultyInfo.Hard.itemCount
                changeBg(red: 255, green: 239, blue: 93)
                return 30
            case "MASTER":
                itemCount = DifficultyInfo.Master.itemCount
                changeBg(red: 213, green: 127, blue: 255)
                return 40
            default:
                break
        }
        return 0
    }
//    MARK: - TIMER RELATED
    func startTimer(){
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (timer) in
            self.elapseTimeInSecond += 1
            
            self.timerLabel.text = self.updateTimeLabel()
            self.timerLabel.sizeToFit()
        })
    }
    
    func resetTimer() {
        timer?.invalidate()
        elapseTimeInSecond = 0
        timerLabel.text = self.updateTimeLabel()
        timerLabel.sizeToFit()
    }
    
    func updateTimeLabel() -> String{
        let millisecond = elapseTimeInSecond % 100
        let seconds = (elapseTimeInSecond / 100) % 60
        let minutes = (elapseTimeInSecond / 100 / 60) % 60
        
        return String(format: "%02d: %02d: %02d", minutes, seconds, millisecond)
    }
    
    func countDown() {
        var countDown = 3
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (_) in
            if countDown > 0{
                self.countDownLabel.text = String(countDown)
                countDown -= 1
            }else if countDown == 0{
                self.countDownLabel.text = "GO!"
                countDown -= 1
            }else{
                self.blurView.isHidden = true
                self.timer?.invalidate()
                self.timerLabel.isHidden = false
                self.startTimer()
            }
        })
    }
    func getTimeStamp() -> String{
        let now = Date()
        let dFormatter = DateFormatter()
        
        dFormatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
        let strTime = dFormatter.string(from: now)
        
        return strTime
    }
//    MARK: - UI
    func changeBg(red: CGFloat, green: CGFloat, blue: CGFloat){
        
        let color = UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)

        UIView.animate(withDuration: 1) {
            self.bgView.backgroundColor = color
            self.bgView.backgroundColor?.index(ofAccessibilityElement: 0)
        }
    }
    
    func addAlert(){
        let alert = SCLAlertView()
        let textField = alert.addTextField("NAME")
        
        alert.addButton("SUBMIT!") {
            
            if textField.text == "" {
                self.gameUser = "USER"
            }else{
                self.gameUser = textField.text!
            }
            print("USER: \(self.gameUser)\nDATE: \(self.gameDate)\nTIME: \(self.gameTime)\nLEVEL: \(self.gameLevel)")
            self.transToCore(name: self.gameUser,
                             time: self.gameTime,
                             date: self.gameDate,
                             level: self.gameLevel)
        }
        alert.showEdit("CONGRATULATIONS!", subTitle: "Time: \(updateTimeLabel())", closeButtonTitle: "CANCEL")
    }
    
    func transToCore(name: String, time: Int, date: String, level: String){
        UserRankManager.shared.add(name: name, time: time, date: date, level: level)
    }
    
}




