//
//  PurpleButton.swift
//  SwiftyFire
//
//  Created by Alex Nagy on 15/05/2019.
//  Copyright © 2019 Alex Nagy. All rights reserved.
//

import UIKit

class PurpleButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(title: String) {
        super.init(frame: .zero)
        backgroundColor = .purple
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    func a() {
        let db = Firestore.firestore()
        
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let trDocument: DocumentSnapshot
            do {
                try trDocument = transaction.getDocument(ref)
            } catch let err as NSError {
                errorPointer?.pointee = err
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
                print("Transaction failed: \(err.localizedDescription)")
            } else {
                print("Transaction successfully committed new nema: \(String(describing: object))!")
            }
        }
    }
 */
}
