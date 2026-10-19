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

## 3. Risposta al rifiuto 4.3 / 4.2.6 (versione breve, 3167 caratteri)

Hello,

Thank you for the review. We believe the app meets guidelines 4.3 and 4.2.6, so we are replying instead of resubmitting.

1. What it does
SOS was born from a personal need. Where my grandparents live, in rural Italy, there is often only voice/SMS coverage and no data, so WhatsApp, iMessage and location-sharing apps do not work. This is common in many rural and mountain areas of Italy. Tapping SOS starts a 5-second cancellable countdown, then opens the system Messages composer pre-filled with street address, GPS coordinates and a map link, addressed to contacts chosen in advance. Plain SMS works with basic signal and no internet. It also offers a siren that keeps playing with the screen locked, a torch flashing SOS in Morse code, a one-tap call to 112 and location sharing. It can be started from widget, Lock Screen, Siri, Action Button and Control Center.

2. Intended users
Italian-speaking people who may need help where data is weak or absent: elderly people in rural villages and their families, hikers, cyclists, people walking home alone at night, parents of teenagers. Texts and the default number (112) are designed for Italy.

3. Gap in the market
Most safety apps require registration, an account or a paid subscription, need an internet connection and track the user on a server. SOS has no registration, no payment, no server, no tracking, no third-party SDKs, and works with SMS only: the position leaves the device only in an SMS the user sees and sends. It is simple enough for elderly users. Apple's Emergency SOS contacts emergency services; SOS notifies the user's own family with an exact, readable address.

4. Beta testing
Tested by me, the developer, via TestFlight on my iPhone and in the Simulator: location and address, countdown, pre-filled SMS, siren with locked screen, Morse torch, widget, Siri and Action Button. The app works as intended.

5. Standalone or suite
Standalone. Our other apps are unrelated: Omnia – Dove guardarlo (where to watch films and series), instaMB (photo editing), Da Fare (to-do lists), Crea Banner (graphics), Lettore QR (QR scanner), TSS Academy (online courses, in development), emmeBi (my personal website, in development). None offers location sharing or emergency features.

6. In-app purchase of another app?
No. None of our apps relates to safety, and an emergency tool must be instantly reachable with its own widget, Siri and Action Button entry.

7. Shared code with our other apps
No, apart from Apple system frameworks.

8. Shared code or SDK with third-party apps
No. Only Apple frameworks (SwiftUI, MapKit, CoreLocation, MessageUI, ContactsUI, AVFoundation, WidgetKit, AppIntents).

9. Created for a third party
No. SOS is my own product, created for my family's need; idea, concept and brand are mine (emmeBiweb – Michele Bazzoli). Version 1.x was published under this same account in 2015, with initial code written by an external developer I commissioned. That record was removed and could not be restored, so this 2.0, a complete SwiftUI rewrite, uses a new bundle ID. No commercial template or app generation service was used.

Thank you,
Michele Bazzoli – emmeBiweb
