//
//  AuthorizedUser.swift
//  ContactList
//
//  Created by Prearo, Andrea on 3/9/16.
//  Copyright © 2016 Prearo, Andrea. All rights reserved.
//

import Foundation
import Locksmith
import Alamofire

class AuthorizedUser: ReadableSecureStorable, CreateableSecureStorable, DeleteableSecureStorable, GenericPasswordSecureStorable {

    class var StoreKey: String { return "AuthorizedUserKey" }

    let email: String?
    let password: String?
    let token: String?

    init?(email: String?, password: String?, token: String?) {
        self.email = email
        self.password = password
        self.token = token
    }

    // MARK: CreateableSecureStorable protocol methods

    var data: [String: AnyObject] {
        let email: String
        if let unwrapped = self.email {
            email = unwrapped
        } else {
            email = ""
        }
        let password: String
        if let unwrapped = self.password {
            password = unwrapped
        } else {
            password = ""
        }
        let token: String
        if let unwrapped = self.token {
            token = unwrapped
        } else {
            token = ""
        }
        return [ "email": email, "password": password, "token": token ]
    }

    // MARK: GenericPasswordSecureStorable protocol methods

    let service = "ContactList"
    var account: String {
        if let email = email {
            return email
        } else {
            return ""
        }
    }
    
}

extension AuthorizedUser {
    
    static func decode(json: [String: AnyObject]) -> AuthorizedUser? {
        let email = json["email"] as? String
        let password = json["password"] as? String
        let token = json["token"] as? String
        return AuthorizedUser(email: email, password: password, token: token)
    }

    static func loadFromStore() -> Result<AuthorizedUser, NSError>  {
        if let accountData = Locksmith.loadDataForUserAccount(AuthorizedUser.StoreKey),
            account = AuthorizedUser.decode(accountData) {
            return .Success(account)
        }

        return .Failure(ErrorCodes.InvalidAuthorizedUser())
    }
        
}
