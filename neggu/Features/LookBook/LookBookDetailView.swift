//
//  LookBookView.swift
//  neggu
//
//  Created by 유지호 on 10/13/24.
//

import SwiftUI

struct LookBookDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var clothes: Clothes?
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading) {
                    Image("dummy_lookbook")
                        .containerRelativeFrame(.horizontal)
                        .padding(.vertical, 64)
                    
                    Text("이 룩북에 쓰인 옷")
                        .negguFont(.title4)
                        .foregroundStyle(.labelNormal)
                        .padding(.horizontal, 20)
                    
                    LazyVGrid(columns: [GridItem](repeating: GridItem(.flexible()), count: 4)) {
                        ForEach(0...5, id: \.self) { index in
                            Button {
                                clothes = .init(urlString: "", name: "옷\(index)", image: "", brand: "", price: 1234)
                            } label: {
                                Image("dummy_clothes\(index % 3)")
                                    .resizable()
                                    .aspectRatio(0.8, contentMode: .fit)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
                .padding(.top, 12)
                .background(.white)
                .clipShape(.rect(topLeadingRadius: 36, topTrailingRadius: 36))
            }
            .scrollIndicators(.hidden)
            
            HStack {
                Button {
                    
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundStyle(.white)
                        .frame(width: 56, height: 56)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.black)
                        }
                }
                .buttonStyle(PlainButtonStyle())
                
                Button {
                    
                } label: {
                    HStack {
                        Image(systemName: "calendar")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                        
                        Text("입을 날짜 설정")
                            .negguFont(.body1b)
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.negguSecondary)
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
        }
        .background(.gray5)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.labelNormal)
                }
            }
            
            ToolbarItem(placement: .principal) {
                HStack(spacing: 4) {
                    Text("데이트룩")
                        .negguFont(.body1b)
                    
                    Button("", systemImage: "pencil") {
                        
                    }
                    .frame(width: 24, height: 24)
                }
                .foregroundStyle(.labelNormal)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button("이미지로 저장하기") {
                        
                    }
                    
                    Button("편집하기") {
                        
                    }
                    
                    Button("삭제하기", role: .destructive) {
                        
                    }
                    .buttonStyle(PlainButtonStyle())
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(.labelNormal)
                }
            }
        }
        .sheet(item: $clothes) { clothes in
            ClothesDetailView(clothes: clothes)
                .presentationDetents([.fraction(0.99)])
                .presentationBackground(.clear)
        }
    }
}

#Preview {
    NavigationStack {
        LookBookDetailView()
    }
}


extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
    
}
