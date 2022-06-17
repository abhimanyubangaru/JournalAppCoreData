//
//  EntriesView.swift
//  Journal App
//
//  Created by Abhi B on 6/14/22.
//

import SwiftUI

struct EntriesView: View {
    @EnvironmentObject var vm : EntriesViewModel
    @State private var showAddEntries = false
    @State private var showFilter = false
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
        GeometryReader{ geomtery in
            NavigationView {
                ZStack{
                    
                    AngularGradient(gradient: Gradient(colors: [Color(gradientColor1),Color(gradientColor2),Color(gradientColor2),Color(gradientColor1)]), center: .topLeading)
                        .opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                    VStack(alignment: .leading){
                        if(showFilter){
                            VStack{
                                ZStack(alignment: .center){
                                    grayRectangle
                                        .frame(maxHeight: geomtery.size.height / 20)
                                    TextField("Enter search", text: $filterText)
                                        .foregroundColor(.white)
                                        .font(.subheadline)
                                        .padding()
                                    }
                                SearchView(filterKey: "entry", filterValue: filterText) { (entry : JournalEntry) in
                                    Text(entry.date!.formatted(date: .abbreviated, time: .omitted))
                                }
                                .frame(maxHeight: geomtery.size.height / 5)
                            }
                            .padding(10)
                        }
                        ScrollView {
                            LazyVGrid(columns: gridItemLayout){
                                ForEach(vm.savedEntries) { entry in
                                    NavigationLink {
                                        EntryView(entry: entry)
                                    } label: {
                                        RectangleView(geometry: geomtery.size, content: entry.date?.formatted(date: .abbreviated, time: .omitted) ?? "BYE BYE", endColor: rectViewColor(for: Int(entry.moodNumber)))
                                    }
                                    .simultaneousGesture(longPressDeleteEntry(on: entry))
                                }
                                .transition(.asymmetric(insertion: .scale, removal: .opacity) )
        
                            }
                            .padding()
                        }
                        .navigationBarTitle(" entries ")
                        .sheet(isPresented: $showAddEntries) {
                                AddEntryView()
                        }
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button{
                                    withAnimation {
                                        showFilter.toggle()
                                    }
                                } label: {
                                    Image(systemName: "magnifyingglass.circle.fill")
                                }
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button{
                                    showAddEntries.toggle()
                                } label: {
                                    Image(systemName: "plus.circle")
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
}

struct EntriesView_Previews: PreviewProvider {
    static var previews: some View {
        EntriesView()
    }
}
