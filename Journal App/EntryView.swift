//
//  EntryView.swift
//  Journal App
//
//  Created by Abhi B on 6/14/22.
//

import SwiftUI
import MessageUI

struct EntryView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var vm : EntriesViewModel
    @State private var showEdit = false
    
    private let messageComposeDelegate = MessageDelegate()
    
    
    var entry : JournalEntry
    
    var body: some View {
        GeometryReader{
            geometry in
            ZStack{
                    LinearGradient(gradient: Gradient(colors: [Color(UIColor(backgoundColor).inverseColor()), backgoundColor]), startPoint: .top, endPoint: .bottom)
                        .edgesIgnoringSafeArea(.all)
                VStack(alignment: .leading){
                        ScrollView{
                            if entry.imageData != nil {
                                Image(uiImage: UIImage(data: entry.imageData!)!)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: geometry.size.width * 0.99, maxHeight: geometry.size.height / 3)
                            }
                            
                            Text(entry.memorableMoment ?? " NO mm")
                                .font(.headline)
                                .padding()
                            Text(entry.entry ?? "No entry")
                                .multilineTextAlignment(.leading)
                                .font(.subheadline)
                                .padding()
                        }
                    }
                }
                .navigationBarTitle("Entry on \(entry.date?.formatted(date: .abbreviated, time: .omitted) ?? "DELETED")")
//                .sheet(isPresented: $showEdit){
//                    AddEntryView(isPassedInThroughEdit: true, repEntry: entry)
//                }
                .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        vm.deleteEntry(entry: entry)
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "trash.circle.fill")
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            self.presentMessageCompose(subject: entry.memorableMoment ?? "" , body: entry.entry ?? "")
                        } label: {
                            Image(systemName: "message.fill")
                        }
                    }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink{
                        AddEntryView(repEntry: entry)
                    //    showEdit.toggle()
                    } label: {
                        Image(systemName: "pencil")
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
        }
    }
    
    var backgoundColor : Color {
        vm.rectViewColor(for: Int(entry.moodNumber))
    }
}

// MARK: The message part
extension EntryView {

    /// Delegate for view controller as `MFMessageComposeViewControllerDelegate`
    private class MessageDelegate: NSObject, MFMessageComposeViewControllerDelegate {
        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            // Customize here
            controller.dismiss(animated: true)
        }

    }

    /// Present an message compose view controller modally in UIKit environment
    private func presentMessageCompose(subject : String, body : String) {
        guard MFMessageComposeViewController.canSendText() else {
            return
        }
        let vc = UIApplication.shared.keyWindow?.rootViewController

        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = messageComposeDelegate
        let cont = subject + "\n" + body
        composeVC.body = cont

        vc?.present(composeVC, animated: true) 
        
    }
}
