// Update the ViewModelFAQ class

import UIKit
class ViewModelFAQ {
    // MARK: - Properties
    var arraySectionData: [SectionModel] = []
    var faqData: [FAQModel] = []
    init() {
        createSectionData()
    }
    fileprivate func createSectionData() {
        arraySectionData.removeAll()
        // Header Model
        arraySectionData.append(SectionModel(identifier: "FAQs & Support", rows: [
            Rowmodel(title: "home_FAQs", Identifier: "FAQs & Support", type: "FAQs & Support")
        ]))
        // Create FAQ data
        createFAQData()
        // Append FAQs section
        arraySectionData.append(SectionModel(identifier: "FAQs", rows: faqData.map {
            Rowmodel(title: $0.title, Identifier: "FAQs",subtitle: $0.description, icon: UIImage(named: "up_arrow"), type: "FAQs")
        }))
    }
    
    fileprivate func createFAQData() {
        faqData.removeAll()
        faqData.append(FAQModel(title: "home_how-it-works", description:"This question is explained in detail in the menu item How does LOCCO work"))
        faqData.append(FAQModel(title: "faq_support_page-question-2", description: "Scelerisque est cras elit blandit quam ipsum vulputate semper scelerisque. Urna odio aliquam elit ac eu sem enim. Aliquet ultrices hendrerit ac posuere hendrerit at eget id mauris. Fringilla elit nulla vel porttitor leo eget sem. Etiam augue aliquam gravida enim vitae nunc proin accumsan nibh."))
        faqData.append(FAQModel(title: "faq_support_page-question-3", description: "Scelerisque est cras elit blandit quam ipsum vulputate semper scelerisque. Urna odio aliquam elit ac eu sem enim. Aliquet ultrices hendrerit ac posuere hendrerit at eget id mauris. Fringilla elit nulla vel porttitor leo eget sem. Etiam augue aliquam gravida enim vitae nunc proin accumsan nibh."))
        faqData.append(FAQModel(title: "faq_support_page-question-4", description: "When you submit a location to us, we define a new point to which an audio could be produced and then triggered there. We check your location and add a suitable audio as quickly as possible."))
        faqData.append(FAQModel(title: "home_how-it-works", description:"This question is explained in detail in the menu item How does LOCCO work"))
        faqData.append(FAQModel(title: "faq_support_page-question-2", description: "Scelerisque est cras elit blandit quam ipsum vulputate semper scelerisque. Urna odio aliquam elit ac eu sem enim. Aliquet ultrices hendrerit ac posuere hendrerit at eget id mauris. Fringilla elit nulla vel porttitor leo eget sem. Etiam augue aliquam gravida enim vitae nunc proin accumsan nibh."))
        faqData.append(FAQModel(title: "faq_support_page-question-3", description: "Scelerisque est cras elit blandit quam ipsum vulputate semper scelerisque. Urna odio aliquam elit ac eu sem enim. Aliquet ultrices hendrerit ac posuere hendrerit at eget id mauris. Fringilla elit nulla vel porttitor leo eget sem. Etiam augue aliquam gravida enim vitae nunc proin accumsan nibh."))
        faqData.append(FAQModel(title: "faq_support_page-question-4", description: "When you submit a location to us, we define a new point to which an audio could be produced and then triggered there. We check your location and add a suitable audio as quickly as possible."))
    }
}
