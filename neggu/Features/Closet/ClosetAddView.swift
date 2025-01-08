//
//  ClosetAddView.swift
//  neggu
//
//  Created by 유지호 on 9/30/24.
//

import SwiftUI

struct ClosetAddView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var clothes: Clothes
    @State private var clothesColor: UIColor = .clear
    @State private var editedModelName: String = ""
    
    @State private var showNameEditView: Bool = false
    @State private var showAlert: Bool = false
    
    @FocusState private var isFocused: Bool
    
    private let segmentedImage: UIImage
    
    init(clothes: Clothes, segmentedImage: UIImage) {
        self.clothes = clothes
        self.segmentedImage = segmentedImage
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                
                Button {
                    showAlert = true
                } label: {
                    Image(systemName: "multiply")
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.labelNormal)
                }
            }
            .frame(height: 40)
            .padding(.horizontal, 20)
            
            ScrollView {
                Image(uiImage: segmentedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 366)
//                    .overlay(alignment: .bottomTrailing) {
//                        Color(uiColor: clothesColor)
//                            .frame(width: 30, height: 30)
//                            .clipShape(.circle)
//                    }
                    .padding(.bottom, 20)
                
                LazyVStack(
                    spacing: 20,
                    pinnedViews: [.sectionHeaders]
                ) {
                    Section {
                        TitleForm("어떤 종류의 옷인가요?") {
                            Menu {
                                ForEach(Category.allCasesArray) { category in
                                    Button(category.rawValue) {
                                        clothes.category = category
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(clothes.category == .unknown ? "옷의 종류" : clothes.category.rawValue)
                                        .negguFont(.body2b)
                                        .foregroundStyle(clothes.category == .unknown ? .labelInactive : .labelNormal)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                }
                                .padding()
                                .background() {
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(clothes.category == .unknown ? .warning : .lineAlt)
                                }
                            }
                            
                            if clothes.category == .unknown {
                                Text("옷의 종류를 알려주세요!")
                                    .negguFont(.body2)
                                    .foregroundStyle(.warning)
                            }
                            
                            Menu {
                                ForEach(Mood.allCasesArray) { mood in
                                    Button(mood.rawValue) {
                                        clothes.mood = mood
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(clothes.mood == .unknown ? "옷의 분위기" : clothes.mood.rawValue)
                                        .negguFont(.body2b)
                                        .foregroundStyle(clothes.mood == .unknown ? .labelInactive : .labelNormal)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                }
                                .padding()
                                .background() {
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(clothes.mood == .unknown ? .warning : .lineAlt)
                                }
                            }
                            
                            if clothes.mood == .unknown {
                                Text("옷의 분위기를 알려주세요!")
                                    .negguFont(.body2)
                                    .foregroundStyle(.warning)
                            }
                        }
                        
                        TitleForm("어느 브랜드인가요?") {
                            HStack {
                                Text(clothes.brand.isEmpty ? "옷의 종류" : clothes.brand)
                                    .negguFont(.body2b)
                                    .foregroundStyle(clothes.brand.isEmpty ? .labelInactive : .labelNormal)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.down")
                            }
                            .padding()
                            .background() {
                                RoundedRectangle(cornerRadius: 16)
                                    .strokeBorder(.lineAlt)
                            }
                        }
                        
                        TitleForm("얼마인가요?") {
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(PriceRange.allCases, id: \.self) { select in
                                        let isSelected = clothes.priceRange == select
                                        
                                        BorderedChip(title: select.rawValue, isSelected: isSelected)
                                            .onTapGesture {
                                                clothes.priceRange = select
                                            }
                                    }
                                }
                                .padding(.horizontal, 28)
                            }
                            .scrollIndicators(.hidden)
                            .padding(.horizontal, -28)
                        }
                        
                        TitleForm("어디서 구매하나요?") {
                            HStack(spacing: 18) {
                                Button {
                                    clothes.isPurchase = true
                                } label: {
                                    BorderedRectangle("구매함", isSelected: clothes.isPurchase)
                                }
                                
                                Button {
                                    clothes.isPurchase = false
                                } label: {
                                    BorderedRectangle("구매하지 않음", isSelected: !clothes.isPurchase)
                                }
                            }
                            
                            HStack(spacing: 16) {
                                Image(.link)
                                    .foregroundStyle(.labelAssistive)
                                    .padding(.leading, 12)
                                
                                TextField(
                                    "",
                                    text: $clothes.link,
                                    prompt: Text(clothes.link).foregroundStyle(.labelInactive)
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
                            
                            ExpendableTextView("메모를 남겨보세요!", text: $clothes.memo)
                                .focused($isFocused)
                                .toolbar {
                                    ToolbarItemGroup(placement: .keyboard) {
                                        Spacer()
                                        
                                        Button("완료") {
                                            isFocused = false
                                        }
                                    }
                                }
                        }
                        
                        Button {
                            clothes.name = editedModelName
                            debugPrint(clothes)
                        } label: {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.negguSecondary)
                                .frame(height: 56)
                                .overlay {
                                    Text("저장하기")
                                        .negguFont(.body2b)
                                        .foregroundStyle(.white)
                                }
                        }
                        .padding(.horizontal, 28)
                        .padding(.top, 56)
                    } header: {
                        if !editedModelName.isEmpty {
                            HStack {
                                Button {
                                    showNameEditView = true
                                } label: {
                                    Text(editedModelName)
                                        .negguFont(.title3)
                                        .lineLimit(1)
                                    
                                    Image(systemName: "pencil")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 24, height: 24)
                                }
                                
                                Spacer()
                            }
                            .frame(height: 48)
                            .padding(.horizontal, 14)
                            .background(.bgNormal)
                        }
                    }
                    .foregroundStyle(.labelNormal)
                }
                .padding(.horizontal, 20)
            }
            .scrollIndicators(.hidden)
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
        .onAppear {
            getMostColor()
        }
        .onChange(of: clothes) { _, newValue in
            editedModelName = [
                newValue.brand,
                (newValue.colorCode ?? "").uppercased(),
                newValue.subCategory == .unknown ? newValue.category.rawValue : newValue.subCategory.rawValue
            ].filter { !$0.isEmpty }.joined(separator: " ")
        }
    }
    
    private func validateField() {
        
    }
    
    private func getMostColor() {
        guard let color = segmentedImage.pixelColor(),
              let hexString = color.toHex()
        else { return }
        
        clothesColor = color
        clothes.colorCode = hexString
    }
}

