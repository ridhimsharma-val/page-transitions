import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:page_transitions/main.dart';
import 'package:page_transitions/models/mountain_data.dart';
import 'package:page_transitions/screens/mountain_detail_screen.dart';
import 'package:page_transitions/transitions/shared_axis_route.dart';

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
}
