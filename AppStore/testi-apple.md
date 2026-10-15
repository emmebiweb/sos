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
