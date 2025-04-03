//
//  LookBookView.swift
//  neggu
//
//  Created by 유지호 on 10/13/24.
//

import SwiftUI
import Combine

struct LookBookDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var lookBookState: LookBookState = .loading
    
    @State private var selectedDate: Date?
    
    @State private var showCalendar: Bool = false
    @State private var isNeggu: Bool = true
    @State private var isPublic: Bool = false
    
    @State private var sheetHeight: CGFloat = .zero
    
    @State private var bag = Set<AnyCancellable>()
    
    @State private var showLookBookEditView: Bool = false
    
    let lookBookID: String
    let service: LookBookService = DefaultLookBookService()
    
    var body: some View {
        VStack(spacing: 0) {
            switch lookBookState {
            case .loading:
                ProgressView()
                    .onAppear {
                        service.lookbookDetail(id: lookBookID)
                            .sink { event in
                                print("LookBookDetailView:", event)
                            } receiveValue: { lookBook in
                                lookBookState = .complete(lookBook: lookBook)
                            }.store(in: &bag)
                    }
            case .complete(let lookBook):
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(.chevronLeft)
                            .foregroundStyle(.labelNormal)
                            .frame(width: 44, height: 44)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 12) {
                        Text("데이트룩")
                            .negguFont(.body1b)
                        
                        Button {
                            
                        } label: {
                            Image(.edit)
                                .frame(width: 24, height: 24)
                        }
                    }
                    .foregroundStyle(.labelNormal)
                    
                    Spacer()
                    
                    Menu {
                        Button("이미지로 저장하기") {
                            
                        }
                        
                        Button("편집하기") {
                            showLookBookEditView = true
                        }
                        
                        Button("삭제하기", role: .destructive) {
                            
                        }
                    } label: {
                        Image(.hamburgerHorizontal)
                            .foregroundStyle(.labelNormal)
                            .frame(width: 44, height: 44)
                    }
                }
                .frame(height: 44)
                .padding(.horizontal, 20)
                .background(.bgNormal)
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack {
                            AsyncImage(url: URL(string: lookBook.imageUrl)) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                            } placeholder: {
                                Color.clear
                                    .overlay {
                                        ProgressView()
                                    }
                            }
                            .frame(maxHeight: .infinity)
                            
                            HStack {
                                if isNeggu {
                                    HStack(spacing: 12) {
                                        Circle()
                                            .frame(width: 36, height: 36)
                                        
                                        HStack(spacing: 0) {
                                            Text("네꾸ㅈㅈㅈㅈㅈㅈㅈㅈㅈㅈㅈㅈㅈㅈㅈㅈㅈㅈㅈㅈㅈ")
                                                .foregroundStyle(.negguSecondary)
                                                .lineLimit(1)
                                            
                                            Text("님이 꾸며줬어요")
                                                .fixedSize()
                                        }
                                        .negguFont(.body2b)
                                    }
                                    .frame(height: 56)
                                    .padding(.horizontal, 14)
                                    .background(.bgNormal)
                                    .clipShape(.rect(cornerRadius: 16))
                                }
                                
                                Button {
                                    showCalendar = true
                                } label: {
                                    HStack(spacing: 4) {
                                        Image(.calendar)
                                            .frame(width: 24, height: 24)
                                        
                                        if let selectedDate {
                                            Text(selectedDate.monthDayFormatted())
                                        }
                                    }
                                    .negguFont(.body2b)
                                    .foregroundStyle(selectedDate == nil ? .labelInactive : .negguSecondary)
                                    .padding(.horizontal, 12)
                                    .frame(width: selectedDate == nil ? 56 : nil, height: 56)
                                    .background(.bgNormal)
                                    .clipShape(.rect(cornerRadius: 16))
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 24)
                        .containerRelativeFrame(.horizontal)
                        .containerRelativeFrame(.vertical) { length, _ in length * 0.9 }
                        .background(.white)
                        .clipShape(.rect(cornerRadius: 20))
                        
                        VStack(spacing: 24) {
                            Text((lookBook.modifiedAt.toISOFormatDate()?.toLookBookDetailDateString() ?? "") + " 편집됨")
                                .negguFont(.caption)
                                .foregroundStyle(.black.opacity(0.2))
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            
                            VStack {
                                Text("더보기")
                                    .negguFont(.title3)
                                    .foregroundStyle(.labelNormal)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                LazyVGrid(columns: [GridItem](repeating: GridItem(.flexible()), count: 4)) {
                                    ForEach(lookBook.lookBookClothes) { clothes in
                                        Button {

                                        } label: {
                                            AsyncImage(url: URL(string: clothes.imageUrl)) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                            } placeholder: {
                                                ProgressView()
                                            }
                                            .aspectRatio(0.8, contentMode: .fit)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 28)
                            .padding(.vertical, 32)
                            .background(.white)
                            .clipShape(.rect(cornerRadius: 16))
                            
                            Toggle("다른사람에게 공개", isOn: $isPublic)
                                .negguFont(.body2b)
                                .foregroundStyle(.labelAssistive)
                                .tint(.safe)
                                .padding(.horizontal, 28)
                                .padding(.vertical, 10)
                                .background(.white)
                                .clipShape(.rect(cornerRadius: 16))
                            
                            HStack {
                                Button {
                                    
                                } label: {
                                    Image(.share)
                                        .foregroundStyle(.white)
                                        .frame(width: 56, height: 56)
                                        .background {
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(.black)
                                        }
                                }
                                
                                Button {
                                    
                                } label: {
                                    HStack(spacing: 10) {
                                        Image("neggu_star")
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
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(.negguSecondary)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }
                    .padding(.top, 12)
                }
                .scrollIndicators(.hidden)
                .background(.bgNormal)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $showCalendar) {
            LookBookDateEditView(selectedDate: $selectedDate)
                .heightChangePreference { sheetHeight = $0 }
                .presentationDetents([.height(sheetHeight)])
                .presentationCornerRadius(20)
                .presentationBackground(.bgNormal)
        }
    }
    
    enum LookBookState {
        case loading
        case complete(lookBook: LookBookEntity)
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
