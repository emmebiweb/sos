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

## 3. Risposta al rifiuto 4.3 / 4.2.6 (15 ottobre 2026)

Hello,

Thank you for the review. We believe the app meets guidelines 4.3 and 4.2.6, so we are replying instead of resubmitting. Answers to your questions:

1. What the app does / problem solved
SOS lets a person in difficulty (lost on a hike, feeling unsafe, injured, car breakdown at night) tell the people they trust exactly where they are, with one tap and without needing mobile data. Tapping the SOS button starts a 5-second cancellable countdown, then opens the system Messages composer pre-filled with the current street address, GPS coordinates with accuracy and a map link, addressed to contacts the user chose in advance. Because it uses plain SMS, it works where there is phone signal but no data connection, which is common in mountain areas. The same screen offers an alarm siren that keeps playing with the screen locked, a torch that flashes "SOS" in Morse code, a one-tap call to 112 (configurable), and location sharing to any app. It can be triggered from a Home/Lock Screen widget, Siri, the Action Button and Control Center, so it can be used without unlocking and searching for the app.

2. Intended users
Italian-speaking people who spend time alone or outdoors: hikers and mountain-goers (the app is developed on Lake Garda, close to the Alps), cyclists, people walking home at night, elderly people living alone and their families, and parents who want their teenagers to have a simple way to send their position. The interface, texts and default emergency number (112) are designed for Italy.

3. Gap addressed
Most safety apps require an account, a subscription, a backend service or an internet connection, and many share the location continuously with a server. SOS does none of this: no account, no server, no tracking, no third-party SDKs; the position leaves the device only in an SMS the user sees and sends. It works with only cellular voice/SMS coverage, and it puts every emergency tool (SMS with position, siren, Morse torch, emergency call) on a single screen reachable from widget, Lock Screen, Siri and Action Button. Apple's built-in Emergency SOS calls emergency services; our app instead notifies the user's own trusted contacts with an exact, readable address, which is often what is needed in non-life-threatening situations (lost, unsafe, stranded).

4. Beta testing
[DA COMPLETARE CON DATI REALI: chi ha provato la build via TestFlight, su quali iPhone, e quali modifiche sono nate dai loro commenti. Se il test è stato solo tuo, scrivilo così: Apple preferisce la verità a un elenco inventato.]

5. Standalone or suite
Standalone. The other apps on our account are unrelated: Omnia – Dove guardarlo (streaming guide), instaMB (photo editing), Da Fare (to-do lists), Crea Banner (graphics), Lettore QR (QR code scanner), TSS Academy and emmeBi. None offers location sharing, alarms or emergency features.

6. Could it be an in-app purchase of another app?
No. None of our apps is related to personal safety, and an emergency tool must be a separate, instantly reachable app with its own widget, Siri shortcut and Action Button entry; hiding it inside an unrelated app would defeat its purpose.

7. Shared code or assets with our other apps
No. The app was written specifically for this product. It shares no code, frameworks or assets with our other apps, apart from Apple system frameworks.

8. Shared codebase or SDK with third-party apps
No. The app uses only Apple frameworks (SwiftUI, MapKit, CoreLocation, MessageUI, ContactsUI, AVFoundation, WidgetKit, AppIntents). No third-party SDKs, templates or content libraries.

9. Created for a client or third party
No. SOS is our own product: emmeBiweb (Michele Bazzoli, Lonato del Garda) designed it and first published it on the App Store in 2015 (version 1.x, bundle ID com.emmeibweb.sosapp). That record was removed from App Store Connect and could not be restored, so this 2.0 version, a complete rewrite in SwiftUI with new features, had to be submitted under a new bundle ID. It was not built with a commercial template or an app generation service.

Thank you for your time,
Michele Bazzoli – emmeBiweb
