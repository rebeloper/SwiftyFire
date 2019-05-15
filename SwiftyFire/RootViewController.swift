//
//  RootViewController.swift
//  SwiftyFire
//
//  Created by Alex Nagy on 13/05/2019.
//  Copyright © 2019 Alex Nagy. All rights reserved.
//

import UIKit
import Firebase
import TinyConstraints

class RootViewController: UIViewController {
    
    let docData: [String: Any] = [
        "stringExample": "Hello world!",
        "booleanExample": true,
        "numberExample": 3.14159265,
        "dateExample": Timestamp(date: Date()),
        "arrayExample": [5, true, "hello"],
        "nullExample": NSNull(),
        "objectExample": [
            "a": 5,
            "b": [
                "nested": "foo"
            ]
        ]
    ]
    
    lazy var button: PurpleButton = {
        let button = PurpleButton(title: "Add")
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func buttonTapped() {
        
        // To create or overwrite a single document, use the set() method
        FirestoreReferenceManager.root
            .collection(FirebaseKeys.CollectionPath.cities)
            .document("LA")
            .setData(["name": "Los Angeles",
                      "state": "CA",
                      "country": "USA"]) { (err) in
                        if let err = err {
                            print(err.localizedDescription)
                        }
                        print("Successfully set data")
        }
        
        // If the document does not exist, it will be created. If the document does exist, its contents will be overwritten with the newly provided data, unless you specify that the data should be merged into the existing document, as follows
        
        let cityData = [
            "name": "Los Angeles New"
        ]
        
        FirestoreReferenceManager.root
            .collection(FirebaseKeys.CollectionPath.cities)
            .document("LA")
            .setData(cityData, merge: true) { (err) in
                if let err = err {
                    print(err.localizedDescription)
                }
                print("Successfully set new data")
        }
        
        // When you use set() to create a document, you must specify an ID for the document to create. But sometimes there isn't a meaningful ID for the document, and it's more convenient to let Cloud Firestore auto-generate an ID for you. You can do this by calling add()
        
        let newCityData = [
            "name": "Tokyo",
            "country": "Japan"
        ]
        
        FirestoreReferenceManager.root.collection(FirebaseKeys.CollectionPath.cities).addDocument(data: newCityData) { (err) in
            if let err = err {
                print(err.localizedDescription)
            }
            print("Successfully set new city data")
        }
        
        // In some cases, it can be useful to create a document reference with an auto-generated ID, then use the reference later.
        
        let ref = FirestoreReferenceManager.root.collection(FirebaseKeys.CollectionPath.cities).document()
        let documentId = ref.documentID
        
        let newestCityData = [
            "name": "Berlin",
            "country": "Germany",
            "uid": documentId
        ]
        
        ref.setData(newestCityData, merge: true) { (err) in
            if let err = err {
                print(err.localizedDescription)
            }
            print("Successfully set newest city data")
        }
        
        // Hands on example: save a new user
        let reference = FirestoreReferenceManager.root.collection(FirebaseKeys.CollectionPath.users).document()
        let uid = reference.documentID
        
        let userData = [
            "uid": uid,
            "name": "Bob"
        ]
        
        FirestoreReferenceManager.referenceForUserPublicData(uid: uid).setData(userData, merge: true) { (err) in
            if let err = err {
                print(err.localizedDescription)
            }
            print("Successfully set user data")
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        view.addSubview(button)
        button.edgesToSuperview(excluding: .bottom, insets: UIEdgeInsets(top: 32, left: 16, bottom: 0, right: 16), usingSafeArea: true)
        button.height(50)
    }


}

