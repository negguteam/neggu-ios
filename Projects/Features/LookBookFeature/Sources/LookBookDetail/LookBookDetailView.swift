//
//  LookBookView.swift
//  neggu
//
//  Created by 유지호 on 10/13/24.
//

import Core
import NegguDS
import Domain

import BaseFeature

import SwiftUI

struct LookBookDetailView: View {
    @StateObject private var viewModel: LookBookDetailViewModel
    
    @State private var selectedDate: Date?
    
    @State private var showDateSheet: Bool = false
    @State private var showDeleteAlert: Bool = false
    @State private var showNegguInviteAlert: Bool = false
    
    private let lookBookID: String
    
    init(
        viewModel: LookBookDetailViewModel,
        lookBookID: String
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.lookBookID = lookBookID
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    viewModel.pop()
                } label: {
                    NegguImage.Icon.chevronLeft
                        .foregroundStyle(.labelNormal)
                        .frame(width: 44, height: 44)
                }
                
                Spacer()
                
                Text("코디")
                    .negguFont(.body1b)
                
                Spacer()

                Rectangle()
                    .fill(.clear)
                    .frame(width: 44, height: 44)
            }
            .frame(height: 44)
            .padding(.horizontal, 20)
            .background(.bgNormal)
            
            if let lookBook = viewModel.lookBookDetail {
                ScrollView {
                    VStack(spacing: 24) {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .aspectRatio(9/16, contentMode: .fit )
                            .overlay {
                                CachedAsyncImage(lookBook.imageUrl)
                            }
                            .overlay(alignment: .bottomTrailing) {
                                Button {
                                    showDateSheet = true
                                } label: {
                                    HStack(spacing: 4) {
                                        NegguImage.Icon.calendar
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
                                .padding(20)
                            }
                        
                        Text((lookBook.modifiedAt.toISOFormatDate()?.toLookBookDetailDateString() ?? "") + " 편집됨")
                            .negguFont(.caption)
                            .foregroundStyle(.black.opacity(0.2))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.horizontal, 20)
                        
                        VStack(spacing: 16) {
                            Text("의상")
                                .negguFont(.title3)
                                .foregroundStyle(.labelNormal)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            LazyVGrid(columns: [GridItem](repeating: GridItem(.flexible()), count: 4)) {
                                ForEach(lookBook.lookBookClothes) { clothes in
                                    Button {
                                        viewModel.presentClothesDetail(clothes.id)
                                    } label: {
                                        CachedAsyncImage(clothes.imageUrl)
                                            .aspectRatio(5/6, contentMode: .fit)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 32)
                        .background(.white)
                        .clipShape(.rect(cornerRadius: 16))
                        .padding(.horizontal, 20)
                        
                        HStack(spacing: 20) {
                            Button {
                                showDeleteAlert = true
                            } label: {
                                HStack {
                                    NegguImage.Icon.delete
                                        .frame(width: 24, height: 24)
                                    
                                    Text("삭제하기")
                                        .negguFont(.body2b)
                                }
                                .foregroundStyle(.systemWarning)
                                .padding(24)
                                .background {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(.white)
                                }
                            }
                            
                            Button {
                                Task {
                                    if let lookBookImage = await lookBook.imageUrl.toImage() {
                                        UIImageWriteToSavedPhotosAlbum(lookBookImage, nil, nil, nil)
                                        AlertManager.shared.setAlert(message: "이미지로 저장했습니다. 앨범을 확인해주세요.")
                                    } else {
                                        AlertManager.shared.setAlert(message: "이미지 저장에 실패했습니다. 다시 시도해주세요.")
                                    }
                                }
                            } label: {
                                HStack {
                                    NegguImage.Icon.gallery
                                        .frame(width: 24, height: 24)
                                    
                                    Text("저장하기")
                                        .negguFont(.body2b)
                                }
                                .foregroundStyle(.labelNormal)
                                .padding(24)
                                .background {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(.white)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 40)
                    }
                }
            } else {
                Color.clear
                    .overlay {
                        ProgressView()
                            .onAppear {
                                viewModel.viewDidAppear.send(lookBookID)
                                selectedDate = LookBookCalendarManager.shared.checkLookBook(lookBookID)
                            }
                    }
            }
            
            BannerViewContainer()
                .frame(height: 50)
        }
        .background(.bgNormal)
        .sheet(isPresented: $showDateSheet) {
            LookBookDateSheet(selectedDate: $selectedDate)
                .presentationCornerRadius(20)
        }
        .negguAlert(
            .delete(.lookBook),
            showAlert: $showDeleteAlert
        ) {
            viewModel.deleteButtonDidTap.send(lookBookID)
        }
        .onChange(of: selectedDate) { _, newValue in
            guard let lookBook = viewModel.lookBookDetail else { return }
            if let targetDate = newValue {
                LookBookCalendarManager.shared.addLookBook(lookBook, targetDate: targetDate)
                noticeLookBook(lookBook, targetDate: targetDate)
            } else {
                LookBookCalendarManager.shared.removeLookBook(id: lookBookID)
            }
        }
    }
    
    private func noticeLookBook(_ lookBook: LookBookEntity, targetDate: Date) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [lookBook.id])
        
        let content = UNMutableNotificationContent()
        content.title = "입을 예정인 코디가 있어요!"
        content.body = "코디 정보를 확인해보세요"
        content.sound = .default
        content.userInfo["lookBookID"] = lookBook.id
        content.userInfo["url"] = "neggu://lookBook/detail/\(lookBook.id)"
        
        let targetDateComponents = Calendar.current.dateComponents(
            [.year, .month, .day],
            from: targetDate
        )
        
        // TODO: 알림 시간 고민해보기
        let dateComponent = DateComponents(
            calendar: .init(identifier: .gregorian),
            timeZone: .init(identifier: "Asia/Seoul"),
            year: targetDateComponents.year,
            month: targetDateComponents.month,
            day: targetDateComponents.day,
            hour: 9
        )
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: lookBook.id,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
}
