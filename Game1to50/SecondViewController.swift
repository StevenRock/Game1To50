//
//  SecondViewController.swift
//  Game1to50
//
//  Created by Steven Lin on 2020/5/19.
//  Copyright © 2020 xiaoping. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var coreDataArray = [Rank]()
    var easyArray = [Rank]()
    var mediumArray = [Rank]()
    var hardArray = [Rank]()
    var masterArray = [Rank]()
    var showArray = [Rank]()

    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var rankTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        prepareArray()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        segControl.selectedSegmentIndex = 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RankTableViewCell

        showArray.sort(by: { $0.time < $1.time })

        cell.orderLabel.text = "\(indexPath.row + 1)"
        cell.dateLabel.text = showArray[indexPath.row].date
        cell.nameLabel.text = showArray[indexPath.row].name
        cell.timeLabel.text = String(format: "%02d: %02d: %02d",
                                     (showArray[indexPath.row].time / 100 / 60) % 60,
                                     (showArray[indexPath.row].time / 100) % 60,
                                     showArray[indexPath.row].time % 100)
        
        return cell

    }
    
    func prepareArray(){
        coreDataArray = UserRankManager.shared.fetchAll() ?? []
        
        masterArray = coreDataArray.filter({ $0.level == "MASTER"})
        hardArray = coreDataArray.filter({ $0.level == "HARD"})
        mediumArray = coreDataArray.filter({ $0.level == "MEDIUM"})
        easyArray = coreDataArray.filter({ $0.level == "EASY"})
        
        showArray = masterArray
        
        rankTable.reloadData()
        print("showArray: \(showArray)")
        print(coreDataArray)
    }
    
    @IBAction func segmentControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("MASTER")
            showArray = masterArray
        case 1:
            print("HARD")
            showArray = hardArray
        case 2:
            print("MEDIUM")
            showArray = mediumArray
        case 3:
            print("EASY")
            showArray = easyArray
        default:
            break
        }
        rankTable.reloadData()
    }
}

