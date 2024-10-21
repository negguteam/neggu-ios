//
//  LookBookView.swift
//  neggu
//
//  Created by 유지호 on 10/13/24.
//

import SwiftUI

struct LookBookView: View {
    @State private var selectedIndex: Int?
    
    var body: some View {
        ScrollView {
            VStack {
                RoundedRectangle(cornerRadius: 36)
                    .fill(.white)
                    .frame(height: 703)
                    .overlay {
                        VStack(spacing: 18) {
                            Spacer()
                            
                            HStack {
                                Circle()
                                    .frame(width: 36)
                                
                                Text("김수한무")
                                    .bold()
                                +
                                Text("님이 만들어준 룩북")
                                
                                Spacer()
                                
                                Text("2024/10/10")
                            }
                            .negguFont(.body3)
                            .padding(.horizontal, 14)
                            
                            
                            HStack {
                                ForEach(0..<4, id: \.self) { index in
                                    Button {
                                        print(index)
                                    } label: {
                                        VStack(spacing: 8) {
                                            Image(systemName: "globe")
                                                .foregroundStyle(.orange40)
                                            
                                            Text("메뉴\(index)")
                                                .negguFont(.caption)
                                        }
                                    }
                                    .buttonStyle(PrimaryButtonStyle())
//                                    .onLongPressGesture {
//                                        selectedIndex = index
//                                    }
//                                    .onTapGesture {
//                                        selectedIndex = index
//                                    }
                                }
                            }
                            .padding(12)
                            .background(.gray5)
                            .clipShape(.rect(cornerRadius: 20))
                        }
                        .padding(.horizontal, 28)
                        .padding(.vertical, 24)
                    }
            }
            .padding(20)
        }
        .scrollIndicators(.hidden)
        .background(.gray5)
    }
}

#Preview {
    LookBookView()
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
//            .negguFont(.caption)
//            .foregroundColor(.primaryButtonLabel)
            .frame(width: 72, height: 72)
            .foregroundStyle(configuration.isPressed ? .orange40 : .gray40)
            .background(configuration.isPressed ? .orange10 : .gray5)
            .clipShape(.rect(cornerRadius: 12))
    }
}
