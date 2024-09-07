//
//  AddAddressViewController.swift
//  HEIN
//
//  Created by Marco on 2024-09-07.
//

import UIKit

class AddAddressViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var fieldsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        fieldsTable.delegate = self
        fieldsTable.dataSource = self
        
        let textFeildCellNib = UINib(nibName: "TextFieldViewCell", bundle: nil)
        fieldsTable.register(textFeildCellNib, forCellReuseIdentifier: "textFieldCell")
    }
    
    @IBAction func saveAddreess(_ sender: Any) {
        // save
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = fieldsTable.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexPath) as! TextFieldViewCell
        
        switch indexPath.row{
        case 0:
            cell.labelName.text = "Address Name"
        case 1:
            cell.labelName.text = "Street"
        case 2:
            cell.labelName.text = "City"
        case 3:
            cell.labelName.text = "Country"
        case 4:
            cell.labelName.text = "Phone"
        default:
            cell.labelName.text = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

