//
//  ChartView.swift
//  Journal App
//
//  Created by Abhi B on 6/17/22.
//
//import Charts
//import SwiftUI
//
//struct ChartView: View {
//    @EnvironmentObject var vm : EntriesViewModel
//    var size : CGSize
//    var body: some View {
//        if #available(iOS 16.0, *) {
//            
//            Chart(vm.savedEntries){entry in
//                AreaMark (x: .value("date'", entry.date!),
//                          y: .value("moodNumber", Int(entry.moodNumber))
//                )
//                .foregroundStyle(Color.purple.gradient)
//            }
//            .padding()
//            .frame(width: size.width, height: size.height/6)
//        }
//    }
//}
