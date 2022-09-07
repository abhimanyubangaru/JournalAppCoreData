//
//  EntriesViewModel.swift
//  Journal App
//
//  Created by Abhi B on 6/14/22.
//

import Foundation
import CoreData
import SwiftUI

class EntriesViewModel : ObservableObject {
    
    let container : NSPersistentContainer
        
    @Published var savedEntries : [JournalEntry] = []
    @Published var filteredEntries : [JournalEntry] = []

    
    init() {
        container = NSPersistentContainer(name: "Journal_App")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error loading container \(error.localizedDescription)")
            } else {
                print("SUCCESS")
            }
        }
        fetchEntries()
    }
    
    func fetchEntries() {
        let request = NSFetchRequest<JournalEntry>(entityName: "JournalEntry")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        do {
            savedEntries = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching \(error)")
        }
    }
    
    func isThereAEntryOnSpecificDate(date inputDate : Date) -> Bool {
        fetchEntries()
        for entry in savedEntries {
            let components = Calendar.current.dateComponents([.month, .day,.year], from: inputDate)
            let components2 = Calendar.current.dateComponents([.month, .day,.year], from: entry.date!)
            if components.month == components2.month && components.day == components2.day && components.year == components2.year{
                return true
            }
        }
        return false;
    }
    
    func getEntryOnSpecificDate(date inputDate : Date) -> JournalEntry? {
        if(isThereAEntryOnSpecificDate(date: inputDate)){
            for entry in savedEntries {
                let components = Calendar.current.dateComponents([.month, .day,.year], from: inputDate)
                let components2 = Calendar.current.dateComponents([.month, .day,.year], from: entry.date!)
                if components.month == components2.month && components.day == components2.day && components.year == components2.year{
                    return entry
                }
            }
        }
        return nil; 
    }
    
    func updateEntry(entryEntity entity: JournalEntry, entryText : String, memorableMomentText mmText : String, moodNumber mdNum : Double, imageData iData : Data?) {
        entity.entry = entryText
        entity.memorableMoment = mmText
        entity.moodNumber = Int64(mdNum)
        entity.imageData = iData
        saveData()
    }
    
    func rectViewColor(for num : Int) -> Color {
        let color1 = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        let color2 = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        let color3 = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        let color4 = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        let color5 = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        let color6 = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        let color7 = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        let color8 = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        let color9 = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        let color10 = #colorLiteral(red: 0.8862745166, green: 0.8409167915, blue: 0, alpha: 1)
        
        let colors = [Color(color1),Color(color2),Color(color3),Color(color4),Color(color5), Color(color6),Color(color7),Color(color8),Color(color9),Color(color10), Color(.yellow)]
        return colors[num]
    }
    
    func addEntry(entryText inpEntry : String, memorableMoment mm : String, date entryDate : Date, moodNumber mdNum : Double, imageData iData : Data?) {
        let entry = JournalEntry(context: container.viewContext)
        entry.date = entryDate
        entry.id = UUID()
        entry.entry = inpEntry
        entry.memorableMoment = mm
        entry.moodNumber = Int64(mdNum)
        entry.imageData = iData
        saveData()
    }
    
    func deleteEntry(indexSet : IndexSet) {
        guard let index = indexSet.first else {return}
        let entity = savedEntries[index]
        container.viewContext.delete(entity)
        saveData()
    }
    
    func deleteEntry(entry : JournalEntry){
        withAnimation{
            container.viewContext.delete(entry)
            saveData()
        }
    }
    
    func saveData() {
        do{
           try container.viewContext.save()
            fetchEntries()
        } catch let error {
            print("Error saving \(error)")
        }
    }
    
}
