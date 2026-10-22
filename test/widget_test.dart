import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:page_transitions/main.dart';
import 'package:page_transitions/models/mountain_data.dart';
import 'package:page_transitions/screens/mountain_detail_screen.dart';
import 'package:page_transitions/screens/zoom_fade_demo/zoom_fade_detail_screen.dart';
import 'package:page_transitions/screens/parallax_demo/parallax_detail_screen.dart';
import 'package:page_transitions/transitions/shared_axis_route.dart';
import 'package:page_transitions/transitions/zoom_fade_route.dart';
import 'package:page_transitions/transitions/parallax_route.dart';
import 'package:page_transitions/transitions/circular_reveal_route.dart';
import 'package:page_transitions/screens/circular_carousel_demo/circular_carousel_explore_screen.dart';

class _MockHttpClient extends Fake implements HttpClient {
  @override
  bool autoUncompress = true;

  @override
  Duration? connectionTimeout;

  @override
  Duration idleTimeout = const Duration(seconds: 15);

  @override
  int? maxConnectionsPerHost;

  @override
  String? userAgent;

  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _MockHttpClientRequest();
}

class _MockHttpClientRequest extends Fake implements HttpClientRequest {
  @override
  final HttpHeaders headers = _MockHttpHeaders();

  @override
  Future<HttpClientResponse> close() async => _MockHttpClientResponse();
}

class _MockHttpHeaders extends Fake implements HttpHeaders {
  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {}

  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {}
}

class _MockHttpClientResponse extends Fake implements HttpClientResponse {
  @override
  int get statusCode => 200;

  @override
  int get contentLength => _transparentImage.length;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.value(_transparentImage).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}

class _TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) => _MockHttpClient();
}

final List<int> _transparentImage = [
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49,
  0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x08, 0x06,
  0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44,
  0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00, 0x05, 0x00, 0x01, 0x0D,
  0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42,
  0x60, 0x82,
];

