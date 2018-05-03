//
//  Int.swift
//  Cordate
//
//  Created by Ryan Wachowski on 5/3/18.
//  Copyright © 2018 Duet Health. All rights reserved.
//

import Foundation

extension Int {

    static func allEqual(_ values: Int...) -> Bool {
        guard values.count > 1 else { return true }
        for value in values.dropFirst() {
            if value != values.first! { return false }
        }
        return true
    }

}
