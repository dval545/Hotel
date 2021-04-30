//
//  SelectRoomTableViewController.swift
//  Hotel
//
//  Created by Admin1 on 3/9/20.
//  Copyright © 2020 Admin1. All rights reserved.
//

import UIKit

protocol SelectRoomTableViewControllerDelegate{
    func didSelect(room: Room)
}

class SelectRoomTableViewController: UITableViewController {
    
    var delegate: SelectRoomTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Model
    var room: Room?
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return Room.allRooms.count
        } else{
            return 0
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomTypeCell", for: indexPath)
        cell.textLabel?.text = Room.allRooms[indexPath.row].name
        cell.detailTextLabel?.text = "$ \(Room.allRooms[indexPath.row].price)"
        
        if Room.allRooms[indexPath.row] == room {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        room = Room.allRooms[indexPath.row]
        delegate?.didSelect(room: room!)
        tableView.reloadData()
    }
    


}
