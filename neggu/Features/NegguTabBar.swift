//
//  NegguTabBar.swift
//  neggu
//
//  Created by 유지호 on 9/5/24.
//

import SwiftUI

struct NegguTabBar: View {
    @Namespace private var animation
    
    @Binding var selection: Int
    @Binding var showList: Bool
    
    @State private var scrollPosition: Int? = 0
    @State private var tapType: String = ""
    
    var body: some View {
        VStack(spacing: 8) {
            VStack(spacing: 0) {
                ScrollView(.horizontal) {
                    HStack(spacing: 0) {
                        VStack(spacing: 12) {
                            Button {
                                scrollPosition = 1
                                tapType = "closet"
                            } label: {
                                HStack(spacing: 12) {
                                    Image(.shirtFill)
                                    
                                    Text("내 의상 등록하기")
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                }
                            }
                            
                            Rectangle()
                                .fill(.white.opacity(0.2))
                                .frame(height: 1)
                            
                            Button {
                                scrollPosition = 1
                                tapType = "lookbook"
                            } label: {
                                HStack(spacing: 12) {
                                    Image(.closetFill)
                                    
                                    Text("룩북 등록하기")
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                }
                            }
                        }
                        .containerRelativeFrame(.horizontal, { length, _ in
                            length - 56
                        })
                        .padding(28)
                        .negguFont(.body1b)
                        .id(0)
                        
                        HStack(alignment: .top, spacing: 10) {
                            Button {
                                scrollPosition = 0
                                tapType = ""
                            } label: {
                                Image(systemName: "chevron.left")
                            }
                            .negguFont(.body1b)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                if tapType == "closet" {
                                    Button {
                                        
                                    } label: {
                                        Image(.link)
                                        
                                        Text("링크로 등록하기")
                                    }
                                    .padding(.horizontal, 22)
                                    
                                    Rectangle()
                                        .fill(.white.opacity(0.2))
                                        .frame(height: 1)
                                    
                                    Button {
                                        
                                    } label: {
                                        Image(.link)
                                        
                                        Text("지금 촬영하고 등록하기")
                                    }
                                    .padding(.horizontal, 22)
                                    
                                    Rectangle()
                                        .fill(.white.opacity(0.2))
                                        .frame(height: 1)
                                    
                                    Button {
                                        
                                    } label: {
                                        Image(.link)
                                        
                                        Text("갤러리에서 등록하기")
                                    }
                                    .padding(.horizontal, 22)
                                } else {
                                    Button {
                                        
                                    } label: {
                                        Text("네가 좀 꾸며줘")
                                    }
                                    .negguFont(.body1b)
                                    .padding(.horizontal, 22)

                                    Rectangle()
                                        .fill(.white.opacity(0.2))
                                        .frame(height: 1)
                                    
                                    Button {
                                        
                                    } label: {
                                        Text("내가 꾸며줄게")
                                    }
                                    .negguFont(.body1b)
                                    .padding(.horizontal, 22)
                                }
                            }
                        }
                        .containerRelativeFrame(.horizontal, { length, _ in
                            length - 56
                        })
                        .padding(28)
                        .negguFont(.body2b)
                        .id(1)
                    }
                }
                .frame(height: tapType == "closet" ? 200 : 152)
                .scrollDisabled(true)
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.paging)
                .scrollPosition(id: $scrollPosition)
            }
            .negguFont(.body2b)
            .foregroundStyle(.white)
            .background(.orange40)
            .clipShape(.rect(cornerRadius: 20))
            .opacity(showList ? 1 : 0)
            
            RoundedRectangle(cornerRadius: 20)
                .fill(.black.opacity(0.5))
                .background(.ultraThinMaterial)
                .clipShape(.rect(cornerRadius: 20))
                .overlay {
                    HStack(spacing: 16) {
                        Button {
                            guard selection != 0 && !showList else {
                                showList = false
                                return
                            }
                            
                            selection = 0
                        } label: {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.clear)
                                .overlay {
                                    Image(selection == 0 ? .shirtFill : .shirt)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 24, height: 24)
                                        .foregroundStyle(.white)
                                }
                                .background {
                                    if selection == 0 {
                                        Color.white.opacity(0.2)
                                            .clipShape(.rect(cornerRadius: 16))
                                            .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                                    }
                                }
                                .contentShape(.rect(cornerRadius: 16))
                                .padding([.leading, .vertical], 4)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Button {
                            withAnimation {
                                showList.toggle()
                            }
                        } label: {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(showList ? .orange40 : .gray70)
                                .clipShape(.rect(cornerRadius: 16))
                                .frame(width: 48, height: 48)
                                .overlay {
                                    Image(systemName: "plus")
                                        .resizable()
                                        .foregroundStyle(.white)
                                        .frame(width: 24, height: 24)
                                }
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Button {
                            guard selection != 1 && !showList else {
                                showList = false
                                return
                            }
                            
                            selection = 1
                        } label: {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.clear)
                                .overlay {
                                    Image(selection == 1 ? .closetFill : .closet)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 24, height: 24)
                                        .foregroundStyle(.white)
                                }
                                .background {
                                    if selection == 1 {
                                        Color.white.opacity(0.2)
                                            .clipShape(.rect(cornerRadius: 16))
                                            .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                                    }
                                }
                                .contentShape(.rect(cornerRadius: 16))
                                .padding([.trailing, .vertical], 4)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .frame(height: 64)
        }
        .padding(.horizontal, 51)
    }
}

struct HideTabBar: UIViewRepresentable {
    var result: () -> Void
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        
        DispatchQueue.main.async {
            if let tabController = view.tabController {
                tabController.tabBar.isHidden = true
                result()
            }
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) { }
}

extension UIView {
    
    var tabController: UITabBarController? {
        if let controller = sequence(first: self, next: { $0.next }).first(where: { $0 is UITabBarController }) as? UITabBarController {
            return controller
        }
        
        return nil
    }
    
}


#Preview {
    ContentView()
}
