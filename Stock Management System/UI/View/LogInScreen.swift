//
//  ViewController.swift
//  Stock Management System
//
//  Created by Mehmet Tırpan on 6.05.2024.
//


// Test User: tester@test.com  pw: 12345678

import UIKit
import Firebase
import FirebaseAuth

class LogInScreen: UIViewController {

    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var brandLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }

    @IBAction func logInButtonClicked(_ sender: Any) {
        if emailTextField.text != "" && passwordTextField.text != "" {
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authDataResult, error) in
                if let error = error {
                    self.errorMessage(titleInput: "Error", messageInput: error.localizedDescription)
                } else {
                    // Giriş başarılı olduğunda koleksiyona bağlan
                    self.connectToUserCollection()
                }
            }
        } else {
            errorMessage(titleInput: "Error", messageInput: "Email and password cannot be empty")
        }
    }
    
    @IBAction func signInButtonClicked(_ sender: Any) {
        if emailTextField.text != "" && passwordTextField.text != "" {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authDataResult, error) in
                if let error = error {
                    self.errorMessage(titleInput: "Error", messageInput: error.localizedDescription)
                } else {
                    // Kullanıcı başarıyla kaydedildi, şimdi giriş yapmasını iste
                    self.logInButtonClicked(sender)
                }
            }
        } else {
            errorMessage(titleInput: "Error", messageInput: "Email and password cannot be empty")
        }
    }
    
    func errorMessage(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    func connectToUserCollection() {
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        let userCollectionRef = db.collection("users").document(currentUserUID)
        userCollectionRef.getDocument { (document, error) in
            if let document = document, document.exists {
                // Kullanıcı koleksiyona bağlı, devam et
                self.performSegue(withIdentifier: "toMain", sender: nil)
            } else {
                // Kullanıcı koleksiyona bağlı değil, koleksiyon oluştur
                self.createUserCollection()
            }
        }
    }
    
    func createUserCollection() {
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        let userCollectionRef = db.collection("users").document(currentUserUID)
        userCollectionRef.setData([:]) { (error) in
            if let error = error {
                print("Error creating user collection: \(error.localizedDescription)")
            } else {
                print("User collection created successfully")
                self.performSegue(withIdentifier: "toMain", sender: nil)
            }
        }
    }
}
