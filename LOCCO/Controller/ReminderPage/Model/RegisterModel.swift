//
//  RegisterModel.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 21/02/24.
//

import Foundation
struct ReminderModel: Codable {
  let startDate: String
  let email: String
  let id: String
  let updatedAt: String
  let title: String
}
