import ContactsUI
import MessageUI
import SwiftUI
import UIKit

extension UIApplication {
    static var topViewController: UIViewController? {
        let scene = shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }
        var top = scene?.keyWindow?.rootViewController
        while let presented = top?.presentedViewController { top = presented }
        return top
    }

    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) { open(url) }
    }
}

// MARK: - SMS

struct MessageComposeView: UIViewControllerRepresentable {
    let recipients: [String]
    let body: String
    var onFinish: (MessageComposeResult) -> Void

    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        let vc = MFMessageComposeViewController()
        vc.recipients = recipients
        vc.body = body
        vc.messageComposeDelegate = context.coordinator
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator(onFinish: onFinish) }

    final class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {
        let onFinish: (MessageComposeResult) -> Void
        init(onFinish: @escaping (MessageComposeResult) -> Void) { self.onFinish = onFinish }

        func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                          didFinishWith result: MessageComposeResult) {
            onFinish(result)
        }
    }
}

// MARK: - Rubrica

/// CNContactPickerViewController va presentato da UIKit: dentro un `.sheet` SwiftUI si comporta male.
final class ContactPickerPresenter: NSObject, CNContactPickerDelegate {
    static let shared = ContactPickerPresenter()
    private var completion: (([EmergencyContact]) -> Void)?

    func present(completion: @escaping ([EmergencyContact]) -> Void) {
        self.completion = completion
        let picker = CNContactPickerViewController()
        picker.delegate = self
        picker.displayedPropertyKeys = [CNContactPhoneNumbersKey]
        picker.predicateForEnablingContact = NSPredicate(format: "phoneNumbers.@count > 0")
        UIApplication.topViewController?.present(picker, animated: true)
    }

    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        let result = contacts.compactMap { contact -> EmergencyContact? in
            guard let number = Self.preferredNumber(of: contact) else { return nil }
            let name = CNContactFormatter.string(from: contact, style: .fullName) ?? ""
            return EmergencyContact(name: name, phone: number)
        }
        completion?(result)
        completion = nil
    }

    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        completion = nil
    }

    private static func preferredNumber(of contact: CNContact) -> String? {
        let mobileLabels: Set<String> = [CNLabelPhoneNumberMobile, CNLabelPhoneNumberiPhone]
        let preferred = contact.phoneNumbers.first { mobileLabels.contains($0.label ?? "") }
            ?? contact.phoneNumbers.first
        return preferred?.value.stringValue
    }
}
