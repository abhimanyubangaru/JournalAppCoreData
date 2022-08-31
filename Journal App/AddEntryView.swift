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
    
    @State private var showingPicker = false
    @State private var calendarId: Int = 0
    
    @State private var date : Date = Date()
    @State private var foundRep = false
    @State var repEntry : JournalEntry?
    @State private var entryText = ""
    @State private var memorableMomentText = ""
    @State private var moodNumber : Double = 5
    @State private var imageData : Data?
    
    @State private var displayChosenImage : Image?
    
    var body: some View {
        GeometryReader{ geometry in
            Form{
                Section(header: Text("Choose the date of the entry")){
                    DatePicker("Entry's date", selection: $date, displayedComponents: .date)
                        .id(calendarId)
                        .onChange(of: date, perform: { _ in
                            checkForRepetiton()
                          calendarId += 1
                        })
                        .onTapGesture {
                          calendarId += 1
                        }
                }
                Section(header: Text("PHOTO OF THE DAY")) {
                        HStack {
                            togglePhotoPicker
                            Spacer()
                            removeImage
                        }
                        HStack{
                        if let displayChosenImage = displayChosenImage {
                            displayChosenImage
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width, height: geometry.size.height / 5)
                        }
                            Spacer()
                        }
                }
                Section("How are you feeling?") {
                    Slider(value: $moodNumber, in: 0...10, step: 1)
                    Text("\(Int(moodNumber))")
                }
                
                Section(header: Text("Enter your entry's memorable moment")) {
                    TextEditor(text: $memorableMomentText)
                    .frame(minWidth: geometry.size.width / 1.5, minHeight: geometry.size.height / 6, alignment: .center)
                    
                }
                
                Section(header: Text("Enter your journal entry")) {
                    TextEditor(text: $entryText)
                    .frame(minWidth: geometry.size.width / 1.5, minHeight: geometry.size.height / 3, alignment: .center)

                }
                   
            }
            
            .navigationBarTitle("\(date.formatted(date: .abbreviated, time: .omitted))")
            .toolbar{
                ToolbarItem{
                    button
                        .buttonStyle(.bordered)
                }
            }
            .padding()
            .onAppear(perform: checkFirst)
            .sheet(isPresented: $showingPicker){
                PhotoPicker(chosenImage: $displayChosenImage, imageData: $imageData)
            }
        }
//        .onTapGesture {
//                  self.hideKeyboard()
//                }


    }
    
    var button : some View {
        Button {
            if foundRep {
                vm.updateEntry(entryEntity: repEntry!, entryText: entryText, memorableMomentText: memorableMomentText, moodNumber: moodNumber, imageData: imageData)
            } else {
                vm.addEntry(entryText: entryText, memorableMoment: memorableMomentText, date: date, moodNumber: moodNumber,imageData: imageData)
            }
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "checkmark.seal")
        }
    }
    
    var togglePhotoPicker : some View {
        Button {
            showingPicker.toggle()
        } label: {
            Image(systemName: "photo.fill")

        }
        .buttonStyle(BorderlessButtonStyle())
    }
    
    var removeImage : some View {
        Button {
            imageData = .none
            displayChosenImage = .none
        } label: {
            Image(systemName: "rectangle.slash")
        }
        .buttonStyle(BorderlessButtonStyle())
    }
    
    func updateChosenImage() {
        if let imageData = imageData {
            let image = UIImage(data: imageData)
            displayChosenImage = Image(uiImage: image!)
        }
    }

    func checkFirst() {
//        if let repEntry = repEntry {
//            self.moodNumber = Double(repEntry.moodNumber)
//            self.memorableMomentText = repEntry.memorableMoment ?? ""
//            self.entryText = repEntry.entry ?? ""
//            self.date = repEntry.date!
//            self.imageData = repEntry.imageData
//            let data = repEntry.imageData
//            if data != nil {
//                self.displayChosenImage = Image(uiImage: UIImage(data: repEntry.imageData!)!)
//            }
//            foundRep = true
//        } else {
//            checkForRepetiton()
//        }
        if let repEntry = repEntry {
            date = repEntry.date!
        }
            checkForRepetiton()
        
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
                        self.imageData = entry.imageData
                        if let imageData = imageData {
                            self.displayChosenImage = Image(uiImage: UIImage(data: imageData)!)
                        } else {
                            displayChosenImage = .none
                        }
                        return
                    }
                }
            foundRep = false
            repEntry = nil
            entryText = ""
            moodNumber = 5
            memorableMomentText = ""
            imageData = .none
            displayChosenImage = .none
        }
}

//struct AddEntryView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddEntryView()
//    }
//}
