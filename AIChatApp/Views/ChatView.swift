//
//  ChatView.swift
//  AIChatApp
//
//  Created by Prem Sai K Varma on 10/6/25.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var viewModel = ChatViewModel()
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(viewModel.messages) { message in
                            HStack {
                                if message.isUser {
                                    Spacer()
                                    Text(message.text)
                                        .padding()
                                        .background(Color.blue.opacity(0.7))
                                        .cornerRadius(10)
                                        .foregroundColor(.white)
                                        .frame(width: 250, alignment: .trailing)
                                }else {
                                    Text(message.text)
                                        .padding()
                                        .background(Color.gray.opacity(0.7))
                                        .cornerRadius(10)
                                        .frame(width: 250, alignment: .leading)
                                    Spacer()
                                }
                            }
                            .padding(.horizontal)
                            .id(message.id)
                        }
                    }
                }
                .onChange(of: viewModel.messages.count) { oldValue, newValue in
                    if let lastID = viewModel.messages.last?.id {
                        proxy.scrollTo(lastID, anchor: .bottom)
                    }
                    print("Count changed from \(oldValue) to \(newValue)")
                }
            }
            HStack {
                TextField("Type something...", text: $viewModel.currentInput)
                    .textFieldStyle(.roundedBorder)
                    .frame(minHeight: 40)
                
                Button("Send") {
                    viewModel.sendMessage()
                }
                .disabled(viewModel.currentInput.isEmpty)
            }
            .padding()
        }
    }
}

#Preview {
    ChatView()
}
