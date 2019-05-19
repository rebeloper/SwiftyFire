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
    
    lazy var addButton: PurpleButton = {
        let button = PurpleButton(title: "Add")
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func addButtonTapped() {
        
        // To create or overwrite a single document, use the set() method
        FirestoreReferenceManager.root
            .collection(FirebaseKeys.CollectionPath.cities)
            .document("LA")
            .setData(["name": "Los Angeles",
                      "state": "CA",
                      "country": "USA",
                      "favorites": [ "food": "Pizza", "color": "Blue", "subject": "recess" ],]) { (err) in
                        if let err = err {
                            print(err.localizedDescription)
                        }
                        print("Successfully set data")
        }
        
        FirestoreReferenceManager.root
            .collection(FirebaseKeys.CollectionPath.cities)
            .document("NY")
            .setData(["name": "New York",
                      "state": "NY",
                      "country": "USA",
                      "favorites": [ "food": "Pizza", "color": "Blue", "subject": "recess" ],]) { (err) in
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
    
    lazy var updateButton: PurpleButton = {
        let button = PurpleButton(title: "Update")
        button.addTarget(self, action: #selector(updateButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func updateButtonTapped() {
        
        // To update some fields of a document without overwriting the entire document, use the update() method
        
        // If your document contains nested objects, you can use "dot notation" to reference nested fields within the document when you call update()
        
        // You can also add server timestamps to specific fields in your documents, to track when an update was received by the server
        
        // If your document contains an array field, you can use arrayUnion() and arrayRemove() to add and remove elements. arrayUnion() adds elements to an array but only elements not already present. arrayRemove() removes all instances of each given element.
        
        let ref = FirestoreReferenceManager
            .root
            .collection(FirebaseKeys.CollectionPath.cities)
            .document("LA")
        
        ref.updateData(["name": "Los Angeles Updated",
                        "favorites.color": "Green",
                        "updatedAt": FieldValue.serverTimestamp(),
                        "regions": FieldValue.arrayRemove(["greater_virginia"])]) { (err) in
            if let err = err {
                print(err.localizedDescription)
            }
            print("Successfully updated data")
        }
        
    }
    
    lazy var incrementButton: PurpleButton = {
        let button = PurpleButton(title: "Increment")
        button.addTarget(self, action: #selector(incrementButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func incrementButtonTapped () {
        let ref = FirestoreReferenceManager
            .root
            .collection(FirebaseKeys.CollectionPath.cities)
            .document("LA")
        
        ref.updateData(["likes": FieldValue.increment(Int64(1))]) { (err) in
            if let err = err {
                print(err.localizedDescription)
            }
            print("Successfully incremented likes count")
        }
        
        
    }
    
    lazy var createDistributedCounterButton: PurpleButton = {
        let button = PurpleButton(title: "Create Distributed Counter")
        button.addTarget(self, action: #selector(createDistributedCounterButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func createDistributedCounterButtonTapped () {
        let ref = FirestoreReferenceManager
            .root
            .collection(FirebaseKeys.CollectionPath.cities)
            .document("LA")
            .collection("likes")
            .document("likes")
        
        let numShards = 10
        FirestoreDistributedCounter.createCounter(ref: ref, numShards: numShards) { (result) in
            switch result {
            case .success(_):
                print("Successfully created counter with \(numShards) shards")
            case .failure(let err):
                print("Failed to create counter with err: \(err.localizedDescription)")
            }
        }
        
        
    }
    
    lazy var distributedIncrementButton: PurpleButton = {
        let button = PurpleButton(title: "Distributed Increment")
        button.addTarget(self, action: #selector(distributedIncrementButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func distributedIncrementButtonTapped () {
        let ref = FirestoreReferenceManager
            .root
            .collection(FirebaseKeys.CollectionPath.cities)
            .document("LA")
            .collection("likes")
            .document("likes")
        
        let incrementValue = 1
        let numShards = 2
        FirestoreDistributedCounter.incrementCounter(by: incrementValue, ref: ref, numShards: numShards) { (result) in
            switch result {
            case .success(_):
                print("Successfully incremented counter with value: \(incrementValue) and \(numShards) shards")
            case .failure(let err):
                print("Failed to increment counter with err: \(err.localizedDescription)")
            }
        }
        
    }
    
    lazy var getCountButton: PurpleButton = {
        let button = PurpleButton(title: "Get Count")
        button.addTarget(self, action: #selector(getCountButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func getCountButtonTapped () {
        let ref = FirestoreReferenceManager
            .root
            .collection(FirebaseKeys.CollectionPath.cities)
            .document("LA")
            .collection("likes")
            .document("likes")
        
        FirestoreDistributedCounter.getCount(ref: ref) { (result) in
            switch result {
            case .success(let count):
                print("Total count is: \(count)")
            case .failure(let err):
                print("Failed to get total count with err: \(err.localizedDescription)")
            }
        }
        
    }
    
    lazy var commitBatchButton: PurpleButton = {
        let button = PurpleButton(title: "Commit Batch")
        button.addTarget(self, action: #selector(commitBatchButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func commitBatchButtonTapped () {
        let ref1 = FirestoreReferenceManager
            .root
            .collection(FirebaseKeys.CollectionPath.cities)
            .document("LA")
        let data1 = ["favorites.color": "Green"]
        
        let ref2 = FirestoreReferenceManager
            .root
            .collection(FirebaseKeys.CollectionPath.cities)
            .document("NY")
        
        let data2 = ["favorites.color": "Green"]
        
        let batch = Firestore.firestore().batch()
        
        batch.updateData(data1, forDocument: ref1)
        batch.updateData(data2, forDocument: ref2)
        
        batch.commit { (err) in
            if let err = err {
                print(err.localizedDescription)
            }
            print("Successfully commited batch")
        }
        
    }
    
    lazy var runTransactionButton: PurpleButton = {
        let button = PurpleButton(title: "Run Transaction")
        button.addTarget(self, action: #selector(runTransactionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func runTransactionButtonTapped () {
        let ref = FirestoreReferenceManager
            .root
            .collection(FirebaseKeys.CollectionPath.cities)
            .document("LA")
        
        let db = Firestore.firestore()
        
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let trDocument: DocumentSnapshot
            do {
                try trDocument = transaction.getDocument(ref)
            } catch let err {
                print(err.localizedDescription)
                return nil
            }
            
            guard let oldName = trDocument.data()?["name"] as? String else {
                let error = NSError(
                    domain: "AppErrorDomain",
                    code: -1,
                    userInfo: [
                        NSLocalizedDescriptionKey: "Unable to retrieve population from snapshot \(trDocument)"
                    ]
                )
                errorPointer?.pointee = error
                return nil
            }
            
            let newName = oldName + " Plus"
            transaction.updateData(["name": newName], forDocument: ref)
            
            return newName
        }) { (object, err) in
            if let err = err {
                print(err.localizedDescription)
            }
            print("Successfully ran transaction with object: \(String(describing: object))")
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        view.addSubview(addButton)
        view.addSubview(updateButton)
        view.addSubview(incrementButton)
        view.addSubview(createDistributedCounterButton)
        view.addSubview(distributedIncrementButton)
        view.addSubview(getCountButton)
        view.addSubview(commitBatchButton)
        view.addSubview(runTransactionButton)
        
        addButton.edgesToSuperview(excluding: .bottom, insets: UIEdgeInsets(top: 32, left: 16, bottom: 0, right: 16), usingSafeArea: true)
        addButton.height(50)
        
        updateButton.topToBottom(of: addButton, offset: 8)
        updateButton.left(to: addButton)
        updateButton.right(to: addButton)
        updateButton.height(50)
        
        incrementButton.topToBottom(of: updateButton, offset: 8)
        incrementButton.left(to: addButton)
        incrementButton.right(to: addButton)
        incrementButton.height(50)
        
        createDistributedCounterButton.topToBottom(of: incrementButton, offset: 8)
        createDistributedCounterButton.left(to: addButton)
        createDistributedCounterButton.right(to: addButton)
        createDistributedCounterButton.height(50)
        
        distributedIncrementButton.topToBottom(of: createDistributedCounterButton, offset: 8)
        distributedIncrementButton.left(to: addButton)
        distributedIncrementButton.right(to: addButton)
        distributedIncrementButton.height(50)
        
        getCountButton.topToBottom(of: distributedIncrementButton, offset: 8)
        getCountButton.left(to: addButton)
        getCountButton.right(to: addButton)
        getCountButton.height(50)
        
        commitBatchButton.topToBottom(of: getCountButton, offset: 8)
        commitBatchButton.left(to: addButton)
        commitBatchButton.right(to: addButton)
        commitBatchButton.height(50)
        
        runTransactionButton.topToBottom(of: commitBatchButton, offset: 8)
        runTransactionButton.left(to: addButton)
        runTransactionButton.right(to: addButton)
        runTransactionButton.height(50)
    }

}

