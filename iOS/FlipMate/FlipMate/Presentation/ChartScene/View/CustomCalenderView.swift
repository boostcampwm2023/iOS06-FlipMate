//
//  CustomCalenderView.swift
//  FlipMate
//
//  Created by 신민규 on 12/5/23.
//

import SwiftUI

struct CustomCalenderView: View {
    @Binding var selectedDate: Date
    @ObservedObject var viewModel: ChartViewModel
    @State private var todayIndex: Int?
    @Environment(\.colorScheme) var colorScheme
    private let calendar = Calendar.current

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            if #available(iOS 15.0, *) {
                monthView
                ZStack {
                    dayView
                    blurView
                }
                .frame(height: 30)
                .padding(.horizontal, 25)
            }
        }
        .onAppear {
            Task {
                try await viewModel.fetchTodayData()
                selectedDate = Date()
            }
        }
        .onChange(of: selectedDate) { newDate in
            Task {
                try await viewModel.selectedDateDidChange(newDate: newDate)
            }
        }
    }
    
    @available(iOS 15.0, *)
    private var monthView: some View {
        HStack(spacing: 20) {
            Button(action: {
                changeMonth(-1)
            }, label: {
                Image(systemName: "chevron.left")
                    .padding()
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                }
            )
            
            Text(monthTitle(from: selectedDate))
                .font(.title)
            
            Button(action: {
                changeMonth(1)
            }, label: {
                Image(systemName: "chevron.right")
                    .padding()
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                }
            )
        }
    }
    
    @ViewBuilder
    private var dayView: some View {
        // swiftlint:disable force_unwrapping
        let today = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: selectedDate))!
        
        ScrollViewReader { scrollView in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    let components = (0..<calendar.range(of: .day, in: .month, for: today)!.count)
                        .map {
                            calendar.date(byAdding: .day, value: $0, to: today)!
                        }
                    
                    ForEach(components.indices, id: \.self) { index in
                        VStack {
                            Text(day(from: components[index]))
                                .font(.caption)
                                .id(index)
                            Text("\(calendar.component(.day, from: components[index]))")
                        }
                        .frame(width: 30, height: 30)
                        .padding(5)
                        .background(calendar.isDate(selectedDate, equalTo: components[index], toGranularity: .day) ?
                                    (colorScheme == .dark ? .white : .darkBlue) : Color.clear)
                        .cornerRadius(16)
                        .foregroundColor(calendar.isDate(selectedDate, equalTo: components[index], toGranularity: .day) ? 
                                         (colorScheme == .dark ? .black : .white) :
                                            (colorScheme == .dark ? .white : .black))
                        .onTapGesture {
                            selectedDate = components[index]
                            
                        }
                    }
                }
            }
            .padding(.leading, 15)
            .padding(.trailing, 15)
            .onAppear {
                scrollView.scrollTo((calendar.dateComponents([.day], from: Date()).day ?? 1) - 1)
            }
        }
        // swiftlint:enable force_unwrapping
    }
    
    private var blurView: some View {
        HStack {
            LinearGradient(gradient: 
                            Gradient(colors: [(colorScheme == .dark ? Color.black.opacity(1) : Color.white.opacity(1)), 
                                              (colorScheme == .dark ? Color.black.opacity(0) : Color.white.opacity(0))]),
                           startPoint: .leading, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
                .frame(width: 20)
                .edgesIgnoringSafeArea(.leading)
            
            Spacer()
            
            LinearGradient(gradient: 
                            Gradient(colors: [(colorScheme == .dark ? Color.black.opacity(1) : Color.white.opacity(1)),
                                                       (colorScheme == .dark ? Color.black.opacity(0) : Color.white.opacity(0))]), 
                           startPoint: .trailing, endPoint: .leading)
                .frame(width: 20)
                .edgesIgnoringSafeArea(.leading)
        }
    }
}

private extension CustomCalenderView {
    func monthTitle(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("yyyy MMM")
        return dateFormatter.string(from: date)
    }
    
    func changeMonth(_ value: Int) {
        guard let date = calendar.date(byAdding: .month, value: value, to: selectedDate) else { return }
        selectedDate = date
    }
    
    func day(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("E")
        return dateFormatter.string(from: date)
    }
}
