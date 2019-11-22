//
//  ViewController.swift
//  Project1
//
//  Created by Laurent Delorme on 10/08/2019.
//  Copyright © 2019 Laurent Delorme. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var pictures:[String] = []
    var counters = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(recoTapped))
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
                counters.append(0)
            }
        }
        
        pictures = pictures.sorted()
        
        let defaults = UserDefaults.standard
        if let savedData = defaults.object(forKey: "counters") as? Data {
            if let decodedData = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as? [Int] {
                counters = decodedData
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        cell.detailTextLabel?.text = "Viewed \(counters[indexPath.row]) times"
        cell.detailTextLabel?.textColor = .gray
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            vc.pictureIndex = indexPath.row + 1
            counters[indexPath.row] += 1
            save()
            navigationController?.pushViewController(vc, animated: true)
            tableView.reloadData()
        }
    }
    
    @objc func recoTapped() {
        let message = "You should try this app!"
        let vc = UIActivityViewController(activityItems: [message], applicationActivities: [])
        present(vc, animated: true)
    }
    
    func save() {
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: pictures, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "counters")
        }
    }
    
    
    
}

