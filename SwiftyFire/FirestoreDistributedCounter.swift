//
//  FirestoreDistributedCounter.swift
//  SwiftyFire
//
//  Created by Alex Nagy on 18/05/2019.
//  Copyright © 2019 Alex Nagy. All rights reserved.
//

import FirebaseFirestore

struct FirestoreDistributedCounterKey {
    static let numShards = "numShards"
    static let shards = "shards"
    static let count = "count"
}

class FirestoreDistributedCounter {
    
    static func createCounter(ref: DocumentReference, numShards: Int, completion: @escaping (Result<Bool, Error>) -> ()) {
        let batch = Firestore.firestore().batch()
        
        batch.setData([FirestoreDistributedCounterKey.numShards: numShards], forDocument: ref)
        
        for i in 0...numShards - 1 {
            let shardsRef = ref.collection(FirestoreDistributedCounterKey.shards).document(String(i))
            batch.setData([FirestoreDistributedCounterKey.count: 0], forDocument: shardsRef)
        }
        
        batch.commit { (err) in
            if let err = err {
                completion(.failure(err))
            }
            completion(.success(true))
        }
        
    }
    
    static func incrementCounter(by: Int, ref: DocumentReference, numShards: Int, completion: @escaping (Result<Bool, Error>) -> ()) {
        // Select a shard of the counter at random
        let shardId = Int(arc4random_uniform(UInt32(numShards - 1)))
        let shardRef = ref.collection(FirestoreDistributedCounterKey.shards).document(String(shardId))
        
        shardRef.updateData([
            FirestoreDistributedCounterKey.count: FieldValue.increment(Int64(by))
        ]) { (err) in
            if let err = err {
                completion(.failure(err))
            }
            completion(.success(true))
        }
    }
    
    static func getCount(ref: DocumentReference, completion: @escaping (Result<Int, Error>) -> ()) {
        ref.collection(FirestoreDistributedCounterKey.shards).getDocuments() { (querySnapshot, err) in
            var totalCount = 0
            if let err = err {
                completion(.failure(err))
            }
            for document in querySnapshot!.documents {
                guard let count = document.data()[FirestoreDistributedCounterKey.count] as? Int else { return }
                totalCount += count
            }
            completion(.success(totalCount))
        }
    }
    
}
