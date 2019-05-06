//
//  User.swift
//  Crumble
//
//  Created by Nathan Stack on 5/5/19.
//  Copyright © 2019 Beth Mieczkowski. All rights reserved.
//

import Foundation

class User {
    var session_token: String
    var session_expiration: String
    var update_token: String
    
    init(session_token: String, session_expiration: String, update_token: String) {
        self.session_token = session_token
        self.session_expiration = session_expiration
        self.update_token = update_token
    }
    
}
