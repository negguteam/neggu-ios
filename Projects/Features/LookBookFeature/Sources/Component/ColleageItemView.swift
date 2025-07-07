//
//  ColleageItemView.swift
//  neggu
//
//  Created by 유지호 on 4/15/25.
//

import Core
import NegguDS

import SwiftUI

struct ColleageItemView: View {
    @Binding var editingClothes: String
    @Binding var selectedClothes: [LookBookClothesItem]
    @Binding var clothes: LookBookClothesItem
    
    private let containerSize: CGSize
    private let baseSize: CGSize
    
    init(
        proxy: GeometryProxy,
        editingClothes: Binding<String>,
        selectedClothes: Binding<[LookBookClothesItem]>,
        clothes: Binding<LookBookClothesItem>
    ) {
        self.containerSize = proxy.size
        self.baseSize = CGSize(width: containerSize.width / 2, height: containerSize.height / 3)
        self._editingClothes = editingClothes
        self._selectedClothes = selectedClothes
        self._clothes = clothes
    }
    
    var body: some View {
        Group {
            if let image = clothes.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                Color.clear
                    .overlay {
                        ProgressView()
                    }
            }
        }
        .frame(
            width: baseSize.width * clothes.scale,
            height: baseSize.height * clothes.scale
        )
        .rotationEffect(clothes.angle)
        .overlay {
            GeometryReader {
                let size = $0.size
                
                if editingClothes == clothes.id {
                    RoundedRectangle(cornerRadius: 18)
                        .strokeBorder(
                            .black,
                            style: StrokeStyle(
                                lineWidth: 2,
                                dash: [4, 4]
                            )
                        )
                        .frame(width: size.width, height: size.height)
                        .rotationEffect(clothes.angle)
                    
                    Circle()
                        .fill(.systemWarning)
                        .frame(width: 30, height: 30)
                        .overlay {
                            NegguImage.Icon.delete
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18)
                                .foregroundStyle(.white)
                        }
                        .position(x: size.width, y: 0)
                        .rotationEffect(clothes.angle)
                        .onTapGesture {
                            selectedClothes.removeAll(where: { $0.id == clothes.id })
                            editingClothes = ""
                        }
                    
                    Circle()
                        .fill(.negguPrimary)
                        .frame(width: 30, height: 30)
                        .overlay {
                            NegguImage.Icon.resize
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(.white)
                        }
                        .position(x: size.width, y: size.height)
                        .rotationEffect(clothes.angle)
                        .gesture(scaleWithRotation(proxy: $0))
                }
            }
        }
        .offset(calculateOffset(clothes.offset))
        .zIndex(clothes.zIndex)
        .gesture(drag())
    }
        
    private func drag() -> some Gesture {
        DragGesture()
            .onChanged { value in
                guard editingClothes == clothes.id else { return }
                clothes.offset = clothes.lastOffset + value.translation
            }
            .onEnded { _ in
                clothes.lastOffset = clothes.offset
            }
    }
    
    private func scaleWithRotation(proxy: GeometryProxy) -> some Gesture {
        DragGesture()
            .onChanged { value in
                let center = CGPoint(x: proxy.size.width / 2, y: proxy.size.height / 2)
                let current = value.location
                
                let dx = current.x - center.x
                let dy = current.y - center.y
                let currentVector = CGVector(dx: dx, dy: dy)
                
                guard let startVector = clothes.startVector else {
                    clothes.startVector = currentVector
                    clothes.startDistance = distance(vector: currentVector) / clothes.scale
                    return
                }
                
                let currentDistance = distance(vector: currentVector)
                let scaleRatio = currentDistance / clothes.startDistance
                
                clothes.scale = max(0.5, min(scaleRatio, 2.0))
                
                let angle1 = atan2(startVector.dy, startVector.dx)
                let angle2 = atan2(currentVector.dy, currentVector.dx)

                let deltaAngle = angle2 - angle1
                var newDegrees = clothes.lastAngle.degrees + Angle(radians: deltaAngle).degrees
                
                if newDegrees < 0 {
                    newDegrees += 360
                }
                
                if newDegrees >= 360 {
                    newDegrees -= 360
                }
                
                clothes.angle = Angle(degrees: newDegrees)
            }
    }
    
    private func calculateOffset(_ offset: CGSize) -> CGSize {
        return CGSize(
            width: offset.width - containerSize.width / 2 + baseSize.width / 2,
            height: offset.height - containerSize.height / 2 + baseSize.height / 2
        )
    }
    
    private func distance(vector: CGVector) -> CGFloat {
        sqrt(vector.dx * vector.dx + vector.dy * vector.dy)
    }
}
