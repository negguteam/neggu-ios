//
//  NegguTabBar.swift
//  neggu
//
//  Created by 유지호 on 9/5/24.
//

import SwiftUI

struct NegguTabBar: View {
    enum TabType {
        case `default`
        case clothes
        case lookbook
    }
    
    @Binding var selection: Int
    @Binding var showList: Bool
    
    @State private var tapType: TabType = .default
    
    @Namespace private var animation
    
    var body: some View {
        VStack(spacing: 8) {
            if showList {
                HStack(alignment: .top, spacing: 6) {
                    if tapType != .default {
                        Button {
                            tapType = .default
                        } label: {
                            Image(systemName: "chevron.left")
                                .frame(width: 24, height: 24)
                        }
                    }
                    
                    switch tapType {
                    case .default:
                        VStack(spacing: 16) {
                            Button {
                                tapType = .clothes
                            } label: {
                                HStack(spacing: 12) {
                                    Image(.shirtFill)
                                    
                                    Text("내 의상 등록하기")
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                }
                                .frame(height: 32)
                            }
                            
                            Rectangle()
                                .fill(.white.opacity(0.2))
                                .frame(height: 1)
                            
                            Button {
                                tapType = .lookbook
                            } label: {
                                HStack(spacing: 12) {
                                    Image(.closetFill)
                                    
                                    Text("룩북 등록하기")
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                }
                                .frame(height: 32)
                            }
                        }
                        .negguFont(.body1b)
                    case .clothes:
                        VStack(alignment: .leading, spacing: 16) {
                            Button {
                                
                            } label: {
                                HStack(spacing: 12) {
                                    Image(.link)
                                    
                                    Text("링크로 등록하기")
                                }
                                .frame(height: 24)
                                .padding(.leading, 18)
                            }
                            
                            Rectangle()
                                .fill(.white.opacity(0.2))
                                .frame(height: 1)
                            
                            Button {
                                
                            } label: {
                                HStack(spacing: 12) {
                                    Image(.camera)
                                    
                                    Text("지금 촬영하고 등록하기")
                                }
                                .frame(height: 24)
                                .padding(.leading, 18)
                            }
                            
                            Rectangle()
                                .fill(.white.opacity(0.2))
                                .frame(height: 1)
                            
                            Button {
                                
                            } label: {
                                HStack(spacing: 12) {
                                    Image(.gallery)
                                    
                                    Text("갤러리에서 등록하기")
                                }
                                .frame(height: 24)
                                .padding(.leading, 18)
                            }
                        }
                        .negguFont(.body2b)
                    case .lookbook:
                        VStack(alignment: .leading, spacing: 16) {
                            Color.clear
                                .frame(height: 32)
                            
                            Rectangle()
                                .fill(.white.opacity(0.2))
                                .frame(height: 1)
                            
                            Color.clear
                                .frame(height: 32)
                        }
                    }
                }
                .foregroundStyle(.labelRNormal)
                .padding(.horizontal, 36)
                .padding(.vertical, 28)
                .background(.negguSecondary)
                .clipShape(.rect(cornerRadius: 20))
            }
            
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
                                .frame(width: 24, height: 24)
                                .foregroundStyle(.white)
                        }
                        .background {
                            if selection == 0 {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.white.opacity(0.2))
                                    .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                            }
                        }
                }
                
                Button {
                    showList.toggle()
                    tapType = .default
                } label: {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(showList ? .orange40 : .gray70)
                        .frame(width: 48, height: 48)
                        .overlay {
                            Image(systemName: "plus")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(.labelRNormal)
                        }
                }
                
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
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.white.opacity(0.2))
                                    .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                            }
                        }
                }
            }
            .frame(height: 54)
            .padding(4)
            .background(.black.opacity(0.5))
            .background(.ultraThinMaterial)
            .clipShape(.rect(cornerRadius: 20))
        }
        .frame(width: 328)
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
