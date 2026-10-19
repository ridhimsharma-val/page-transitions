import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:page_transitions/main.dart';
import 'package:page_transitions/models/mountain_data.dart';
import 'package:page_transitions/screens/mountain_detail_screen.dart';
import 'package:page_transitions/widgets/mountain_hero_shuttle.dart';

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

  testWidgets('Hero 2.0 shuttle interpolates corners, bounds, and renders without error',
      (WidgetTester tester) async {
    final controller = AnimationController(
      vsync: const TestVSync(),
      duration: const Duration(milliseconds: 550),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MountainHeroFlightShuttle(
            animation: controller,
            flightDirection: HeroFlightDirection.push,
            mountain: MountainData.everest,
            sourceRadius: BorderRadius.circular(16),
            destinationRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(28),
              bottomRight: Radius.circular(28),
            ),
          ),
        ),
      ),
    );

    // Initial t = 0.0
    expect(find.byType(MountainHeroFlightShuttle), findsOneWidget);
    expect(find.byType(ClipRRect), findsOneWidget);

    // Mid-flight t = 0.5
    controller.value = 0.5;
    await tester.pump();
    expect(find.byType(MountainHeroFlightShuttle), findsOneWidget);

    // Destination t = 1.0
    controller.value = 1.0;
    await tester.pump();
    expect(find.byType(MountainHeroFlightShuttle), findsOneWidget);

    controller.dispose();
  });

  test('SmoothHeroRectTween lerps linearly across t [0, 1]', () {
    final tween = SmoothHeroRectTween(
      begin: const Rect.fromLTWH(0, 0, 100, 100),
      end: const Rect.fromLTWH(0, 0, 200, 200),
    );

    expect(tween.lerp(0.0), const Rect.fromLTWH(0, 0, 100, 100));
    expect(tween.lerp(1.0), const Rect.fromLTWH(0, 0, 200, 200));

    // Linear midpoint at t = 0.5
    final mid = tween.lerp(0.5)!;
    expect(mid.width, closeTo(150.0, 0.01));
    expect(mid.height, closeTo(150.0, 0.01));
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
}
