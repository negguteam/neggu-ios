//
//  ClosetAddView.swift
//  neggu
//
//  Created by 유지호 on 9/30/24.
//

import SwiftUI

struct ClosetAddView: View {
    @Environment(\.dismiss) private var dismiss
    @State var clothes: Clothes
    @Binding var segmentedImage: UIImage?
    
    @State private var priceRange: PriceRange? = .first
    
    @State private var showNameEditView: Bool = false
    @State private var showAlert: Bool = false
    
    @State private var modelName: String = "후드"
    @State private var editedModelName: String = ""
    
    @State private var brandName: String = "아디다스"
    @State private var alreadyPurchase: Bool = false
    @State private var purchaseLink: String = ""
    @State private var memoString: String = ""
    
    var priceList: [String] = [
        "직접입력",
        "~5만원",
        "5~10만원",
        "10~20만원",
        "20~30만원",
        "30만원~"
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button("취소하기") {
                    showAlert = true
                }
                .negguFont(.body2)
                .foregroundStyle(.red)
                
                Spacer()
                
                Button("저장하기") {
                    // TODO: 필드값 검증
                    validateField()
                }
                .negguFont(.body2b)
                .foregroundStyle(.black)
            }
            .frame(height: 40)
            .padding(.horizontal, 20)
            
            ScrollView {
                Group {
                    if let image = segmentedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                    } else {
                        Rectangle()
                            .fill(.bgNormal)
                    }
                }
                .frame(height: 366)
                .padding(.bottom, 20)
                
                LazyVStack(
                    spacing: 20,
                    pinnedViews: [.sectionHeaders]
                ) {
                    Section {
                        VStack(alignment: .leading) {
                            HStack(spacing: 0) {
                                Text("어떤 종류의 옷인가요?")
                                
                                Text("*")
                                    .foregroundStyle(.red)
                            }
                            .negguFont(.body1b)
                            
                            HStack {
                                Text("옷의 종류")
                                    .negguFont(.body2b)
                                    .foregroundStyle(.labelInactive)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.down")
                            }
                            .padding()
                            .background() {
                                RoundedRectangle(cornerRadius: 16)
                                    .strokeBorder(.lineAlt)
                            }
                            
                            HStack {
                                Text("옷의 분위기")
                                    .negguFont(.body2b)
                                    .foregroundStyle(.labelInactive)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.down")
                            }
                            .padding()
                            .background() {
                                RoundedRectangle(cornerRadius: 16)
                                    .strokeBorder(.lineAlt)
                            }
                        }
                        .padding(.vertical, 32)
                        .padding(.horizontal, 28)
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.white)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("어느 브랜드인가요?")
                                .negguFont(.body1b)
                            
                            HStack {
                                Text("옷의 종류")
                                    .negguFont(.body2b)
                                    .foregroundStyle(.labelInactive)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.down")
                            }
                            .padding()
                            .background() {
                                RoundedRectangle(cornerRadius: 16)
                                    .strokeBorder(.lineAlt)
                            }
                        }
                        .padding(.vertical, 32)
                        .padding(.horizontal, 28)
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.white)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("얼마인가요?")
                                .negguFont(.body1b)
                            
                            ToggleButtonPicker<PriceRange>(selection: $priceRange)
                        }
                        .padding(.vertical, 32)
                        .padding(.horizontal, 28)
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.white)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("어디서 구매하나요?")
                                .negguFont(.body1b)
                            
                            HStack(spacing: 18) {
                                Button {
                                    alreadyPurchase = true
                                } label: {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(alreadyPurchase ? .negguSecondaryAlt : .labelRAlt)
                                        .strokeBorder(alreadyPurchase ? .negguSecondary : .labelInactive)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 48)
                                        .overlay {
                                            Text("구매함")
                                                .negguFont(.body2)
                                                .foregroundStyle(alreadyPurchase ?  .negguSecondary : .labelInactive)
                                        }
                                }
                                
                                Button {
                                    alreadyPurchase = false
                                } label: {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(alreadyPurchase ? .labelRAlt : .negguSecondaryAlt)
                                        .strokeBorder(alreadyPurchase ?  .labelInactive : .negguSecondary)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 48)
                                        .overlay {
                                            Text("구매하지 않음")
                                                .negguFont(.body2)
                                                .foregroundStyle(alreadyPurchase ? .labelInactive : .negguSecondary)
                                        }
                                }
                            }
                            
                            HStack(spacing: 16) {
                                Image(.link)
                                    .foregroundStyle(.labelAssistive)
                                    .padding(.leading, 12)
                                
                                TextField(
                                    "",
                                    text: $purchaseLink,
                                    prompt: Text(clothes.urlString).foregroundStyle(.labelInactive)
                                )
                                .negguFont(.body2)
                                
                                Button {
                                    
                                } label: {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(.black)
                                        .frame(width: 40, height: 40)
                                        .overlay {
                                            Image(systemName: "arrow.right")
                                                .foregroundStyle(.white)
                                        }
                                }
                            }
                            .padding(8)
                            .background {
                                RoundedRectangle(cornerRadius: 16)
                                    .strokeBorder(.lineAlt)
                            }
                            
                            TextField(
                                "",
                                text: $memoString,
                                prompt: Text("메모를 남겨보세요!").foregroundStyle(.labelInactive),
                                axis: .vertical
                            )
                            .negguFont(.body2)
                            .frame(minHeight: 48, alignment: .top)
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 16)
                                    .strokeBorder(.lineAlt)
                            }
                        }
                        .padding(.vertical, 32)
                        .padding(.horizontal, 28)
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.white)
                        }
                    } header: {
                        if Set(clothesName) != [" "] {
                            HStack {
                                Text(clothesName)
                                    .negguFont(.title3)
                                
                                Button {
                                    showNameEditView = true
                                } label: {
                                    Image(systemName: "pencil")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 18, height: 18)
                                }
                                
                                Spacer()
                            }
                            .padding(.vertical, 14)
                            .foregroundStyle(.labelNormal)
                            .background(.bgNormal)
                        }
                    }
                    .foregroundStyle(.black)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 56)
            }
        }
        .background(.bgNormal)
        .sheet(isPresented: $showNameEditView) {
            ClothesNameEditView(editedModelName: $editedModelName, clothesName: clothesName)
                .presentationBackground(.white)
                .presentationDetents([.height(430)])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(20)
        }
        .negguAlert(
            showAlert: $showAlert,
            title: "의상 등록을 그만둘까요?",
            description: "지금까지 편집한 내용은 저장되지 않습니다."
        ) {
            dismiss()
        }
    }
    
    private func validateField() {
        
    }
    
    var clothesName: String {
        brandName + " " + modelName
    }
    
    enum PriceRange: Selectable {
        case first
        case second
        case third
        case fourth
        
        var title: String {
            switch self {
            case .first: "잘 모르겠어요"
            case .second: "~5만원"
            case .third: "5~10만원"
            case .fourth: "10~20만"
            }
        }
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
