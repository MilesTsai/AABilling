//
//  Manager.swift
//  Project-2
//
//  Created by User on 2019/5/8.
//  Copyright © 2019 Miles. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

enum FIRCollectionReference: String {
    case users
}

class Service {
    
    private init() {}
    static let shared = Service()
    
    func configure() {
        FirebaseApp.configure()
    }
    
    private func reference(to collectionReference: FIRCollectionReference) -> CollectionReference {
        return Firestore.firestore().collection(collectionReference.rawValue)
    }
    
    var userData: UserData?
    
    var friendData: PersonalData?
    
    lazy var userReference = Firestore.firestore().collection(UserEnum.users.rawValue)
    
    func create(in collectionReference: FIRCollectionReference) {
        
    }
    
    func read(from collectionReference: FIRCollectionReference, completion: @escaping ([PersonalData]) -> Void) {
        reference(to: collectionReference).getDocuments { (snapshot, error) in
            
            guard let snapshot = snapshot else { return }
            
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in snapshot.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
    
    func update() {
        
    }
    
    func delete() {
        
    }
}
