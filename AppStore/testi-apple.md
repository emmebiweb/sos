# Testi per Apple

## 1. Risposta ad App Review (App Store Connect → SOS → Revisione app → Rispondi)

Hello,

Thank you for your review.

In build 2.0 (2) we have removed the medical card feature entirely: the app no longer collects, stores or displays any health information, and the Health & Fitness category has been removed from the listing.

SOS is a personal safety utility, not a medical, healthcare or emergency service. It does not offer any regulated service. Its only purpose is to let the user send their own location by SMS to people they personally chose.

All data stays on the device:
- no account, no login, no backend server, no analytics or third-party SDKs;
- contacts are picked through the system contact picker (CNContactPickerViewController), without full access to the address book, and are saved only locally;
- the location is read only while the app is in use and is shared only in the SMS that the user reviews and sends manually from the system Messages composer;
- our App Privacy declaration is "Data Not Collected".

We have also started the process to convert our developer account to an organization. If the conversion is approved, could you confirm whether we would be allowed to reintroduce the optional medical card (blood type, allergies, medications typed by the user, stored only on the device and included only in SMS messages the user chooses to send)?

Thank you,
Michele Bazzoli – emmeBiweb

---

## 2. Richiesta di conversione Individual → Organization

### Correzioni al modulo
- **"Does this organization hold an active Apple Developer Program membership?"** → **No, this organization does not hold a membership.**
  La ditta non ha un suo account: l'account attivo è quello individuale che vuoi convertire. Con "Yes" Apple capisce che esiste già un secondo account aziendale.
- **Organization Name:** `emmeBiweb di Michele Bazzoli`. Deve coincidere esattamente con il nome registrato presso D-U-N-S (verificalo su developer.apple.com/enroll/duns-lookup).
- **DBA / trade name:** No. Va bene se il nome D-U-N-S è "emmeBiweb di Michele Bazzoli".
- **Tax ID:** Personal Tax ID, se nel profilo fiscale di App Store Connect hai inserito il codice fiscale. Se hai inserito la Partita IVA, scegli Organization Tax ID.

### Additional information (incolla questo testo)

Please convert my individual membership (Team ID JS4SY4GQXQ) to an organization membership for my registered business:

emmeBiweb di Michele Bazzoli
Via Albertano Da Brescia, 34 – 25017 Lonato del Garda (BS), Italy
VAT number (Partita IVA): IT03651980983
D-U-N-S: 442874607
Website: https://emmebiweb.com
Certified email (PEC): emmebiweb@pec.it

The business is a sole proprietorship (ditta individuale) registered with the Italian Chamber of Commerce; I am its founder and sole owner, with full legal authority to bind it. The request follows App Review feedback under Guideline 5.1.1(ix) for our app "SOS – Aiuto in un tocco" (Apple ID 6822780665). I can provide the Chamber of Commerce registration (visura camerale) on request.

Thank you,
Michele Bazzoli

---

## 3. Risposta al rifiuto 4.3 / 4.2.6 (versione finale)

Hello,

Thank you for the review. We believe the app meets guidelines 4.3 and 4.2.6, so we are replying instead of resubmitting. Answers to your questions:

1. What the app does and the problem it solves
SOS was born from a personal need. Where my grandparents live, in rural Italy, the mobile network often offers only basic voice and SMS coverage: there is no usable data connection, so WhatsApp, iMessage and location-sharing apps simply do not work. I wanted a way for them, and for me when I am in the mountains, to tell family exactly where they are with a single tap. This situation is common in many rural and mountain areas of Italy.
Tapping the SOS button starts a 5-second cancellable countdown, then opens the system Messages composer pre-filled with the current street address, GPS coordinates with accuracy and a map link, addressed to contacts chosen in advance. Because it uses plain SMS, it works wherever there is basic phone signal, even with no internet. The same screen offers an alarm siren that keeps playing with the screen locked, a torch that flashes "SOS" in Morse code, a one-tap call to 112 (configurable) and location sharing to any app. It can be started from a Home/Lock Screen widget, Siri, the Action Button and Control Center.

2. Intended users
Italian-speaking people who may need help where mobile data is weak or absent: elderly people living in rural villages and their families, hikers and mountain-goers, cyclists, people walking home alone at night, and parents who want their teenagers to have a simple way to send their position. Texts, interface and the default emergency number (112) are designed for Italy.

3. Gap in the market
Most safety apps require registration, an account, a paid subscription or in-app purchases, and they rely on an internet connection and a backend server that continuously tracks the user. SOS requires no registration and no payment, works with SMS only (no data connection needed), has no server, no tracking and no third-party SDKs: the position leaves the device only in an SMS the user sees and sends. It is simple enough for elderly users, and every emergency tool (SMS with position, siren, Morse torch, emergency call) is on a single screen. Apple's built-in Emergency SOS contacts emergency services; SOS instead notifies the user's own family or trusted contacts with an exact, readable address, which is what is needed in most non-life-threatening situations.

4. Beta testing
The app was tested by me, the developer, through TestFlight on my own iPhone and in the iOS Simulator, checking the full flow: location and address lookup, the cancellable countdown, the pre-filled SMS, the siren with the screen locked, the Morse torch, the widget, Siri and Action Button triggers. The app works as intended. The design also reflects years of real use of version 1.x by my family in areas with SMS-only coverage.

5. Standalone or part of a suite
Standalone. The other apps on our account are unrelated: Omnia – Dove guardarlo (guide to where to watch films and TV series), instaMB (photo editing), Da Fare (to-do lists and reminders), Crea Banner (banner and graphics creation), Lettore QR (QR code scanner), TSS Academy (online courses app, in development) and emmeBi (app for my personal website, in development). None of them offers location sharing, alarms or emergency features.

6. Could it be an in-app purchase or feature of another app?
No. None of our apps is related to personal safety. An emergency tool must be a separate app that can be reached instantly, with its own widget, Siri shortcut and Action Button entry; hiding it inside an unrelated app would defeat its purpose.

7. Shared code or assets with our other apps
No. The app shares no code, frameworks or assets with our other apps, apart from Apple system frameworks.

8. Shared codebase or SDK with third-party apps
No. The app uses only Apple frameworks (SwiftUI, MapKit, CoreLocation, MessageUI, ContactsUI, AVFoundation, WidgetKit, AppIntents). No third-party SDKs, templates or content libraries.

9. Created for a client or third party
No. SOS is my own product, created for my own family's need. The idea, the concept and the brand are mine (emmeBiweb – Michele Bazzoli, Lonato del Garda). Version 1.x was published on the App Store under this same developer account in 2015; its initial code was written by an external developer I commissioned. That App Store record was later removed and could not be restored, so this version 2.0, a complete rewrite in SwiftUI with new features, is submitted under a new bundle ID. It was not built from a commercial template or an app generation service.

Thank you for your time,
Michele Bazzoli – emmeBiweb
