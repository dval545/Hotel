//
//  RegistrationTableViewController.swift
//  Hotel
//
//  Created by Admin1 on 6/9/20.
//  Copyright © 2020 Admin1. All rights reserved.
//

import UIKit


class RegistrationTableViewController: UITableViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Model
    var reservations: [Reservation] = []
    
    // MARK: - Table view data source

    @IBAction func unwindFromAddReservation(segue: UIStoryboardSegue){
        guard let addReservationTableViewController = segue.source as?
            AddReservationTableViewController,
            let reservation = addReservationTableViewController.reservation else { return }
        reservations.append(reservation)
        tableView.reloadData()
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return reservations.count
        } else {
            return 0
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegistrationCell", for: indexPath)
        cell.textLabel?.text = "\(reservations[indexPath.row].guestName) \(reservations[indexPath.row].guestLastName)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        cell.detailTextLabel?.text = "\(dateFormatter.string(from: reservations[indexPath.row].checkIn)) \(dateFormatter.string(from: reservations[indexPath.row].checkOut)) \(reservations[indexPath.row].roomChoice.name)"
        
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "reservation" {
            let indexPath = tableView.indexPathForSelectedRow!
            let res = reservations[indexPath.row]
            let navController = segue.destination as!
            UINavigationController
            let addReservationController = navController.topViewController as!
            AddReservationTableViewController
            
            addReservationController.reservationFromRegistrationTable = res
        }
    }
    

}
