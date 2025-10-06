//
//  Message.swift
//  AIChatApp
//
//  Created by Prem Sai K Varma on 10/6/25.
//

import Foundation

struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}