#Preview {
    ClosetAddView(
        clothes: .init(
            name: "dummy clothes",
            link: "https://www.neggu.com",
            imageUrl: "",
            brand: "neggu"
        ),
        segmentedImage: .bannerBG1
    )
}


import CoreImage

extension UIImage {
        
    func pixelColor() -> UIColor? {
        guard let cgImage = self.cgImage else { return nil }
        
        let width = 80
        let height = 80
//        let width = cgImage.width
//        let height = cgImage.height
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue
        
        guard let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width * 4,
            space: colorSpace,
            bitmapInfo: bitmapInfo
        ) else { return nil }

        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let pixelBuffer = context.data else { return nil }
        
        let pointer = pixelBuffer.bindMemory(to: UInt32.self, capacity: width * height)
        
        var colorDict: [UIColor: Int] = [:]
        
        for x in 0 ..< width {
            for y in 0 ..< height {
                let pixel = pointer[(y * width) + x]
                
                let r = CGFloat(red(for: pixel)) / 255.0
                let g = CGFloat(green(for: pixel)) / 255.0
                let b = CGFloat(blue(for: pixel)) / 255.0
                let alpha = CGFloat(alpha(for: pixel)) / 255.0
                                
                if r > 0.1 && g > 0.1 && b > 0.1 && alpha > 0 {
                    let color = UIColor(
                        red: r,
                        green: g,
                        blue: b,
                        alpha: alpha
                    )
                    
                    colorDict[color, default: 0] += 1
                }
            }
        }
        
        guard let mostColor = colorDict.max(by: { $0.value < $1.value })?.key else { return nil }
        return mostColor
    }
    
    func red(for color: UInt32) -> UInt8 {
        return UInt8((color >> 16) & 255)
    }

    func green(for color: UInt32) -> UInt8 {
        return UInt8((color >> 8) & 255)
    }

    func blue(for color: UInt32) -> UInt8 {
        return UInt8((color >> 0) & 255)
    }
    
    func alpha(for color: UInt32) -> UInt8 {
        return UInt8((color >> 24) & 255)
    }
    
}


extension UIColor {
    
    func toHex(includeAlpha: Bool = false) -> String? {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        guard self.getRed(&r, green: &g, blue: &b, alpha: &a) else {
            return nil
        }
        
        let rgb: Int = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255) << 0
        return String(format: "#%06x", rgb)
    }
    
}
