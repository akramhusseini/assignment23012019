//
//  safeArrayAccess.swift
//  assignment23012019
//
//  Created by Akram Samir Husseini on 1/24/20.
//  Copyright © 2020 Akram Samir Husseini. All rights reserved.
//

import Foundation

extension Collection {

    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
