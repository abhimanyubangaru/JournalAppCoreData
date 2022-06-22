//
//  SearchView.swift
//  Journal App
//
//  Created by Abhi B on 6/15/22.
//

import CoreData
import SwiftUI

struct SearchView<T: NSManagedObject, Content: View>: View {
    @Environment(\.managedObjectContext) var moc
    @State private var delayCount : Double = 0.0
    var fetchRequest : FetchRequest<T>
    let content: (T) -> Content
    
    let rowBackgroundColor : UIColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
    
    init(filterKey: String, filterValue: String, @ViewBuilder content: @escaping (T) -> Content) {
        
        fetchRequest = FetchRequest<T>(entity: T.entity(), sortDescriptors: [NSSortDescriptor(key:"date",ascending: false)], predicate: NSPredicate(format: "%K CONTAINS[cd] %@", filterKey, filterValue))
        self.content = content
    }

    var body: some View {
        List{
            ForEach(fetchRequest.wrappedValue,id: \.self){ entry in
                NavigationLink(destination: EntryView(entry: entry as! JournalEntry)){
                        self.content(entry)
                }
                .listRowBackground(Color(rowBackgroundColor))
                .foregroundColor(.white)
                .id(UUID())
            }
            .transition(.slide)
        }
        .listStyle(.plain)
    }
}

//struct SearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchView(filter: "test")
//    }
//}

