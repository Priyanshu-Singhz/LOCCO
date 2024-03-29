import Foundation

class ViewModelReminder {
    var arraySectionData: [SectionModel] = []
    var arrayReminderData: [ReminderModel] = []

    init() {
        // Fetch data from API
        fetchDataFromAPI()
    }

    public func fetchDataFromAPI() {
        guard let url = URL(string: "https://n5vd2rg187.execute-api.eu-central-1.amazonaws.com/staging/reminder/sudhird@zignuts.com") else {
            return
        }
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
                // Handle error if needed
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let reminderModels = try decoder.decode([ReminderModel].self, from: data)
                
                // Update ViewModel data
                self.arrayReminderData = reminderModels
                
                // After updating data, recreate section data
                self.createSectionData()
                
                // Reload table view after fetching data
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: Notification.Name("APIDataFetched"), object: nil)
                }
            } catch {
                print("Error decoding JSON: \(error)")
                // Handle decoding error if needed
            }
        }.resume()
    }

    public func pushReminderToAPI(title: String, date: String, completion: @escaping (Bool) -> Void) {
            // Define your API endpoint URL
            guard let url = URL(string: "https://n5vd2rg187.execute-api.eu-central-1.amazonaws.com/staging/reminder/id/\(date)") else {
                completion(false)
                return
            }
            
            // Prepare reminder data
            let reminderData: [String: Any] = [
                "title": title,
                "date": date // Convert date to desired format
            ]
            
            // Create JSON data from reminderData
            guard let jsonData = try? JSONSerialization.data(withJSONObject: reminderData) else {
                completion(false)
                return
            }
            
            // Create and configure the URL request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            // Perform the request
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(false)
                    return
                }
                
                // Check the HTTP status code for success
                if 200 ..< 300 ~= httpResponse.statusCode {
                    completion(true)
                } else {
                    print("HTTP status code: \(httpResponse.statusCode)")
                    completion(false)
                }
            }.resume()
        }
    
    public func createSectionData() {
        // This method remains the same as before, as it's used to structure your ViewModel's data
        arraySectionData.removeAll()
        // Header Model
        let sectionRows: [Rowmodel] = arrayReminderData.map { reminderModel in
            return Rowmodel(title: reminderModel.title, Identifier: "Reminder", date: reminderModel.startDate, time: reminderModel.updatedAt, type: "ReminderCell")
        }
        arraySectionData.append(SectionModel(identifier: "Reminder", rows: sectionRows))
        print("arraySectionData0  :  \(arraySectionData)")
        print("remin1  :  \(self.arrayReminderData)")
    }
}
