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
    
    var body: some View {
        VStack(spacing: 8) {
            VStack(spacing: 0) {
                Button {
                    withAnimation {
                        showList = false
                        selection = 0
                    }
                } label: {
                    HStack {
                        Text("내 의상 등록하기")
                            .contentShape(.rect)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Image(systemName: "chevron.right")
                    }
                }
                .padding([.horizontal, .top])
                
                Rectangle()
                    .fill(.white.opacity(0.2))
                    .frame(height: 1)
                    .padding()
                
                Button {
                    withAnimation {
                        showList = false
                        selection = 0
                    }
                } label: {
                    HStack {
                        Text("룩북 등록하기")
                            .contentShape(.rect)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Image(systemName: "chevron.right")
                    }
                }
                .padding([.horizontal, .bottom])
            }
            .negguFont(.body2b)
            .foregroundStyle(.white)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.orange40)
            }
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
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.clear)
                                .overlay {
                                    Image(systemName: "cabinet")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 24, height: 24)
                                        .foregroundStyle(.white)
                                }
                                .background {
                                    if selection == 0 {
                                        Color.white.opacity(0.2)
                                            .clipShape(.rect(cornerRadius: 20))
                                            .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                                    }
                                }
                                .contentShape(.rect(cornerRadius: 20))
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
                                        .padding(10)
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
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.clear)
                                .overlay {
                                    Image(systemName: "person")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 24, height: 24)
                                        .foregroundStyle(.white)
                                }
                                .background {
                                    if selection == 1 {
                                        Color.white.opacity(0.2)
                                            .clipShape(.rect(cornerRadius: 20))
                                            .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                                    }
                                }
                                .contentShape(.rect(cornerRadius: 20))
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
    NegguTabBar(selection: .constant(0), showList: .constant(true))
}
