//
//  DatabaseManager.swift
//  MessengerClone
//
//  Created by Michael Handkins on 1/31/21.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    static func safeEmail(emailAddress: String) -> String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
}

// MARK: - Account Management

extension DatabaseManager {
    
    public func userExists(with email: String,
                                completion: @escaping ((Bool) -> Void)) {
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value) { (snapshot) in
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            
            completion(true)
        }
        
    }
    
    /// Inserts new user to database
    public func insertUser(with user: ChatAppUser, completion: @escaping (Bool) -> Void) {
        database.child(user.safeEmail).setValue([
            "first_name" : user.firstName,
            "last_name" : user.lastName
        ]) { (error, _) in
            guard error == nil else {
                print("failed to insert user to database")
                completion(false)
                return
            }
            completion(true)
        }
    }
    
}

struct ChatAppUser {
    let firstName: String
    let lastName: String
    let emailAddress: String
    var profilePictureFileName: String {
        return "\(safeEmail)_profile_picture.png"
    }
    
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}
