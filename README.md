# JournalAppCoreData
After learning more, trying to use Swiftui Core Data MVVM to create a journal application. 

I used Xcode 13.4 to create this project, and it should run on iOS 14+. I stored all the entry information using CoreData. I haven't really used any additional dependancies besides apple's own packages, so the build should be pretty simple. 

Build Instructions: 
  1. Clone the repo onto device. 
  2. Click on the .xcodeproj file. 
  3. Open Xcode and at the top of the IDE, change the target to any simulator(or device of choice). 
  4. Click the run button -- looks like a play button on a TV remote -- to run. 

Issues: 
1. Changing the Date in the Add Entry View isn't the smoothest after trying to auto dismiss after changing date. 
2. When trying to update an entry(calling AddEntryView through EntryView with press of top right pencil button), as soon as the text editor is pressed, the link is immediately dismissed and user is returned to EntryView. I think the issue might have something to do with the way I size the Form, but I would like some help trying to figure this out. 
3. I would like to use an api(possibly Photokit) to retreive the people in the photo the user adds, so I can create a list of people met and display in Entry View. 
4. BUG -> journal app won't dismiss message controller after sending the text(it successfully sends the text) 

Future RoadMap:
- Try to determine which people are in each photo of the day to create a list of people met that day. 
- Create a widget which allows the user to take a picture, and that picture automatically takes place as the photo of the day. 
