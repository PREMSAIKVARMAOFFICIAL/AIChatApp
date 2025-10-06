//
//  ChatViewModel.swift
//  AIChatApp
//
//  Created by Prem Sai K Varma on 10/6/25.
//

import Foundation
import Combine

@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var currentInput: String = ""
    
    private let apiKey = "YOUR_OPENAI_API_KEY" // Replace with real one
    
    func sendMessage() {
        let userMessage = Message(text: currentInput, isUser: true)
        messages.append(userMessage)
        
        Task {
            let responseText = await fetchBotResponse(for: currentInput)
            let botMessage = Message(text: responseText, isUser: false)
            messages.append(botMessage)
            currentInput = ""
        }
    }
    
    private func fetchBotResponse(for input: String) async -> String {
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            return "Invalid URL"
        }
        
        let body: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "user", "content": input]
            ]
        ]
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-type")
        urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let choices = json["choices"] as? [[String: Any]],
               let message = choices.first?["message"] as? [String: Any],
               let content = message["content"] as? String {
                return content.trimmingCharacters(in: .whitespacesAndNewlines)
            }else {
                return "Failed to parse response."
            }
        }catch {
            return "Error: \(error.localizedDescription)"
        }
    }
}
