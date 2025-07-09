//
//  LookBookMainView.swift
//  LookBookFeature
//
//  Created by 유지호 on 7/2/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import Core
import NegguDS

import SwiftUI

struct LookBookMainView: View {
    @StateObject private var viewModel: LookBookMainViewModel
    
    init(viewModel: LookBookMainViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 20) {
                Spacer()
                
                Button {
                    viewModel.pushSetting()
                } label: {
                    NegguImage.Icon.setting
                        .foregroundStyle(.labelNormal)
                        .frame(width: 44)
                }
            }
            .frame(height: 44)
            .padding(.horizontal, 20)
            
            ScrollViewReader { scrollProxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 32) {
                        if let profile = viewModel.userProfile {
                            VStack(alignment: .leading, spacing: 16) {
                                UserProfileHeader(profile: profile)
                                
                                HStack(spacing: 14) {
                                    Button {
                                        viewModel.switchTab(.closet)
                                    } label: {
                                        HStack {
                                            NegguImage.Icon.shirtFill
                                                .frame(width: 24, height: 24)
                                                .foregroundStyle(.labelNormal)
                                            
                                            Text("의상")
                                                .negguFont(.body3)
                                                .foregroundStyle(.labelNormal)
                                            
                                            Spacer()
                                            
                                            Text("\(profile.clothes.count)벌")
                                                .negguFont(.body2b)
                                                .foregroundStyle(.labelAlt)
                                        }
                                        .padding(24)
                                        .frame(maxWidth: .infinity)
                                        .background {
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(.white)
                                        }
                                    }
                                    
                                    Button {
                                        withAnimation(.smooth) {
                                            scrollProxy.scrollTo("LookBook", anchor: .top)
                                        }
                                    } label: {
                                        HStack {
                                            NegguImage.Icon.closetFill
                                                .frame(width: 24, height: 24)
                                                .foregroundStyle(.labelNormal)
                                            
                                            Text("룩북")
                                                .negguFont(.body3)
                                                .foregroundStyle(.labelNormal)
                                            
                                            Spacer()
                                            
                                            Text("\(profile.lookBooks.count)개")
                                                .negguFont(.body2b)
                                                .foregroundStyle(.labelAlt)
                                        }
                                        .padding(24)
                                        .frame(maxWidth: .infinity)
                                        .background {
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(.white)
                                        }
                                    }
                                }
                            }
                        } else {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                        }
                        
                        VStack(spacing: 48) {
                            lookBookCalendarSection
                            
                            lookBookListSection
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top)
                    .padding(.bottom, 80)
                }
            }
        }
        .background(.bgNormal)
        .refreshable {
            viewModel.lookBookDidRefresh.send(())
        }
        .onAppear {
            viewModel.viewDidAppear.send(())
        }
    }
    
    private var lookBookCalendarSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("코디 일정")
                .negguFont(.title3)
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: 12) {
                    if viewModel.lookBookCalenar.isEmpty {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.clear)
                            .strokeBorder(
                                .lineAlt,
                                style: StrokeStyle(lineWidth: 2, dash: [4, 4])
                            )
                            .aspectRatio(9/16, contentMode: .fit)
                            .overlay {
                                Text(viewModel.lookBookList.isEmpty ? "코디를\n등록해볼까요?" : "코디 일정을\n설정해볼까요?")
                                    .negguFont(.body3)
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(.labelAssistive)
                            }
                    }
                        
                    ForEach(viewModel.lookBookCalenar) { item in
                        Button {
                            viewModel.pushDetail(id: item.id)
                        } label: {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.white)
                                .aspectRatio(9/16, contentMode: .fit)
                                .overlay {
                                    CachedAsyncImage(item.lookBook.imageUrl)
                                }
                                .overlay(alignment: .topTrailing) {
                                    let (dateString, color) = item.targetDate.generateLookBookDate()
                                    
                                    Text(dateString)
                                        .negguFont(.caption)
                                        .foregroundStyle(.white)
                                        .padding(.horizontal, 8)
                                        .frame(height: 24)
                                        .background {
                                            UnevenRoundedRectangle(
                                                topLeadingRadius: 8,
                                                bottomLeadingRadius: 8,
                                                topTrailingRadius: 8
                                            )
                                            .fill(color)
                                        }
                                }
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .scrollClipDisabled()
            .frame(height: 160)
        }
    }
    
    private var lookBookListSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let profile = viewModel.userProfile {
                Text(profile.nickname + "의 룩북")
                    .negguFont(.title3)
                    .lineLimit(1)
                    .id("LookBook")
            } else {
                Text("나의 룩북")
                    .negguFont(.title3)
                    .id("LookBook")
            }
            
            LazyVGrid(
                columns: [GridItem](repeating: .init(.flexible(), spacing: 12), count: 2),
                spacing: 12
            ) {
                ForEach(viewModel.lookBookList) { lookBook in
                    Button {
                        viewModel.pushDetail(id: lookBook.id)
                    } label: {
                        LookBookCell(lookBook: lookBook)
                    }
                    .onAppear {
                        guard let last = viewModel.lookBookList.last,
                              lookBook.id == last.id
                        else { return }
                        
                        viewModel.lookBookDidScroll.send(())
                    }
                }
            }
        }
    }
    
    func generateLookBookDate(_ date: Date) -> (String, Color) {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        
        let today = calendar.startOfDay(for: Date.now)
        let twoDaysAfter = calendar.date(byAdding: .day, value: 2, to: Date.now.yearMonthDay())!
        var week: [Date] = []
        
        if let weekInterval = calendar.dateInterval(of: .weekOfYear, for: today) {
            for i in 0...6 {
                if let day = calendar.date(byAdding: .day, value: i, to: weekInterval.start) {
                    week += [day]
                }
            }
        }
        
        if date.yearMonthDay() == Date.now.yearMonthDay() {
            return ("오늘", .negguSecondary)
        } else if date.yearMonthDay() <= twoDaysAfter {
            let dayString = date.yearMonthDay().toRelativeFormatString()
            return (dayString, .labelNormal)
        } else if week.contains(date.yearMonthDay()) {
            return (date.daySymbol(), .labelNormal)
        } else {
            return (date.monthDayFormatted(), NegguDSAsset.Colors.gray50.swiftUIColor)
        }
    }
}

public extension Date {
    
    func generateLookBookDate() -> (String, Color) {
        let twoDaysAfter = Calendar.current.date(byAdding: .day, value: 2, to: Date.now.yearMonthDay())!
        
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        let today = calendar.startOfDay(for: Date.now)
        var week: [Date] = []
        
        if let weekInterval = calendar.dateInterval(of: .weekOfYear, for: today) {
            for i in 0...6 {
                if let day = calendar.date(byAdding: .day, value: i, to: weekInterval.start) {
                    week += [day]
                }
            }
        }
        
        if self.yearMonthDay() == Date.now.yearMonthDay() {
            return ("오늘", .negguSecondary)
        } else if self.yearMonthDay() <= twoDaysAfter {
            let dayString = self.yearMonthDay().toRelativeFormatString()
            return (dayString, .labelNormal)
        } else if week.contains(self.yearMonthDay()) {
            return (self.daySymbol(), .labelNormal)
        } else {
            return (self.monthDayFormatted(), NegguDSAsset.Colors.gray50.swiftUIColor)
        }
    }
    
}
