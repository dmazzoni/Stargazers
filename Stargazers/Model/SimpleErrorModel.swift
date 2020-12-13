//
//  SimpleErrorModel.swift
//  Stargazers
//
//  Created by Davide Mazzoni on 13/12/20.
//

import Foundation

// MARK: - SimpleErrorModel
struct SimpleErrorModel {
    let message: String
}

extension SimpleErrorModel: Identifiable {
    
    var id: String { self.message }
}
