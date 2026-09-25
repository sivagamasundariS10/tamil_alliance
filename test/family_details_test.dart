import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tamil_alliance/screens/registration/family_details_screen.dart';
import 'package:tamil_alliance/screens/registration/education_career_screen.dart';
import 'package:tamil_alliance/screens/registration/photos_privacy_screen.dart';
import 'package:tamil_alliance/screens/registration/govt_id_verification_screen.dart';

void main() {
  testWidgets('FamilyDetailsScreen renders progressive cards smoothly', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: FamilyDetailsScreen(
          mobileNumber: '9842176540',
          countryCode: '+91',
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Verify App Bar & Subheader
    expect(find.text('Profile Registration'), findsOneWidget);
    expect(find.text('STEP 2 OF 6'), findsOneWidget);
    expect(find.text('STEP 2 OF 6 • FAMILY DETAILS'), findsOneWidget);

    // 2. Initially only Father's Details is visible
    expect(find.text("FATHER'S DETAILS"), findsOneWidget);
    expect(find.text("MOTHER'S DETAILS"), findsNothing);

    // 3. Fill Father's mandatory field (Occupation)
    final occFinder = find.byWidgetPredicate(
      (w) => w is TextField && w.decoration?.hintText?.contains('Retd. Dy GM') == true,
    );
    await tester.enterText(occFinder, 'Bank Manager');
    await tester.pumpAndSettle();

    // Mother's Details should now be revealed!
    expect(find.text("MOTHER'S DETAILS"), findsOneWidget);
    expect(find.text("SIBLINGS DETAILS"), findsNothing);

    // 4. Fill Mother's mandatory field (Occupation)
    final motherOccFinder = find.byWidgetPredicate(
      (w) => w is TextField && w.decoration?.hintText?.contains('Homemaker & Carnatic') == true,
    );
    await tester.enterText(motherOccFinder, 'Teacher');
    await tester.pumpAndSettle();

    // Siblings Details should now be revealed!
    expect(find.text("SIBLINGS DETAILS"), findsOneWidget);
    expect(find.text("STRUCTURE & FAMILY VALUES"), findsNothing);

    // 5. Check 'No Siblings'
    await tester.tap(find.text('No Siblings (Only Child)'));
    await tester.pumpAndSettle();

    // Structure & Family Values should now be revealed!
    expect(find.text("STRUCTURE & FAMILY VALUES"), findsOneWidget);
    expect(find.text("LOCATION & NATIVE ROOTS"), findsNothing);

    // 6. Select Family Type & Values
    await tester.tap(find.text('Nuclear Family'));
    await tester.tap(find.text('Moderate'));
    await tester.pumpAndSettle();

    // Location & Native Roots should now be revealed!
    expect(find.text("LOCATION & NATIVE ROOTS"), findsOneWidget);
    expect(find.text("FAMILY AFFLUENCE & ASSETS"), findsNothing);

    // 7. Fill Location & Native Town
    final cityFinder = find.byWidgetPredicate(
      (w) => w is TextField && w.decoration?.hintText?.contains('Chennai, Tamil Nadu') == true,
    );
    final nativeFinder = find.byWidgetPredicate(
      (w) => w is TextField && w.decoration?.hintText?.contains('Thanjavur') == true,
    );
    await tester.enterText(cityFinder, 'Chennai');
    await tester.enterText(nativeFinder, 'Madurai');
    await tester.pumpAndSettle();

    // Family Affluence & Assets should now be revealed!
    expect(find.text("FAMILY AFFLUENCE & ASSETS"), findsOneWidget);

    // 8. Select Affluence Tier & Property Status
    await tester.tap(find.text('Upper Middle'));
    await tester.tap(find.text('Own House / Villa'));
    await tester.pumpAndSettle();

    expect(find.text('256-Bit Encrypted Sacred Matrimonial Charter'), findsOneWidget);

    // Bottom Bar Navigation buttons
    expect(find.text('Previous'), findsOneWidget);
    expect(find.text('Save Draft'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('EducationCareerScreen renders progressive cards correctly', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: EducationCareerScreen(
          mobileNumber: '9842176540',
          countryCode: '+91',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Profile Registration'), findsOneWidget);
    expect(find.text('STEP 3 OF 6'), findsOneWidget);

    // Initially only Education Details card is visible
    expect(find.text('Education Details'), findsOneWidget);
    expect(find.text('Career & Profession'), findsNothing);

    // Select Education Level and enter Degree
    await tester.tap(find.text('Select Education Level'));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Master's / Post Graduate"));
    await tester.pumpAndSettle();

    final degreeFinder = find.byWidgetPredicate(
      (w) => w is TextField && w.decoration?.hintText?.contains('M.S. Software Systems') == true,
    );
    await tester.enterText(degreeFinder, 'M.Tech Computer Science');
    await tester.pumpAndSettle();

    // Career & Profession card should now be revealed!
    expect(find.text('Career & Profession'), findsOneWidget);
    expect(find.text('Annual Income'), findsNothing);

    // Fill Career details
    await tester.tap(find.text('Private / MNC'));
    final designationFinder = find.byWidgetPredicate(
      (w) => w is TextField && w.decoration?.hintText?.contains('Staff Software Engineer') == true,
    );
    final locationFinder = find.byWidgetPredicate(
      (w) => w is TextField && w.decoration?.hintText?.contains('Chennai, Tamil Nadu, India') == true,
    );
    await tester.enterText(designationFinder, 'Software Engineer');
    await tester.enterText(locationFinder, 'Chennai, India');
    await tester.pumpAndSettle();

    // Annual Income card should now be revealed!
    expect(find.text('Annual Income'), findsOneWidget);
    expect(find.text('Citizenship'), findsNothing);

    // Fill Income
    final incomeFinder = find.byWidgetPredicate(
      (w) => w is TextField && w.decoration?.hintText?.contains('25,00,000') == true,
    );
    await tester.enterText(incomeFinder, '2000000');
    await tester.pumpAndSettle();

    // Citizenship card should now be revealed!
    expect(find.text('Citizenship'), findsOneWidget);
    expect(find.text('Lifestyle & Habits'), findsNothing);

    // Select Citizenship
    await tester.tap(find.text('India'));
    await tester.pumpAndSettle();

    // Lifestyle & Habits card should now be revealed!
    expect(find.text('Lifestyle & Habits'), findsOneWidget);
    expect(find.text('Interests & Cultural Outlook'), findsNothing);

    // Fill Lifestyle & Habits
    await tester.tap(find.text('Non-Vegetarian'));
    await tester.tap(find.text('Non-Smoker'));
    await tester.tap(find.text('Non-Drinker'));
    await tester.pumpAndSettle();

    // Interests & Cultural Outlook should now be revealed!
    expect(find.text('Interests & Cultural Outlook'), findsOneWidget);

    // Add hobby & cultural outlook
    await tester.tap(find.text('Carnatic Music'));
    await tester.tap(find.text('Traditional'));
    await tester.pumpAndSettle();

    // Bio card should now be revealed!
    expect(find.text('Few Words About Me'), findsOneWidget);

    // Bottom Bar
    expect(find.text('Previous'), findsOneWidget);
    expect(find.text('Save Draft'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('PhotosPrivacyScreen renders all components according to design', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: PhotosPrivacyScreen(
          mobileNumber: '9842176540',
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 1. App Bar and Step 4 header
    expect(find.text('Profile Registration'), findsOneWidget);
    expect(find.text('STEP 4 OF 6'), findsOneWidget);
    expect(find.text('STEP 4 OF 6 • PHOTOS & PRIVACY'), findsOneWidget);
    expect(find.text('Profile Photos & Moderation'), findsOneWidget);

    // 2. Primary Biodata Portrait Card
    expect(find.text('Primary Biodata Portrait'), findsOneWidget);
    expect(find.text('MANDATORY'), findsOneWidget);
    expect(find.text('GOLDEN RATIO FOCUS'), findsOneWidget);
    expect(find.text('LIVE WATERMARK'), findsOneWidget);
    expect(find.text('Replace'), findsOneWidget);
    expect(find.text('Adjust'), findsOneWidget);
    expect(find.text('Preview'), findsOneWidget);

    // 3. Additional Gallery Section
    expect(find.text('Additional Gallery Photos'), findsOneWidget);
    expect(find.text('DRAG TO REORDER'), findsOneWidget);
    expect(find.text('Traditional Attire'), findsOneWidget);
    expect(find.text('Family / Outdoor'), findsOneWidget);
    expect(find.text('Full Length'), findsOneWidget);
    expect(find.text('Selfie Pose'), findsOneWidget);
    expect(find.text('Family Gathering'), findsOneWidget);

    // 4. Matchmaker Tip & Admin Safety Review
    expect(
      find.byWidgetPredicate((w) => w is RichText && w.text.toPlainText().contains('Matchmaker Tip:')),
      findsOneWidget,
    );
    expect(find.text('Admin Quality & Safety Review'), findsOneWidget);
    expect(find.text('12 HOURS SLA'), findsOneWidget);

    // 5. Security badges & Bottom Action
    expect(find.text('ID Authenticated'), findsOneWidget);
    expect(find.text('EXIF Scrubbed'), findsOneWidget);
    expect(find.text('Encrypted Vault'), findsOneWidget);
    expect(find.text('Continue to Govt ID'), findsOneWidget);
    expect(find.text('Back to Step 4: Family Heritage'), findsOneWidget);
    expect(find.text('Save Draft & Exit'), findsOneWidget);

    // 6. Tap Continue to Govt ID -> Navigates to Step 5
    await tester.tap(find.text('Continue to Govt ID'));
    await tester.pumpAndSettle();

    expect(find.text('STEP 5 OF 6'), findsOneWidget);
    expect(find.text('STEP 5 OF 6 • IDENTITY & GOVT\nVERIFICATION'), findsOneWidget);
    expect(find.text('Government ID Proof'), findsOneWidget);
    expect(find.text('Live Selfie Verification'), findsOneWidget);
    expect(find.text('TAMIL ALLIANCE SACRED OATH'), findsOneWidget);
    expect(find.text('Submit & Finish'), findsOneWidget);
  });

  testWidgets('GovtIdVerificationScreen renders all cards, oath, and actions accurately', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: GovtIdVerificationScreen(
          mobileNumber: '9842176540',
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 1. App Bar and Step 5 Header
    expect(find.text('Profile Registration'), findsOneWidget);
    expect(find.text('STEP 5 OF 6'), findsOneWidget);
    expect(find.text('STEP 5 OF 6 • IDENTITY & GOVT\nVERIFICATION'), findsOneWidget);
    expect(find.text('Trust & Safety'), findsOneWidget);
    expect(find.text('Shield'), findsOneWidget);

    // 2. Card 1: Govt ID Proof (Empty default state)
    expect(find.text('Government ID Proof'), findsOneWidget);
    expect(find.text('Aadhaar, Passport, or Voter ID'), findsOneWidget);
    expect(find.text('Aadhaar Card (UIDAI)'), findsOneWidget);
    expect(find.text('Auto-Masked'), findsOneWidget);
    expect(find.text('Upload Front Side'), findsOneWidget);
    expect(find.text('Upload Back Side'), findsOneWidget);

    // Enter ID Number
    final idInputFinder = find.byType(TextField);
    await tester.enterText(idInputFinder, '5432-8765-9821');
    await tester.pumpAndSettle();
    expect(find.text('5432-8765-9821'), findsOneWidget);

    // Tap Upload Front Side -> opens picker sheet
    await tester.tap(find.text('Upload Front Side'));
    await tester.pumpAndSettle();
    expect(find.text('Take Photo with Camera'), findsOneWidget);
    expect(find.text('Choose from Phone Gallery'), findsOneWidget);

    // Choose Phone Gallery option
    await tester.tap(find.text('Choose from Phone Gallery'));
    await tester.pumpAndSettle();
    expect(find.text('Front Side Uploaded'), findsOneWidget);

    // 3. Card 2: Live Selfie Verification
    expect(find.text('Live Selfie Verification'), findsOneWidget);
    expect(find.text('Quick photo capture to confirm your identity against your submitted ID'), findsOneWidget);
    expect(find.text('Flip'), findsOneWidget);
    expect(find.text('Align face here'), findsOneWidget);
    expect(find.text('Hold the phone at eye level in good lighting'), findsOneWidget);
    expect(find.text('Capture Selfie'), findsOneWidget);

    // 4. Card 3: Sacred Oath
    expect(find.text('TAMIL ALLIANCE SACRED OATH'), findsOneWidget);
    expect(find.textContaining('I solemnly declare that all personal'), findsOneWidget);
    expect(find.textContaining('I agree to uphold the sacred decorum'), findsOneWidget);

    // 5. Actions
    expect(find.text('Submit & Finish'), findsOneWidget);
    expect(find.text('Previous'), findsOneWidget);
    expect(find.text('Save Draft'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
  });
}
