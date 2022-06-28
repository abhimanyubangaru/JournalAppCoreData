//
//  EntriesView.swift
//  Journal App
//
//  Created by Abhi B on 6/14/22.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct EntriesView: View {
    @EnvironmentObject var vm : EntriesViewModel
    @State private var showFilter = false
    @State private var showChart = false
    @State private var showFilterChoices = false
    
    @State private var filterType = "memorableMoment"
    
    @State private var filterText = "";
    @State private var showDeleteAlert = false
    @State private var entryToDelete : JournalEntry?
    @State private var progress: CGFloat = 0
    
    let gradient1 = Gradient(colors: [.purple, .yellow])
    let gradient2 = Gradient(colors: [.blue, .purple])
    
    private var gridItemLayout = [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())]
    
    var gradientColor1 = #colorLiteral(red: 0.8321695924, green: 0.985483706, blue: 0.4733308554, alpha: 1)
    var gradientColor2 = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)

    
    var body: some View {
        GeometryReader{ geometry in
            NavigationView {
                ZStack{
                    AngularGradient(gradient: Gradient(colors: [Color(gradientColor1),Color(gradientColor2),Color(gradientColor2),Color(gradientColor1)]), center: .topLeading)
                        .opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                    VStack(alignment: .leading) {
                        if(showFilter){
                            VStack{
                                HStack{
                                    ZStack(alignment: .center){
                                        grayRectangle
                                            .frame(maxHeight: geometry.size.height / 20)
                                        TextField("Enter search", text: $filterText)
                                            .foregroundColor(.white)
                                            .font(.subheadline)
                                            .padding()
                                        }
                                    Button{
                                        withAnimation{
                                            showFilterChoices.toggle()
                                        }
                                    } label: {
                                        Image(systemName: "gear")
                                    }
                                }
                                SearchView(filterKey: filterType, filterValue: filterText) { (entry : JournalEntry) in
                                    Text(entry.date!.formatted(date: .abbreviated, time: .omitted))
                                }
                                .frame(maxHeight: geometry.size.height / 5)
                            }
                            .padding(10)
                        }
                        ScrollView {
                            LazyVGrid(columns: gridItemLayout){
                                ForEach(vm.savedEntries) { entry in
                                    NavigationLink {
                                        EntryView(entry: entry)
                                    } label: {
                                        RectangleView(geometry: geometry.size, content: entry.date?.formatted(date: .abbreviated, time: .omitted) ?? "BYE BYE", endColor: vm.rectViewColor(for: Int(entry.moodNumber)))
                                    }
                                    
                                    .simultaneousGesture(longPressDeleteEntry(on: entry))
                                }
                                .transition(.asymmetric(insertion: .scale, removal: .opacity) )
        
                            }
                            .padding()
                        }
                        .navigationBarTitle(" entries ")
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button{
                                    withAnimation {
                                        showFilter.toggle()
                                    }
                                } label: {
                                    Image(systemName: showFilter ? "magnifyingglass.circle.fill" : "magnifyingglass.circle")
                                }
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                NavigationLink{
                                    AddEntryView()
                                } label: {
                                    Image(systemName: "plus.circle")
                                }
                                
                            }
                            ToolbarItem(placement: .navigationBarLeading){
                                Button {
                                    withAnimation {
                                        showChart.toggle()
                                    }
                                } label: {
                                    Image(systemName: "chart.xyaxis.line")
                                }
                            }
                        }
                        .alert(isPresented: $showDeleteAlert) {
                            Alert(title: Text("Confirm Deletion"),
                                  message: Text("Are you sure you want to delete the entry on Entry \(entryToDelete?.date?.formatted(date: .abbreviated, time: .omitted) ?? "No entry selected to delete")"),
                                  primaryButton: .destructive(Text("Delete")) {
                                    if(entryToDelete != nil){
                                        
                                            vm.deleteEntry(entry: entryToDelete!)
                                            entryToDelete = nil
                                      
                                        }
                            },
                                  secondaryButton: .cancel()
                            )
                        }
                        .actionSheet(isPresented: $showFilterChoices){
                            ActionSheet(title: Text("Change filter \n The current one is \(filterType)"),  buttons:
                                [
                                    .default(Text("Entry")){self.filterType = "entry"},
                                    .default(Text("Memorable Moment")){self.filterType = "memorableMoment"},
                                    .cancel()
                                ])
                        }
                    }
                }
            }
        }
    }
    
    var animatedRectangle: some View {
        Rectangle()
            .animatableGradient(fromGradient: gradient1, toGradient: gradient2, progress: progress)
            .ignoresSafeArea()
            .onAppear {
                withAnimation(.linear(duration: 5.0).repeatForever(autoreverses: true)) {
                    self.progress = 1.0
                }
            }
    }
    
    
    
    private func longPressDeleteEntry(on entry: JournalEntry) -> some Gesture{
        LongPressGesture(minimumDuration: 1)
            .onEnded { _ in
                print("delete")
                showDeleteAlert.toggle()
                entryToDelete = entry
//                vm.deleteEntry(entry: entry)
            }
    }
    
    var grayRectangle : some View {
        Rectangle()
            .foregroundColor(.gray)
            .cornerRadius(20)
    }
    

}

struct EntriesView_Previews: PreviewProvider {
    static var previews: some View {
        EntriesView()
    }
}
