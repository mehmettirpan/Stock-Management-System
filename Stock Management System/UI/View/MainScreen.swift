//
//  MainScreen.swift
//  Stock Management System
//
//  Created by Mehmet Tırpan on 6.05.2024.
//

import UIKit
import Firebase

class MainScreen: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var stockStatus: UIButton!
    @IBOutlet weak var addStock: UIButton!
    @IBOutlet weak var report: UIButton!
    @IBOutlet weak var logOut: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logOutClicked(_ sender: Any) {
        
        do { // hiç kullanıcı olmama ihtimaline karşı do try catch ile yaptık zaten normal yazdığımız takdirde de sistem bu kodu kabul etmeyecektir
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toLogIn", sender: nil)
        }catch{
            print("error")
        }
        
    }
    

}

