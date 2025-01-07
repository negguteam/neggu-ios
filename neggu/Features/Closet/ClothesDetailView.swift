//
//  ClothesDetailView.swift
//  neggu
//
//  Created by 유지호 on 11/7/24.
//

import SwiftUI

struct ClothesDetailView: View {
    let clothes: Clothes
    
    @State private var clothesText: String = ""
    @State private var showLookBookEditView: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                Spacer(minLength: 200)
                
                VStack {
                    Spacer(minLength: 200)
                    
                    ScrollView {
                        VStack {
                            HStack(spacing: 16) {
                                Button {
                                    
                                } label: {
                                    HStack(spacing: 4) {
                                        Text("공유하기")
                                        
                                        Image(systemName: "square.and.arrow.down")
                                    }
                                    .padding()
                                    .background(.labelAlt)
                                    .clipShape(.rect(cornerRadius: 20))
                                    .negguFont(.body1b)
                                    .foregroundStyle(.white)
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                Button {
                                    showLookBookEditView = true
                                } label: {
                                    HStack(spacing: 4) {
                                        Text("룩북 만들기")
                                        
                                        Image(.shirtFill)
                                    }
                                    .padding()
                                    .background(.negguSecondary)
                                    .clipShape(.rect(cornerRadius: 20))
                                    .negguFont(.body1b)
                                    .foregroundStyle(.labelNormal)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .padding(.top, 10)
                            
                            VStack(alignment: .leading) {
                                Text("의상 정보")
                                    .negguFont(.title3)
                                
                                TextField("", text: $clothesText)
                                    .padding()
                                    .background {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(.bgAlt)
                                    }
                            }
                            .foregroundStyle(.black)
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .background(.white)
                .clipShape(.rect(topLeadingRadius: 24, topTrailingRadius: 24))
            }
            .ignoresSafeArea(edges: .bottom)
            
            Image(.dummyClothes0)
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 400)
        }
        .fullScreenCover(isPresented: $showLookBookEditView) {
            LookBookEditView()
        }
    }
}

#Preview {
    ClothesDetailView(
        clothes: .init(
            name: "멋진 옷",
            link: "www.neggu.com",
            imageUrl: "",
            brand: "네꾸"
        )
    )
    .background(.black.opacity(0.3))
}
