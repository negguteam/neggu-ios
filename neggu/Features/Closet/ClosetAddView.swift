//
//  ClosetAddView.swift
//  neggu
//
//  Created by 유지호 on 9/30/24.
//

import SwiftUI

struct ClosetAddView: View {
    @State var clothes: Clothes
    @Binding var segmentedImage: UIImage?
    
    @State private var bigCategory: Int?
    @State private var smallCategory: Int?
    
    @State private var showMoodDropDown: Bool = false
    @State private var selectedMoodIndex: Int?
    
    @State private var modelName: String = ""
    @State private var priceIndex: Int?
    @State private var alreadyPurchase: Bool = false
    
    var priceList: [String] = [
        "직접입력",
        "~5만원",
        "5~10만원",
        "10~20만원",
        "20~30만원",
        "30만원~"
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Text("의상 등록하기")
                    .negguFont(.title3)
                    .padding(.horizontal, -14)
                
                HStack {
                    Image(.link)
                    
                    Text(clothes.urlString)
                }
                .negguFont(.body3)
                .foregroundStyle(.gray)
                .padding(.vertical, 32)
                
                VStack(alignment: .leading) {
                    ZStack(alignment: .bottomTrailing) {
                        if let segmentedImage {
                            Image(uiImage: segmentedImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 259, height: 343)
                        } else {
                            Image(.dummyClothes1)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 259, height: 343)
                        }
                        
                        Circle()
                            .frame(width: 42)
                            .offset(x: 10, y: 20)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 50)
                
                VStack {
                    HStack {
                        Text("카테고리")
                        
                        Text("*")
                            .foregroundStyle(.red)
                        
                        Spacer()
                    }
                    .negguFont(.body1b)
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(0..<3, id: \.self) { index in
                                HStack {
                                    Circle()
                                        .frame(width: 20)
                                        .foregroundStyle(bigCategory == index ? .white : .primary)
                                    
                                    Text("카테고리\(index)")
                                        .negguFont(.body2)
                                        .foregroundStyle(bigCategory == index ? .white : .primary)
                                }
                                .padding(8)
                                .background {
                                    Capsule()
                                        .fill(bigCategory == index ? .gray70 : .clear)
                                        .strokeBorder(.gray70)
                                }
                                .onTapGesture {
                                    if bigCategory == index {
                                        bigCategory = nil
                                    } else {
                                        bigCategory = index
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 44)
                    }
                    .padding(.horizontal, -44)
                    .scrollIndicators(.hidden)
                    
                    HStack {
                        Circle()
                            .frame(width: 21)
                        
                        Text("빨간색")
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .padding(.horizontal, 14)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.gray.opacity(0.1))
                    }
                    
//                    DropDownMenu(
//                        "스타일",
//                        dropDownList: ["아메카지", "스트릿", "고프코어", "미니멀"],
//                        showDropDown: $showMoodDropDown,
//                        selectedIndex: $selectedMoodIndex
//                    )
                    
                    Menu {
                        Button("A") {
                            
                        }
                        
                        Button("B") {
                            
                        }
                    } label: {
                        HStack {
                            Text("분위기")
                            
                            Spacer()
                            
                            Image(systemName: "chevron.down")
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .padding(.horizontal, 14)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.gray.opacity(0.1))
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(0..<3, id: \.self) { index in
                                Text("카테고리\(index)")
                                    .negguFont(.body2b)
                                    .padding(8)
                                    .background {
                                        Capsule()
                                            .fill(.gray.opacity(0.1))
                                    }
                            }
                        }
                        .padding(.horizontal, 44)
                    }
                    .padding(.horizontal, -44)
                    .scrollIndicators(.hidden)
                }
                .padding(.bottom, 50)
                
                VStack(alignment: .leading) {
                    Text("브랜드")
                        .negguFont(.body1b)
                    
                    HStack {
                        Text(clothes.brand)
                        
                        Spacer()
                        
                        Circle()
                            .frame(width: 21)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .padding(.horizontal, 14)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.gray.opacity(0.1))
                    }
                    
                    HStack {
                        TextField("모델명", text: $clothes.name)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .padding(.horizontal, 14)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.gray.opacity(0.1))
                    }
                }
                .padding(.bottom, 50)
                
                VStack(alignment: .leading) {
                    Text("가격")
                        .negguFont(.body1b)
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(priceList.indices, id: \.self) { index in
                                Text("\(priceList[index])")
                                    .negguFont(.body2b)
                                    .foregroundStyle(priceIndex == index ? .white : .primary)
                                    .padding(8)
                                    .background {
                                        Capsule()
                                            .fill(priceIndex == index ? .gray70 : .gray.opacity(0.1))
                                    }
                                    .onTapGesture {
                                        priceIndex = index
                                    }
                            }
                        }
                        .padding(.horizontal, 44)
                    }
                    .padding(.horizontal, -44)
                    .scrollIndicators(.hidden)
                }
                .padding(.bottom, 50)
                
                VStack(alignment: .leading) {
                    Text("그 외 정보")
                        .negguFont(.body1b)
                    
                    HStack {
                        Circle()
                            .frame(width: 20)
                        
                        Text("URL")
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .padding(.horizontal, 14)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.gray.opacity(0.1))
                    }
                    
                    HStack {
                        Circle()
                            .frame(width: 20)
                        
                        Text("사이즈")
                        
                        Spacer()
                        
                        Image(systemName: "chevron.down")
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .padding(.horizontal, 14)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.gray.opacity(0.1))
                    }
                    
                    HStack {
                        Circle()
                            .frame(width: 20)
                        
                        Text("소재")
                        
                        Spacer()
                        
                        Image(systemName: "chevron.down")
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .padding(.horizontal, 14)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.gray.opacity(0.1))
                    }
                    
                    HStack {
                        Circle()
                            .frame(width: 20)
                        
                        Text("메모")
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 110)
                    .padding(.horizontal, 14)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.gray.opacity(0.1))
                    }
                }
                .padding(.bottom, 50)
                
                VStack(spacing: 16) {
                    Toggle("구매한 제품이에요", isOn: $alreadyPurchase)
                        .tint(.safe)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .padding(.horizontal, 14)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.gray.opacity(0.1))
                        }
                    
                    Button("저장하기") {
                        
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.black)
                    }
                }
            }
            .padding(44)
        }
        .background(.white)
    }
}

#Preview {
    ClosetAddView(
        clothes: .init(
            urlString: "https://www.neggu.com",
            name: "dummy clothes",
            image: "",
            brand: "neggu",
            price: 12345
        ),
        segmentedImage: .constant(nil)
    )
}