void main() {
  setUpAll(() {
    HttpOverrides.global = _TestHttpOverrides();
  });

  testWidgets('Minimal mountain experience testing navigation, hero, and cleaned UI',
      (WidgetTester tester) async {
    await tester.pumpWidget(const PageTransitionsApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // 1. Verify Explore Designs entry page
    expect(find.text('Explore Designs'), findsOneWidget);
    expect(find.text('World Above 8,000 Metres'), findsOneWidget);

    // 2. Tap on "World Above 8,000 Metres" card to navigate to MountainPage
    await tester.tap(find.text('World Above 8,000 Metres'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));

    // 3. Verify MountainPage elements
    expect(find.text('World Above'), findsOneWidget);
    expect(find.text('8,000 Metres'), findsOneWidget);
    expect(find.text('Explore the highest peaks on Earth, one story at a time.'), findsOneWidget);

    // Verify removed header/category elements are NOT present on MountainPage
    expect(find.text('MOTION • LAB'), findsNothing);
    expect(find.text('All'), findsNothing);
    expect(find.text('Himalaya'), findsNothing);
    expect(find.text('Karakoram'), findsNothing);
    expect(find.text('Expeditions'), findsNothing);
    expect(find.byIcon(Icons.search), findsNothing);

    // Verify all 4 peaks exist in the mountain grid
    expect(find.text('Mount Everest'), findsOneWidget);
    expect(find.text('K2'), findsOneWidget);
    expect(find.text('Kangchenjunga'), findsOneWidget);
    expect(find.text('Lhotse'), findsOneWidget);

    // ==========================================
    // TEST 1: MOUNT EVEREST DETAIL
    // ==========================================
    await tester.tap(find.text('Mount Everest'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));

    // Verify essential elements
    expect(find.text('Mount Everest'), findsWidgets);
    expect(find.text('8,848 m'), findsWidgets);
    expect(find.text('Elevation'), findsOneWidget);
    expect(find.text('Nepal / China'), findsWidgets);

    // Verify removed elements are NOT present on detail screen
    expect(find.text('Gallery'), findsNothing);
    expect(find.text('View Expedition Details'), findsNothing);
    expect(find.text('Geographic Range'), findsNothing);
    expect(find.text('Reverse Transition'), findsNothing);
    expect(find.byIcon(Icons.more_vert), findsNothing);

    // Verify back button and favorite button are present
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.byIcon(Icons.favorite), findsWidgets);

    // Tap favorite button to toggle (on detail screen)
    await tester.tap(find.byIcon(Icons.favorite).last);
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.favorite_border), findsWidgets);

    // Back to MountainPage via back button
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('World Above'), findsOneWidget);

    // ==========================================
    // TEST 2: K2 DETAIL
    // ==========================================
    await tester.tap(find.text('K2'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('K2'), findsWidgets);
    expect(find.text('8,611 m'), findsWidgets);
    expect(find.text('Pakistan / China'), findsWidgets);
    expect(
      find.descendant(
        of: find.byType(MountainDetailScreen),
        matching: find.text('Mount Everest'),
      ),
      findsNothing,
    );
    expect(find.byIcon(Icons.more_vert), findsNothing);

    // Back to MountainPage
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('World Above'), findsOneWidget);

    // ==========================================
    // TEST 3: KANGCHENJUNGA DETAIL
    // ==========================================
    await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -250));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Kangchenjunga'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('Kangchenjunga'), findsWidgets);
    expect(find.text('8,586 m'), findsWidgets);
    expect(find.text('Nepal / India'), findsWidgets);
    expect(
      find.descendant(
        of: find.byType(MountainDetailScreen),
        matching: find.text('8,611 m'),
      ),
      findsNothing,
    );

    // Back to MountainPage
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('World Above'), findsOneWidget);

    // ==========================================
    // TEST 4: LHOTSE DETAIL
    // ==========================================
    await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -250));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Lhotse'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('Lhotse'), findsWidgets);
    expect(find.text('8,516 m'), findsWidgets);
    expect(
      find.descendant(
        of: find.byType(MountainDetailScreen),
        matching: find.text('8,586 m'),
      ),
      findsNothing,
    );

    // Back to MountainPage
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('World Above'), findsOneWidget);
  });

  testWidgets('MountainDetailScreen respects disableAnimations / reduced motion',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MediaQuery(
        data: MediaQueryData(disableAnimations: true),
        child: MaterialApp(
          home: MountainDetailScreen(
            mountain: MountainData.k2,
          ),
        ),
      ),
    );

    await tester.pump();

    // All content should be fully visible immediately without delay
    expect(find.text('K2'), findsWidgets);
    expect(find.text('8,611 m'), findsWidgets);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
  });

  testWidgets('Design 02 — Shared-Axis Transition forward and reverse navigation',
      (WidgetTester tester) async {
    await tester.pumpWidget(const PageTransitionsApp());
    await tester.pumpAndSettle();

    // 1. Verify Design 02 card exists on ExploreDesignsScreen
    expect(find.text('Shared-Axis Transition'), findsOneWidget);
    expect(find.text('Design 02 • Motion'), findsOneWidget);

    // 2. Scroll and open Design 02 (SharedAxisExploreScreen)
    await tester.ensureVisible(find.text('Shared-Axis Transition'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Shared-Axis Transition'));
    await tester.pumpAndSettle();

    // 3. Verify Screen A (SharedAxisExploreScreen) elements
    expect(find.text('PEAKS'), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Discover the world\'s highest mountains.'), findsOneWidget);
    expect(find.text('Mount Everest'), findsOneWidget);
    expect(find.text('Explore Mountain'), findsOneWidget);
    expect(find.text('K2'), findsOneWidget);
    expect(find.text('Kangchenjunga'), findsOneWidget);
    // Profile icon must be removed
    expect(find.byIcon(Icons.person_outline_rounded), findsNothing);

    // 4. Test forward navigation via "Explore Mountain" button
    await tester.tap(find.text('Explore Mountain'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    // 5. Verify Screen B (SharedAxisDetailScreen) elements
    expect(find.text('Mountain Details'), findsOneWidget);
    expect(find.text('Highest mountain above sea level'), findsOneWidget);
    expect(find.text('Expedition Overview'), findsOneWidget);
    // "Back to Explore" button must be removed from every mountain details screen
    expect(find.text('Back to Explore'), findsNothing);

    // 6. Test reverse navigation via back icon
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 450));
    await tester.pumpAndSettle();

    // Verify back on Screen A
    expect(find.text('PEAKS'), findsOneWidget);
    expect(find.text('Explore Mountain'), findsOneWidget);

    // 7. Test forward navigation via card tap
    await tester.tap(find.text('Mount Everest'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(find.text('Mountain Details'), findsOneWidget);
    expect(find.text('Back to Explore'), findsNothing);

    // 8. Test reverse navigation via top back icon
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 450));
    await tester.pumpAndSettle();

    expect(find.text('PEAKS'), findsOneWidget);
  });

  testWidgets('SharedAxisTransition mathematical transform verification',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    SharedAxisPageRoute(
                      page: const Scaffold(body: Text('Destination Screen')),
                    ),
                  );
                },
                child: const Text('Open'),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pump(); // Start transition

    // 1. Advance to 225ms (exactly 50% of 450ms forward transition)
    await tester.pump(const Duration(milliseconds: 225));

    // Verify both SlideTransition widgets are actively in flight
    final slideFinders = find.byType(SlideTransition);
    expect(slideFinders, findsWidgets);

    // Verify FadeTransition widgets exist and are active
    final fadeFinders = find.byType(FadeTransition);
    expect(fadeFinders, findsWidgets);

    // 2. Complete forward transition
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pumpAndSettle();
    expect(find.text('Destination Screen'), findsOneWidget);

    // 3. Initiate reverse transition
    final nav = tester.state<NavigatorState>(find.byType(Navigator));
    nav.pop();
    await tester.pump(); // Start reverse

    // 4. Advance to 200ms (exactly 50% of 400ms reverse transition)
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.byType(SlideTransition), findsWidgets);
    expect(find.byType(FadeTransition), findsWidgets);

    // 5. Complete reverse transition
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pumpAndSettle();

    expect(find.text('Open'), findsOneWidget);
    expect(find.text('Destination Screen'), findsNothing);
  });

  testWidgets('Design 02 — Sequential slide-and-fade timing and zero overlap verification',
      (WidgetTester tester) async {
    await tester.pumpWidget(const PageTransitionsApp());
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Shared-Axis Transition'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Shared-Axis Transition'));
    await tester.pumpAndSettle();

    // Tap Explore Mountain to trigger forward transition (450ms)
    await tester.tap(find.text('Explore Mountain'));
    await tester.pump(); // frame 0: t=0.0

    final detailFadeFinder = find.descendant(
      of: find.byType(SharedAxisTransition),
      matching: find.byType(FadeTransition),
    );
    final exploreFadeFinder = find.descendant(
      of: find.byType(SharedAxisPageWrapper),
      matching: find.byType(FadeTransition),
    );

    double detailOpacity() {
      final list = tester.widgetList<FadeTransition>(detailFadeFinder);
      return list.last.opacity.value;
    }

    double exploreOpacity() {
      return tester.firstWidget<FadeTransition>(exploreFadeFinder).opacity.value;
    }

    // Phase A: 100ms in forward
    await tester.pump(const Duration(milliseconds: 100));
    // Details route must have 0.0 opacity while Explore is exiting
    expect(detailOpacity(), 0.0);
    expect(exploreOpacity(), greaterThan(0.0));

    // Handoff: 225ms in forward (50% progress)
    await tester.pump(const Duration(milliseconds: 125));
    // Both Explore and Details should be 0.0 during hand-off buffer
    expect(detailOpacity(), 0.0);
    expect(exploreOpacity(), 0.0);

    // Phase B: 350ms in forward
    await tester.pump(const Duration(milliseconds: 125));
    // Explore is 0.0, Details is entering (> 0.0)
    expect(exploreOpacity(), 0.0);
    expect(detailOpacity(), greaterThan(0.0));

    // Finish forward transition
    await tester.pump(const Duration(milliseconds: 150));
    await tester.pumpAndSettle();
    expect(find.text('Mountain Details'), findsOneWidget);

    // Reverse transition: Tap back button
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pump(); // frame 0 of reverse

    // Reverse Phase A: 100ms into reverse (t ~ 0.75)
    await tester.pump(const Duration(milliseconds: 100));
    // Explore must be 0.0 while Details is exiting
    expect(exploreOpacity(), 0.0);
    expect(detailOpacity(), greaterThan(0.0));

    // Reverse Handoff boundary: 200ms into reverse (50% progress, t = 0.50)
    await tester.pump(const Duration(milliseconds: 100));
    // Details has reached exactly 0.0 opacity
    expect(detailOpacity(), 0.0);
    expect(exploreOpacity(), 0.0);

    // Immediately after boundary: 210ms into reverse (t = 0.475)
    await tester.pump(const Duration(milliseconds: 10));
    // Details remains 0.0, and Explore immediately begins entering with zero pause
    expect(detailOpacity(), 0.0);
    expect(exploreOpacity(), greaterThan(0.0));

    // Reverse Phase B: 320ms into reverse (t ~ 0.20)
    await tester.pump(const Duration(milliseconds: 110));
    // Details is 0.0, Explore is well in flight (> 0.0)
    expect(detailOpacity(), 0.0);
    expect(exploreOpacity(), greaterThan(0.0));

    // Finish reverse transition
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle();
    expect(find.text('PEAKS'), findsOneWidget);
    expect(find.text('Mountain Details'), findsNothing);
  });

  testWidgets('Design 03 — Zoom & Fade Transition gallery integration and dynamic navigation',
      (WidgetTester tester) async {
    await tester.pumpWidget(const PageTransitionsApp());
    await tester.pumpAndSettle();

    // 1. Verify Design 03 card exists on ExploreDesignsScreen
    expect(find.text('Design 03 — Zoom & Fade Transition'), findsOneWidget);
    expect(find.text('Design 03 • Motion'), findsOneWidget);

    // 2. Open Design 03 (ZoomFadeExploreScreen)
    await tester.ensureVisible(find.text('Design 03 — Zoom & Fade Transition'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Design 03 — Zoom & Fade Transition'));
    await tester.pumpAndSettle();

    // 3. Verify Screen A (ZoomFadeExploreScreen) elements
    expect(find.text('PEAKS'), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Discover the world\'s highest mountains.'), findsOneWidget);
    expect(find.text('Mount Everest'), findsOneWidget);
    expect(find.text('Explore Mountain'), findsOneWidget);
    expect(find.text('Other Peaks'), findsOneWidget);
    expect(find.text('Other Notable Peaks'), findsNothing);
    expect(find.text('K2'), findsOneWidget);
    expect(find.text('Kangchenjunga'), findsOneWidget);
    expect(find.text('Lhotse'), findsOneWidget);

    // Filter row chips and profile icon must not be present
    expect(find.text('8,000m'), findsNothing);
    expect(find.byIcon(Icons.person_outline_rounded), findsNothing);

    // 4. Test forward navigation via "Explore Mountain" button (Mount Everest)
    await tester.tap(find.text('Explore Mountain'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    // 5. Verify Mount Everest details screen
    expect(find.text('Mountain Details'), findsOneWidget);
    expect(find.text('Mount Everest'), findsWidgets);
    expect(find.text('8,848 m'), findsWidgets);
    expect(find.text('Himalaya'), findsWidgets);
    expect(find.text('Expedition Overview'), findsOneWidget);
    expect(find.text('Back to Explore'), findsNothing);

    // 6. Test reverse navigation via top circular back icon
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 450));
    await tester.pumpAndSettle();

    // Verify returned to Screen A
    expect(find.text('PEAKS'), findsOneWidget);
    expect(find.text('Explore Mountain'), findsOneWidget);

    // 7. Test forward navigation to K2 (verifying dynamic data per mountain)
    await tester.ensureVisible(find.text('K2'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('K2'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    // Verify K2 details (not hardcoded Everest data)
    expect(find.text('Mountain Details'), findsOneWidget);
    expect(find.text('K2'), findsWidgets);
    expect(find.text('8,611 m'), findsWidgets);
    expect(find.text('Karakoram'), findsWidgets);
    expect(find.text('Back to Explore'), findsNothing);

    // 8. Test reverse navigation back to Explore
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 450));
    await tester.pumpAndSettle();

    expect(find.text('PEAKS'), findsOneWidget);
  });

  testWidgets('Design 03 — ZoomFadeTransition scale, opacity endpoints and reduced motion',
      (WidgetTester tester) async {
    // Test reduced motion
    await tester.pumpWidget(
      const MediaQuery(
        data: MediaQueryData(disableAnimations: true),
        child: MaterialApp(
          home: ZoomFadeDetailScreen(mountain: MountainData.everest),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Mount Everest'), findsWidgets);
    expect(find.text('8,848 m'), findsWidgets);
  });

  testWidgets('Design 03 — ZoomFadeTransition mathematical scale and opacity endpoints',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    ZoomFadePageRoute(
                      page: const Scaffold(body: Text('Zoom Destination')),
                    ),
                  );
                },
                child: const Text('Open Zoom'),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open Zoom'));
    await tester.pump(); // dispatches tap and pushes route
    await tester.pump(); // builds the route at t=0.0

    // Find ScaleTransition and FadeTransition of ZoomFadeTransition
    final inScaleFinder = find.byWidgetPredicate(
      (w) => w is ScaleTransition && w.child is FadeTransition,
    );
    final inFadeFinder = find.descendant(
      of: inScaleFinder,
      matching: find.byType(FadeTransition),
    );

    double currentScale() {
      return tester.widgetList<ScaleTransition>(inScaleFinder).last.scale.value;
    }
    double currentOpacity() {
      return tester.widgetList<FadeTransition>(inFadeFinder).last.opacity.value;
    }

    // Initial state: primary incoming scale 0.92, opacity 0.0
    expect(currentScale(), closeTo(0.92, 0.005));
    expect(currentOpacity(), 0.0);

    // During the subtle 8% delay window (~25ms into the 450ms forward transition)
    await tester.pump(const Duration(milliseconds: 25));
    expect(currentScale(), closeTo(0.92, 0.005));

    // 50% transition progress: 225ms (25ms + 200ms)
    await tester.pump(const Duration(milliseconds: 200));
    expect(currentScale(), greaterThan(0.92));
    expect(currentScale(), lessThan(1.00));
    expect(currentOpacity(), greaterThan(0.0));

    // Finish forward transition: 450ms total
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pumpAndSettle();

    // Final state: scale 1.00, opacity 1.0
    expect(currentScale(), 1.0);
    expect(currentOpacity(), 1.0);
    expect(find.text('Zoom Destination'), findsOneWidget);

    // Reverse transition
    final nav = tester.state<NavigatorState>(find.byType(Navigator));
    nav.pop();
    await tester.pump(); // start reverse

    // Advance 200ms (50% of 400ms reverse)
    await tester.pump(const Duration(milliseconds: 200));
    expect(currentScale(), lessThan(1.0));
    expect(currentScale(), greaterThan(0.92));

    // Finish reverse
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pumpAndSettle();

    expect(find.text('Open Zoom'), findsOneWidget);
    expect(find.text('Zoom Destination'), findsNothing);
  });

  testWidgets('Design 04 — Parallax Depth gallery integration, forward and reverse navigation',
      (WidgetTester tester) async {
    await tester.pumpWidget(const PageTransitionsApp());
    await tester.pumpAndSettle();

    // 1. Verify Design 04 card exists on ExploreDesignsScreen
    expect(find.text('Design 04 — Parallax Depth'), findsOneWidget);
    expect(find.text('Design 04 • Motion'), findsOneWidget);

    // 2. Open Design 04 (ParallaxExploreScreen)
    await tester.ensureVisible(find.text('Design 04 — Parallax Depth'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Design 04 — Parallax Depth'));
    await tester.pumpAndSettle();

    // 3. Verify Screen A (ParallaxExploreScreen) elements
    expect(find.text('PEAKS'), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Discover the world\'s highest mountains.'), findsOneWidget);
    expect(find.text('Mount Everest'), findsOneWidget);
    expect(find.text('Explore Mountain'), findsOneWidget);
    expect(find.text('Other Peaks'), findsOneWidget);
    expect(find.text('K2'), findsOneWidget);
    expect(find.text('Kangchenjunga'), findsOneWidget);
    expect(find.text('Lhotse'), findsOneWidget);

    // Filter row chips and profile icon must not be present
    expect(find.text('8,000m'), findsNothing);
    expect(find.byIcon(Icons.person_outline_rounded), findsNothing);

    // 4. Test forward navigation via "Explore Mountain" button (Mount Everest)
    await tester.tap(find.text('Explore Mountain'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 750));
    await tester.pumpAndSettle();

    // 5. Verify Mount Everest details screen
    expect(find.text('Mountain Details'), findsOneWidget);
    expect(find.text('Mount Everest'), findsWidgets);
    expect(find.text('8,848 m'), findsWidgets);
    expect(find.text('Himalaya'), findsWidgets);
    expect(find.text('Expedition Overview'), findsOneWidget);

    // 6. Test reverse navigation via circular back icon
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    // Verify returned to Screen A
    expect(find.text('PEAKS'), findsOneWidget);
    expect(find.text('Explore Mountain'), findsOneWidget);

    // 7. Test forward navigation to K2
    await tester.ensureVisible(find.text('K2'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('K2'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 750));
    await tester.pumpAndSettle();

    // Verify K2 details
    expect(find.text('Mountain Details'), findsOneWidget);
    expect(find.text('K2'), findsWidgets);
    expect(find.text('8,611 m'), findsWidgets);
    expect(find.text('Karakoram'), findsWidgets);

    // 8. Test reverse navigation back to Explore
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    expect(find.text('PEAKS'), findsOneWidget);

    // 9. Test forward navigation to Kangchenjunga
    await tester.ensureVisible(find.text('Kangchenjunga'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kangchenjunga'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 750));
    await tester.pumpAndSettle();

    // Verify Kangchenjunga details
    expect(find.text('Mountain Details'), findsOneWidget);
    expect(find.text('Kangchenjunga'), findsWidgets);
    expect(find.text('8,586 m'), findsWidgets);
    expect(find.text('Himalaya'), findsWidgets);

    // Reverse back to Explore
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    expect(find.text('PEAKS'), findsOneWidget);
  });

  testWidgets('Design 04 — ParallaxDetailScreen multi-layered differential motion and reduced motion',
      (WidgetTester tester) async {
    // 1. Test reduced motion accessibility
    await tester.pumpWidget(
      const MediaQuery(
        data: MediaQueryData(disableAnimations: true),
        child: MaterialApp(
          home: ParallaxDetailScreen(mountain: MountainData.everest),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Mount Everest'), findsWidgets);
    expect(find.text('8,848 m'), findsWidgets);

    // 2. Test route transition duration properties
    final route = ParallaxPageRoute(
      page: const ParallaxDetailScreen(mountain: MountainData.everest),
    );
    expect(route.transitionDuration, const Duration(milliseconds: 700));
    expect(route.reverseTransitionDuration, const Duration(milliseconds: 550));
  });

  testWidgets('Design 04 — Trace animation values and verify no missing content at test points',
      (WidgetTester tester) async {
    late AnimationController controller;
    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) {
            return Builder(
              builder: (ctx) {
                return Scaffold(
                  body: ElevatedButton(
                    onPressed: () {
                      final tickerProvider = Navigator.of(ctx);
                      controller = AnimationController(
                        vsync: tickerProvider,
                        duration: const Duration(milliseconds: 700),
                        reverseDuration: const Duration(milliseconds: 550),
                      );
                      Navigator.of(ctx).push(
                        MaterialPageRoute(
                          builder: (_) => ParallaxDetailScreen(
                            mountain: MountainData.everest,
                            animation: controller,
                          ),
                        ),
                      );
                    },
                    child: const Text('Open'),
                  ),
                );
              },
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    // Trace at 0.12, 0.22, 0.50, 0.85, 0.92, 1.0
    controller.value = 0.12;
    await tester.pump();
    // At t=0.12, Mount Everest title and Expedition Overview must be rendered and visible
    expect(find.text('Mount Everest'), findsWidgets);
    expect(find.text('Expedition Overview'), findsOneWidget);

    controller.value = 0.22;
    await tester.pump();
    expect(find.text('Mount Everest'), findsWidgets);
    expect(find.text('Expedition Overview'), findsOneWidget);

    controller.value = 0.50;
    await tester.pump();
    expect(find.text('Mount Everest'), findsWidgets);
    expect(find.text('Expedition Overview'), findsOneWidget);

    controller.value = 0.85;
    await tester.pump();
    expect(find.text('Mount Everest'), findsWidgets);
    expect(find.text('Expedition Overview'), findsOneWidget);

    controller.value = 0.92;
    await tester.pump();
    expect(find.text('Mount Everest'), findsWidgets);
    expect(find.text('Expedition Overview'), findsOneWidget);

    controller.value = 1.0;
    await tester.pump();
    expect(find.text('Mount Everest'), findsWidgets);
    expect(find.text('Expedition Overview'), findsOneWidget);
    expect(find.text('8,848 m'), findsWidgets);

    // Test reverse at 0.50, 0.22, 0.12
    controller.reverse();
    controller.value = 0.50;
    await tester.pump();
    expect(find.text('Mount Everest'), findsWidgets);
    expect(find.text('Expedition Overview'), findsOneWidget);

    controller.value = 0.22;
    await tester.pump();
    expect(find.text('Mount Everest'), findsWidgets);
    expect(find.text('Expedition Overview'), findsOneWidget);

    controller.value = 0.12;
    await tester.pump();
    expect(find.text('Mount Everest'), findsWidgets);
    expect(find.text('Expedition Overview'), findsOneWidget);
  });

  testWidgets('Design 04 — Coordinated reverse opacity and constant forward photo opacity',
      (WidgetTester tester) async {
    late AnimationController controller;
    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) {
            return Builder(
              builder: (ctx) {
                return Scaffold(
                  body: ElevatedButton(
                    onPressed: () {
                      final tickerProvider = Navigator.of(ctx);
                      controller = AnimationController(
                        vsync: tickerProvider,
                        duration: const Duration(milliseconds: 700),
                        reverseDuration: const Duration(milliseconds: 550),
                      );
                      Navigator.of(ctx).push(
                        MaterialPageRoute(
                          builder: (_) => ParallaxDetailScreen(
                            mountain: MountainData.everest,
                            animation: controller,
                          ),
                        ),
                      );
                    },
                    child: const Text('Open'),
                  ),
                );
              },
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    // 1. Forward motion: photo opacity must remain constant 1.0
    controller.forward();
    controller.value = 0.50;
    await tester.pump();

    // Find the opacity wrapping the photo container (height: 230)
    final photoContainerFinder = find.byWidgetPredicate(
      (w) => w is Container && w.constraints?.maxHeight == 230,
    );
    expect(photoContainerFinder, findsOneWidget);
    final photoOpacityForward = tester
        .widget<Opacity>(
          find.ancestor(of: photoContainerFinder, matching: find.byType(Opacity)).first,
        )
        .opacity;
    expect(photoOpacityForward, 1.0);

    // 2. Reverse motion: photo opacity must fade smoothly, reaching 0.0 at t=0.0
    controller.reverse();
    controller.value = 1.0;
    await tester.pump();
    final photoOpacityReverse100 = tester
        .widget<Opacity>(
          find.ancestor(of: photoContainerFinder, matching: find.byType(Opacity)).first,
        )
        .opacity;
    expect(photoOpacityReverse100, 1.0);

    controller.value = 0.50;
    await tester.pump();
    final photoOpacityReverse50 = tester
        .widget<Opacity>(
          find.ancestor(of: photoContainerFinder, matching: find.byType(Opacity)).first,
        )
        .opacity;
    expect(photoOpacityReverse50, greaterThan(0.5));
    expect(photoOpacityReverse50, lessThan(0.8));

    controller.value = 0.0;
    await tester.pump();
    final photoOpacityReverse0 = tester
        .widget<Opacity>(
          find.ancestor(of: photoContainerFinder, matching: find.byType(Opacity)).first,
        )
        .opacity;
    expect(photoOpacityReverse0, 0.0);
  });

  test('Design 05 — CircularRevealClipper geometric calculation and safety margin', () {
    const size = Size(400, 800);
    const origin = Offset(200, 400);

    final clipper = CircularRevealClipper(
      progress: 0.0,
      origin: origin,
    );
    final emptyPath = clipper.getClip(size);
    expect(emptyPath.getBounds().isEmpty, isTrue);

    // Mid-progress
    final midClipper = CircularRevealClipper(
      progress: 0.5,
      origin: origin,
    );
    final midPath = midClipper.getClip(size);
    final midBounds = midPath.getBounds();
    expect(midBounds.isEmpty, isFalse);
    expect(midBounds.center.dx, closeTo(200, 1.0));
    expect(midBounds.center.dy, closeTo(400, 1.0));

    // Full progress: bounds cover whole viewport (0, 0, 400, 800)
    final fullClipper = CircularRevealClipper(
      progress: 1.0,
      origin: origin,
    );
    final fullBounds = fullClipper.getClip(size).getBounds();
    expect(fullBounds.left, 0.0);
    expect(fullBounds.top, 0.0);
    expect(fullBounds.right, 400.0);
    expect(fullBounds.bottom, 800.0);
  });

  test('Design 05 — CircularRevealPageRoute configuration properties', () {
    final route = CircularRevealPageRoute(
      page: const MountainDetailScreen(mountain: MountainData.everest),
    );
    expect(route.transitionDuration, const Duration(milliseconds: 650));
    expect(route.reverseTransitionDuration, const Duration(milliseconds: 500));
    expect(route.opaque, isFalse);
  });

  testWidgets('Design 05 — CircularCarouselExploreScreen renders, responsive sizing, and swipe',
      (WidgetTester tester) async {
    // 1. Test normal viewport
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const MaterialApp(
        home: CircularCarouselExploreScreen(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Verify initial active mountain is Mount Everest
    expect(find.text('DESIGN 05 • CIRCULAR CAROUSEL'), findsOneWidget);
    expect(find.text('Explore Peaks'), findsOneWidget);
    expect(find.text('Mount Everest'), findsWidgets);
    expect(find.text('8,848 m'), findsWidgets);

    // 2. Swipe left to navigate to K2
    await tester.drag(find.byType(PageView), const Offset(-250, 0));
    await tester.pumpAndSettle();

    // Verify selection changed to K2
    expect(find.text('K2'), findsWidgets);
    expect(find.text('8,611 m'), findsWidgets);

    // 3. Test responsive layout on narrow width (320px) without overflow
    await tester.binding.setSurfaceSize(const Size(320, 600));
    await tester.pump();
    expect(tester.takeException(), isNull);

    // 4. Test responsive layout on wide tablet width (800px) without overflow
    await tester.binding.setSurfaceSize(const Size(800, 1000));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('Design 05 — Circular reveal forward, details inspection, and reverse restoration',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const MaterialApp(
        home: CircularCarouselExploreScreen(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // 1. Tap selected card (Mount Everest) to trigger circular reveal
    await tester.tap(find.text('Mount Everest').first);
    await tester.pump();

    // During transition at 325ms (halfway)
    await tester.pump(const Duration(milliseconds: 325));
    // Verify both screens exist in tree during reveal
    expect(find.byType(MountainDetailScreen), findsOneWidget);
    expect(find.byType(CircularCarouselExploreScreen), findsOneWidget);

    // Complete forward reveal transition (650ms total)
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    // Verify MountainDetailScreen is displayed for Mount Everest
    expect(find.byType(MountainDetailScreen), findsOneWidget);
    expect(find.text('Mount Everest'), findsWidgets);

    // 2. Reverse navigation via back button
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pump();

    // Halfway reverse transition (250ms of 500ms)
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.byType(CircularCarouselExploreScreen), findsOneWidget);

    // Complete reverse transition
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    // Verify returned to Explore screen and Mount Everest is still selected
    expect(find.byType(MountainDetailScreen), findsNothing);
    expect(find.text('Explore Peaks'), findsOneWidget);
    expect(find.text('Mount Everest'), findsWidgets);

    // 3. Test second open-and-back cycle (K2)
    await tester.drag(find.byType(PageView), const Offset(-250, 0));
    await tester.pumpAndSettle();

    // Tap Details action button for K2
    await tester.tap(find.text('Details'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();

    // Verify K2 details
    expect(find.byType(MountainDetailScreen), findsOneWidget);
    expect(find.text('K2'), findsWidgets);

    // Pop back
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 550));
    await tester.pumpAndSettle();

    // Verify K2 remains the active mountain upon return
    expect(find.byType(CircularCarouselExploreScreen), findsOneWidget);
    expect(find.text('K2'), findsWidgets);
  });

  testWidgets('Design 05 — Gallery integration from ExploreDesignsScreen to CircularCarouselExploreScreen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const PageTransitionsApp());
    await tester.pumpAndSettle();

    // Verify Design 05 card is visible and scroll to it
    expect(find.text('Explore Designs'), findsOneWidget);
    await tester.ensureVisible(find.text('Design 05 — Circular Carousel'));
    await tester.pumpAndSettle();

    // Tap Design 05 card to open CircularCarouselExploreScreen
    await tester.tap(find.text('Design 05 — Circular Carousel'));
    await tester.pumpAndSettle();

    // Verify CircularCarouselExploreScreen is opened
    expect(find.byType(CircularCarouselExploreScreen), findsOneWidget);
    expect(find.text('Explore Peaks'), findsOneWidget);
    expect(find.text('Mount Everest'), findsWidgets);

    // Tap back button to return to gallery
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Explore Designs'), findsOneWidget);
  });

  testWidgets('Design 05 — Infinite looping bidirectional navigation and wraparound verification',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CircularCarouselExploreScreen(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Initially at Everest
    expect(find.text('Mount Everest'), findsWidgets);
    expect(find.text('8,848 m'), findsWidgets);

    // 1. Swipe BACKWARD (drag right Offset(250, 0)) from Everest -> wraps around to Lhotse!
    await tester.drag(find.byType(PageView), const Offset(250, 0));
    await tester.pumpAndSettle();

    // Verify Lhotse is now active
    expect(find.text('Lhotse'), findsWidgets);
    expect(find.text('8,516 m'), findsWidgets);

    // 2. Swipe BACKWARD again -> Kangchenjunga!
    await tester.drag(find.byType(PageView), const Offset(250, 0));
    await tester.pumpAndSettle();

    expect(find.text('Kangchenjunga'), findsWidgets);
    expect(find.text('8,586 m'), findsWidgets);

    // 3. Swipe FORWARD (drag left Offset(-250, 0)) -> back to Lhotse!
    await tester.drag(find.byType(PageView), const Offset(-250, 0));
    await tester.pumpAndSettle();

    expect(find.text('Lhotse'), findsWidgets);
    expect(find.text('8,516 m'), findsWidgets);

    // 4. Swipe FORWARD again -> Everest!
    await tester.drag(find.byType(PageView), const Offset(-250, 0));
    await tester.pumpAndSettle();

    expect(find.text('Mount Everest'), findsWidgets);
    expect(find.text('8,848 m'), findsWidgets);

    // 5. Swipe FORWARD through entire list: K2 -> Kangchenjunga -> Lhotse -> Everest
    await tester.drag(find.byType(PageView), const Offset(-250, 0));
    await tester.pumpAndSettle();
    expect(find.text('K2'), findsWidgets);

    await tester.drag(find.byType(PageView), const Offset(-250, 0));
    await tester.pumpAndSettle();
    expect(find.text('Kangchenjunga'), findsWidgets);

    await tester.drag(find.byType(PageView), const Offset(-250, 0));
    await tester.pumpAndSettle();
    expect(find.text('Lhotse'), findsWidgets);

    await tester.drag(find.byType(PageView), const Offset(-250, 0));
    await tester.pumpAndSettle();
    // Reached Everest again after a full forward loop
    expect(find.text('Mount Everest'), findsWidgets);
    expect(find.text('8,848 m'), findsWidgets);

    // 6. Open Details from the wrapped position and return
    await tester.tap(find.text('Details'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();

    expect(find.byType(MountainDetailScreen), findsOneWidget);
    expect(find.text('Mount Everest'), findsWidgets);

    // Return to carousel
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 550));
    await tester.pumpAndSettle();

    // Verify still at Everest and looping remains intact
    expect(find.byType(CircularCarouselExploreScreen), findsOneWidget);
    expect(find.text('Mount Everest'), findsWidgets);

    // Can still swipe backward immediately to Lhotse
    await tester.drag(find.byType(PageView), const Offset(250, 0));
    await tester.pumpAndSettle();
    expect(find.text('Lhotse'), findsWidgets);
    expect(find.text('8,516 m'), findsWidgets);
  });
}
