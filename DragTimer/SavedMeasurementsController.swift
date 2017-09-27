//
//  SavedMeasurementsController.swift
//  DragTimer
//
//  Created by Philipp Matthes on 26.09.17.
//  Copyright © 2017 Philipp Matthes. All rights reserved.
//

import Foundation
import UIKit

class SavedMeasurementsController: UITableViewController {
        
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    let gradientLayer = CAGradientLayer()
    var previousViewController = ViewController()
    var measurements = [Measurement]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpInterfaceDesign()
        
        self.tableView.separatorStyle = .none

        if let decoded = UserDefaults.standard.object(forKey: "measurements") as? NSData {
            let array = NSKeyedUnarchiver.unarchiveObject(with: decoded as Data) as! [Measurement]
            measurements = array
        }
        
        setUpBackground(frame: self.view.bounds)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return measurements.count
    }
    
    func setUpInterfaceDesign() {
        self.view.addSubview(navigationBar)
        let navigationItem = UINavigationItem(title: "Saved Times")
        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector (self.doneButtonPressed (_:)))
        let editItem = editButtonItem
        editItem.tintColor = Constants.designColor1
        doneItem.tintColor = Constants.designColor1
        navigationItem.rightBarButtonItem = doneItem
        navigationItem.leftBarButtonItem = editItem
        navigationBar.setItems([navigationItem], animated: false)
        
    }
    
    func setUpBackground(frame: CGRect) {
        gradientLayer.frame = frame
        gradientLayer.colors = [Constants.backgroundColor1.cgColor as CGColor, Constants.backgroundColor2.cgColor as CGColor]
        gradientLayer.locations = [0.0, 1.0]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MeasurementCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MeasurementCell else {
            fatalError("The dequeued cell is not an instance of MeasurementCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let measurement = measurements[indexPath.row]
        
        cell.timeLabel.text = String(describing: measurement.time!) + "s"
        cell.speedLabel.text = String(describing: measurement.lowSpeed!) + " to " + String(describing: measurement.highSpeed!) + " " + measurement.speedType!
        cell.dateLabel.text = measurement.date!
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            measurements.remove(at: indexPath.row)
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: measurements)
            UserDefaults.standard.set(encodedData, forKey: "measurements")
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        setUpInterfaceDesign()
    }
    
    @objc func doneButtonPressed(_ sender:UITapGestureRecognizer){
        performSegueToReturnBack()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func performSegueToReturnBack()  {
        previousViewController.startTimer()
        previousViewController.startSpeedometer()
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
}
