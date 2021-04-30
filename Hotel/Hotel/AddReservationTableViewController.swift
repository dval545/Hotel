//
//  AddReservationTableViewController.swift
//  Hotel
//
//  Created by Admin1 on 1/9/20.
//  Copyright © 2020 Admin1. All rights reserved.
//

import UIKit

class AddReservationTableViewController: UITableViewController, SelectRoomTableViewControllerDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let midNightToday = Calendar.current.startOfDay(for: Date())
        checkInDatePicker.minimumDate = midNightToday
        checkInDatePicker.date = midNightToday
        checkOutDatePicker.date = checkInDatePicker.date.addingTimeInterval(86400)
        checkOutDatePicker.minimumDate = checkInDatePicker.date.addingTimeInterval(86400)
        updateData()
        updateDateViews()
        updateNumberOfGuests()
        updateRoomType()
        doneBarButtonState()
        
    }
    
    
    // MARK: - Model:
    var room: Room?
    var reservationFromRegistrationTable: Reservation?
    var reservation: Reservation?{
        if let res = reservationFromRegistrationTable {
            return res
        }
        
        guard let room = room else { return nil }
        
        let firstName = firstNameTextField.text  ?? ""
        let lastName = lastNameTextField.text ?? ""
        let email = emailTextField.text  ?? ""
        let numberOfAdults = adultsNumberLabel.text ?? ""
        let numberOfChildren = childrenNumberLabel.text ?? ""
        let checkInDate = checkInDatePicker.date
        let checkOutDate = checkOutDatePicker.date
        let hasWifi = wifiSwitch.isOn
        
        if firstName == "" || lastName == ""  || email == ""  {
            return nil
        }
        
        if numberOfAdults == "0" && numberOfChildren == "0"{
            return nil
        }
        
        return Reservation(guestName: firstName, guestLastName: lastName, email: email, checkIn: checkInDate, checkOut: checkOutDate, adultsNumber: Int(numberOfAdults)!, childrenNumber:Int(numberOfChildren)! , roomChoice: room, wifi: hasWifi)
    }
    
    
    // MARK: - Outlets
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var checkInDateLabel: UILabel!
    @IBOutlet weak var checkInDatePicker: UIDatePicker!
    @IBOutlet weak var checkOutLabel: UILabel!
    @IBOutlet weak var checkOutDatePicker: UIDatePicker!
    
    @IBOutlet weak var adultsNumberLabel: UILabel!
    @IBOutlet weak var adultsStepper: UIStepper!
    @IBOutlet weak var childrenNumberLabel: UILabel!
    @IBOutlet weak var childrenStepper: UIStepper!
    
    @IBOutlet weak var wifiSwitch: UISwitch!
    
    @IBOutlet weak var roomDetailLabel: UILabel!
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    // MARK: - Date Pickers
    let checkInDatePickerIndexPath = IndexPath(row: 1, section: 1)
    let checkOutDatePickerIndexPath = IndexPath(row: 3, section: 1)
    
    var isCheckInDatePickerShown: Bool = false {
        didSet{
            checkInDatePicker.isHidden = !isCheckInDatePickerShown
        }
    }
    
    var isCheckOutDatePickerShown: Bool = false {
        didSet{
            checkOutDatePicker.isHidden = !isCheckOutDatePickerShown
            checkOutDatePicker.minimumDate = checkInDatePicker.date.addingTimeInterval(86400)
        }
    }
    
    
    // MARK: - IBActions and funcs
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func updateData(){
        guard let reservation = reservationFromRegistrationTable else { return }
            firstNameTextField.text = reservation.guestName
            lastNameTextField.text = reservation.guestLastName
            emailTextField.text = reservation.email
            checkInDatePicker.date = reservation.checkIn
            checkOutDatePicker.date = reservation.checkOut
            adultsStepper.value = Double(reservation.adultsNumber)
            childrenStepper.value = Double(reservation.childrenNumber)
            wifiSwitch.isOn = reservation.wifi
            room = reservation.roomChoice
        
        
    }
    
    
    func updateDateViews(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
       
        checkInDateLabel.text = dateFormatter.string(from: checkInDatePicker.date)
        checkOutLabel.text = dateFormatter.string(from: checkOutDatePicker.date)
        doneBarButtonState()
        
        
    }
    
    func updateNumberOfGuests(){
        adultsNumberLabel.text = String(Int(adultsStepper.value))
        childrenNumberLabel.text = String(Int(childrenStepper.value))
        doneBarButtonState()
    }
    
    func updateRoomType(){
        if let room = room {
            roomDetailLabel.text = room.name
        } else {
            roomDetailLabel.text = "Not set"
        }
        doneBarButtonState()
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        updateNumberOfGuests()
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateDateViews()
    }
    
    func doneBarButtonState(){
        if reservation == nil {
            doneBarButton.isEnabled = false
        } else {
            doneBarButton.isEnabled = true
        }
    }
    
    
    
    func didSelect(room: Room) {
        self.room = room
        updateRoomType()
    }
    
    
    // MARK: - TableView methods
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (checkInDatePickerIndexPath.section, checkInDatePickerIndexPath.row):
            if isCheckInDatePickerShown{
                return 163.0
            } else {
                return 0.0
            }
        case (checkOutDatePickerIndexPath.section, checkOutDatePickerIndexPath.row):
            if isCheckOutDatePickerShown{
                return 163.0
            } else {
                return 0.0
            }
        default:
            return 44.0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch (indexPath.section, indexPath.row) {
        case (checkInDatePickerIndexPath.section, checkInDatePickerIndexPath.row - 1):
            if isCheckInDatePickerShown{
                isCheckInDatePickerShown = false
            } else if isCheckOutDatePickerShown{
                isCheckOutDatePickerShown = false
                isCheckInDatePickerShown = true
            } else {
                isCheckInDatePickerShown = true
            }
            
            tableView.beginUpdates()
            tableView.endUpdates()
            
        case (checkOutDatePickerIndexPath.section, checkOutDatePickerIndexPath.row - 1):
            if isCheckOutDatePickerShown {
                isCheckOutDatePickerShown = false
            } else if isCheckInDatePickerShown{
                isCheckInDatePickerShown = false
                isCheckOutDatePickerShown = true
            } else {
                isCheckOutDatePickerShown = true
            }
            
            tableView.beginUpdates()
            tableView.endUpdates()
            
        default:
            break
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectRoomType"{
            let selectRoomTableViewController = segue.destination as? SelectRoomTableViewController
            selectRoomTableViewController?.delegate = self
            selectRoomTableViewController?.room = room
        }
    }
    

}
