//
//  Alerts.swift
//  Tictactoe
//
//  Created by Irakli Sokhaneishvili on 14.01.22.
//

import Foundation
import SwiftUI


struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buuttonTitle: Text
}

struct AlertContext {
    static let humanWin = AlertItem(
        title: Text("You Win!"),
        message: Text("Beating the AI isn't easy to do, KEKW"),
        buuttonTitle: Text("Great job!")
    )
    
    static let computerWin = AlertItem(
        title: Text("You Lost!"),
        message: Text("Such a sad story"),
        buuttonTitle: Text("Terrible!")
    )
    
    static let draw = AlertItem(
        title: Text("Draw!"),
        message: Text("Beating the AI isn't easy to do, KEKW"),
        buuttonTitle: Text("Try again!")
    )
    
}
