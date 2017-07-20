//
//  StringExtensions.swift
//  HCLinkPreview
//
//  Created by Lebron on 20/07/2017.
//  Copyright © 2017 hacknocraft. All rights reserved.
//

import Foundation

internal extension String {
    internal func characterAt(index i: Int) -> Character? {
        guard i < utf8.count else { return nil }
        return self[characters.index(startIndex, offsetBy: i)]
    }
}
