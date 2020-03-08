//
//  File.swift
//  AnalIGzer
//
//  Created by Angel Fuentes on 25/11/2018.
//  Copyright © 2018 Angel Fuentes. All rights reserved.
//

import Foundation

struct IGAccessModel: Decodable {
    let authenticated: Bool?
    let user: Bool?
    let userId: String?
    let oneTapPrompt: Bool?
    let status: String?
}
