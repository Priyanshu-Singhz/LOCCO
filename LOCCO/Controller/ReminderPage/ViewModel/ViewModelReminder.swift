//
//  ViewModelReminders.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 21/02/24.
//

import Foundation


class ViewModelReminder{
    //MARK: - Properties
    var arraySectionData:[SectionModel] = []
    var arrayReminderData:[ReminderModel] = []
    //MARK: - init
    init(){
        createSectionData()
    }
    // Create Reminder Data
    fileprivate func createReminderData(){
        arrayReminderData.removeAll()
        arrayReminderData.append(ReminderModel(titleLbl: "(Costum Title)", date: "dd.mm.yyyy", time: "hh:mm"))
        arrayReminderData.append(ReminderModel(titleLbl: "(Costum Title)", date: "dd.mm.yyyy", time: "hh:mm"))
        arrayReminderData.append(ReminderModel(titleLbl: "(Costum Title)", date: "dd.mm.yyyy", time: "hh:mm"))
        arrayReminderData.append(ReminderModel(titleLbl: "(Costum Title)", date: "dd.mm.yyyy", time: "hh:mm"))
    }
    // Create Section Data
    fileprivate func createSectionData(){
        arraySectionData.removeAll()
        //Header Model
        createReminderData()
        let sectionRows: [Rowmodel] = arrayReminderData.map { reminderModel in
            return Rowmodel(title: reminderModel.titleLbl, Identifier: "Reminder",date: reminderModel.date,time: reminderModel.time, type: "ReminderCell")
        }
        arraySectionData.append(SectionModel(identifier: "Reminder", rows: sectionRows))
    }
}
