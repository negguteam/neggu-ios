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
    @State private var selectedDate: Date?
    
    @State private var showCalendar: Bool = false
    @State private var isNeggu: Bool = true
    @State private var isPublic: Bool = false
    
    @State private var sheetHeight: CGFloat = .zero
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(spacing: 32) {
                    Image("dummy_lookbook")
                        .resizable()
                        .scaledToFit()
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            showCalendar = true
                        } label: {
                            HStack(spacing: 0) {
                                Image(systemName: "calendar")
                                    .frame(width: 24, height: 24)
                                    .padding(.trailing, 4)
                                
                                if let selectedDate {
                                    Text(selectedDate.monthDayFormatted())
                                    Text("에 입을 예정")
                                        .foregroundStyle(.labelAlt)
                                } else {
                                    Text("입을 예정이신가요?")
                                }
                            }
                            .negguFont(.body2b)
                            .foregroundStyle(selectedDate == nil ? .labelInactive : .negguSecondary)
                            .frame(height: 60)
                            .padding(.horizontal, 12)
                            .background(.bgNormal)
                            .clipShape(.rect(cornerRadius: 16))
                        }
                    }
                }
                .padding(20)
                .frame(width: proxy.size.width, height: proxy.size.height * 0.9)
                .background(.white)
                .clipShape(.rect(cornerRadius: 20))
                .padding(.vertical, 12)
                
                VStack(spacing: 20) {
                    Text("2024년 12월 3일 편집됨")
                        .negguFont(.caption)
                        .foregroundStyle(.black.opacity(0.2))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.bottom, 10)
                    
                    if isNeggu {
                        HStack(spacing: 0) {
                            Image(systemName: "person.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(.negguSecondary)
                            
                            Group {
                                Text("네꾸ㅈㅈㅈㅈㅈㅈㅈㅈㅈㅈㅈㅈㅈㅈㅈㅈㅈㅈㅈㅈㅈ")
                                    .foregroundStyle(.negguSecondary)
                                    .lineLimit(1)
                                    .padding(.leading, 12)
                                
                                Text("님이 꾸며준 룩북이에요")
                                    .fixedSize()
                            }
                            .negguFont(.body2b)
                            
                            Spacer()
                            
                            Circle()
                                .frame(width: 36, height: 36)
                        }
                        .padding(12)
                        .background(.negguSecondaryAlt)
                        .clipShape(.rect(cornerRadius: 16))
                    }
                    
                    VStack {
                        Text("의상 자세히 보기")
                            .negguFont(.title3)
                            .foregroundStyle(.labelNormal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        LazyVGrid(columns: [GridItem](repeating: GridItem(.flexible()), count: 4)) {
                            ForEach(0...5, id: \.self) { index in
                                Button {
                                    clothes = .init(name: "옷\(index)", link: "", imageUrl: "", brand: "")
                                } label: {
                                    Image("dummy_clothes\(index % 3)")
                                        .resizable()
                                        .aspectRatio(0.8, contentMode: .fit)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 32)
                    .background(.white)
                    .clipShape(.rect(cornerRadius: 16))
                    
                    Toggle("다른사람에게 공개", isOn: $isPublic)
                        .negguFont(.body2b)
                        .foregroundStyle(.labelAssistive)
                        .tint(.safe)
                        .padding(12)
                        .background(.white)
                        .clipShape(.rect(cornerRadius: 16))
                    
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
                        .buttonStyle(.plain)
                        
                        Button {
                            
                        } label: {
                            HStack {
                                Image(systemName: "calendar")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                
                                Text("네가 좀 꾸며줘!")
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
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 90)
            }
            .scrollIndicators(.hidden)
            .background(.gray5)
        }
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
                        .negguFont(.body2b)
                    
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
        .sheet(isPresented: $showCalendar) {
            LookBookDateEditView(selectedDate: $selectedDate)
                .heightChangePreference { sheetHeight = $0 }
                .presentationDetents([.height(sheetHeight)])
                .presentationCornerRadius(20)
                .presentationBackground(Color.bgNormal)
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


struct SizeKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension View {
    
    func heightChangePreference(completion: @escaping (CGFloat) -> Void) -> some View {
        self.overlay {
            GeometryReader { proxy in
                Color.clear
                    .preference(key: SizeKey.self, value: proxy.size.height)
                    .onPreferenceChange(SizeKey.self, perform: completion)
            }
        }
    }
    
}
