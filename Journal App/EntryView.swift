//
//  EntryView.swift
//  Journal App
//
//  Created by Abhi B on 6/14/22.
//

import SwiftUI

struct EntryView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var vm : EntriesViewModel
    @State private var edit = false
     var entry : JournalEntry
    
    var body: some View {
        GeometryReader{
            geometry in
            ScrollView{
                Text(entry.memorableMoment ?? " NO mm")
                    .font(.headline)
                    .padding()
                Text(entry.entry ?? "No entry")
                    .font(.subheadline)
                    .padding()
            }
            .frame(width: geometry.size.width / 1.5, height: geometry.size.height / 2.5)
            .navigationBarTitle("Entry on \(entry.date?.formatted(date: .abbreviated, time: .omitted) ?? "DELETED")")
            .toolbar {
                ToolbarItem(placement:  .navigationBarTrailing) {
                    Button {
                        vm.deleteEntry(entry: entry)
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "trash.circle.fill")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Edit"){
                        edit.toggle()
                    }
                }
            }
            .sheet(isPresented: $edit) {
                AddEntryView(repEntry: entry)
            }
        }
    }
}

//struct EntryView_Previews: PreviewProvider {
//    static var previews: some View {
//        EntryView()
//    }
//}
