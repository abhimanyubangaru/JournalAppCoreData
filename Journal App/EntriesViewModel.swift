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
    
    
    
    func updateEntry(entryEntity entity: JournalEntry, entryText entryText : String, memorableMomentText mmText : String, moodNumber mdNum : Double) {
        entity.entry = entryText
        entity.memorableMoment = mmText
        entity.moodNumber = Int64(mdNum)
        saveData()
    }
    
    func addEntry(entryText inpEntry : String, memorableMoment mm : String, date entryDate : Date, moodNumber mdNum : Double) {
        let entry = JournalEntry(context: container.viewContext)
        entry.date = entryDate
        entry.id = UUID()
        entry.entry = inpEntry
        entry.memorableMoment = mm
        entry.moodNumber = Int64(mdNum)
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
