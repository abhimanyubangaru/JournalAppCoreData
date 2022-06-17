//
//  AddEntryView.swift
//  Journal App
//
//  Created by Abhi B on 6/14/22.
//

import SwiftUI

struct AddEntryView: View {
    @EnvironmentObject var vm : EntriesViewModel
    @Environment(\.presentationMode) var presentationMode

    
    @State private var date = Date()
    @State private var foundRep = false
    @State var repEntry : JournalEntry?
    @State private var entryText = ""
    @State private var memorableMomentText = ""
    @State private var moodNumber : Double = 5
    
    var body: some View {
        GeometryReader{ geometry in
            Form{
                
                Section(header: Text("Choose the date of the entry")){
                    DatePicker("Entry's date", selection: $date, displayedComponents: .date)
                        .onChange(of: date) { newValue in
                            checkForRepetiton()
                        }
                }
                
                Section("How are you feeling?") {
                    Slider(value: $moodNumber, in: 0...10, step: 1)
                    Text("\(Int(moodNumber))")
                }
                
                Section(header: Text("Enter your entry's memorable moment")) {
                    TextEditor(text: $memorableMomentText)
                    .frame(width: geometry.size.width / 1.5, height: geometry.size.height / 6, alignment: .center)
                }
                
                Section(header: Text("Enter your journal entry")) {
                    TextEditor(text: $entryText)
                    .frame(width: geometry.size.width / 1.5, height: geometry.size.height / 3, alignment: .center)
                }
                Section {
                    button
                }
            }
        }
        .navigationBarTitle("\(date)")
        .padding()
        .onAppear(perform: checkFirst)
    }
    
    var button : some View {
        Button("Submit"){
            if foundRep {
                vm.updateEntry(entryEntity: repEntry!, entryText: entryText, memorableMomentText: memorableMomentText, moodNumber: moodNumber)
            } else {
                vm.addEntry(entryText: entryText, memorableMoment: memorableMomentText, date: date, moodNumber: moodNumber)
            }
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func checkFirst() {
        if repEntry != nil {
            self.moodNumber = Double(repEntry!.moodNumber)
            self.memorableMomentText = repEntry!.memorableMoment ?? ""
            self.entryText = repEntry!.entry ?? ""
            self.date = repEntry!.date!
            foundRep = true
            return
        } else {
            checkForRepetiton()
        }
    }
    
    func checkForRepetiton(){ //goes through all the entries to see if there is a repetition
            for entry in vm.savedEntries{
                    let components = Calendar.current.dateComponents([.month, .day,.year], from: self.date)
                    let components2 = Calendar.current.dateComponents([.month, .day,.year], from: entry.date!)
                    if components.month == components2.month && components.day == components2.day && components.year == components2.year{
                        print("Found")
                        self.moodNumber = Double(entry.moodNumber)
                        self.memorableMomentText = entry.memorableMoment ?? ""
                        self.entryText = entry.entry ?? ""
                        foundRep = true
                        self.repEntry = entry
                        return
                    }
                }
            foundRep = false
            repEntry = nil
            entryText = ""
            memorableMomentText = ""
        }
}

struct AddEntryView_Previews: PreviewProvider {
    static var previews: some View {
        AddEntryView()
    }
}
