import SwiftUI

struct FeedbackFlowLayout: View {
    let feedbacks: [AppProblem]
    @Binding var selectedFeedback: AppProblem?
    @Binding var selectedFeedbacks: [AppProblem]
    let foregroundColor: Color =  Color(hex: "2E72D8")
    let backgroundColor: Color =  Color(hex: "6DA8FF")
    let strokeColor: Color =  Color(hex: "2E72D8")
    let onSelect: (AppProblem) -> Void
   
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(0..<getRows().count, id: \.self) { rowIndex in
                let row = getRows()[rowIndex]
                HStack(spacing: 8) {
                    ForEach(row, id: \.id) { feedback in
                        FeedbackButton(
                            text: feedback.translation,
                            isSelected: selectedFeedbacks.contains(where: {$0.id == feedback.id})
                        ) {
                            if selectedFeedbacks.contains(where: { $0.id == feedback.id }) {
                                self.selectedFeedback = nil
                                selectedFeedbacks.removeAll(where: { $0.id == feedback.id })
                            } else {
                                selectedFeedbacks.append(feedback)
                                self.selectedFeedback = feedback
                                onSelect(feedback)
                            }
                        }
                    }
                    Spacer()
                }
            }
        }
    }
    
        private func getRows() -> [[AppProblem]] {
        var rows: [[AppProblem]] = []
        var index = 0
        
        while index < feedbacks.count {
            if UIDevice.current.userInterfaceIdiom == .pad {
                // For iPad: show up to 4 items per row if they are short
                if index + 3 < feedbacks.count &&
                   feedbacks[index].translation.count <= 15 &&
                   feedbacks[index + 1].translation.count <= 15 &&
                   feedbacks[index + 2].translation.count <= 15 &&
                   feedbacks[index + 3].translation.count <= 15 {
                    rows.append([feedbacks[index], feedbacks[index + 1], feedbacks[index + 2], feedbacks[index + 3]])
                    index += 4
                } else if index + 2 < feedbacks.count &&
                          feedbacks[index].translation.count <= 15 &&
                          feedbacks[index + 1].translation.count <= 15 &&
                          feedbacks[index + 2].translation.count <= 15 {
                    rows.append([feedbacks[index], feedbacks[index + 1], feedbacks[index + 2]])
                    index += 3
                } else if index + 1 < feedbacks.count &&
                          feedbacks[index].translation.count <= 15 &&
                          feedbacks[index + 1].translation.count <= 15 {
                    rows.append([feedbacks[index], feedbacks[index + 1]])
                    index += 2
                } else {
                    rows.append([feedbacks[index]])
                    index += 1
                }
            } else {
                // For iPhone: original logic
                if feedbacks[index].translation.count > 15 {
                    // If long, display 1 item per row
                    rows.append([feedbacks[index]])
                    index += 1
                } else if index + 1 < feedbacks.count && feedbacks[index + 1].translation.count <= 15 {
                    // If short and next item is also short, display 2 items per row
                    rows.append([feedbacks[index], feedbacks[index + 1]])
                    index += 2
                } else {
                    // If short but no next item or next item is long
                    rows.append([feedbacks[index]])
                    index += 1
                }
            }
        }
        
        return rows
    }
}
