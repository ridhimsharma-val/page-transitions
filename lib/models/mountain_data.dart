import 'package:flutter/material.dart';

class GalleryItem {
  final String imageUrl;
  final String title;

  const GalleryItem({
    required this.imageUrl,
    required this.title,
  });
}

class MountainData {
  final String id;
  final String name;
  final String localName;
  final String elevation;
  final String shortElevation;
  final String range;
  final String location;
  final String shortLocation;
  final String firstAscentYear;
  final String firstAscentBy;
  final String baseCampElevation;
  final String mountainType;
  final String description;
  final String imageUrl;
  final List<GalleryItem> galleryItems;
  final Color accentColor;
  final String category;
  final bool hasActiveExpedition;
  final String expeditionRoute;
  final String climbingSeason;
  final List<String> camps;

  const MountainData({
    required this.id,
    required this.name,
    required this.localName,
    required this.elevation,
    required this.shortElevation,
    required this.range,
    required this.location,
    required this.shortLocation,
    required this.firstAscentYear,
    required this.firstAscentBy,
    required this.baseCampElevation,
    this.mountainType = 'Eight-thousander',
    required this.description,
    required this.imageUrl,
    required this.galleryItems,
    required this.accentColor,
    required this.category,
    this.hasActiveExpedition = true,
    required this.expeditionRoute,
    required this.climbingSeason,
    required this.camps,
  });

  List<String> get galleryImages => galleryItems.map((e) => e.imageUrl).toList();

  // 1. Mount Everest (8,848.86 m) — Mahalangur Himal, Nepal / China
  static const MountainData everest = MountainData(
    id: 'everest',
    name: 'Mount Everest',
    localName: 'Sagarmatha • Chomolungma',
    elevation: '8,848.86 m',
    shortElevation: '8,848 m',
    range: 'Himalaya',
    location: 'Nepal / Tibet (China)',
    shortLocation: 'Nepal / China',
    firstAscentYear: '1953',
    firstAscentBy: 'Edmund Hillary & Tenzing Norgay',
    baseCampElevation: '5,364 m (South)',
    mountainType: 'Eight-thousander',
    description:
        'Mount Everest is Earth\'s highest mountain above sea level, standing at 8,848.86 metres. Located in the Mahalangur Himal sub-range of the Himalayas, its summit ridge marks the international border between Nepal and Tibet (China).',
    imageUrl:
        'https://images.unsplash.com/photo-1544735716-392fe2489ffa?q=80&w=1200&auto=format&fit=crop',
    galleryItems: [
      GalleryItem(
        imageUrl:
            'https://images.unsplash.com/photo-1544735716-392fe2489ffa?q=80&w=800&auto=format&fit=crop',
        title: 'Everest Summit Pyramid & Jetstream Plume',
      ),
      GalleryItem(
        imageUrl:
            'https://images.unsplash.com/photo-1585409677983-0f6c41ca0c3b?q=80&w=800&auto=format&fit=crop',
        title: 'Khumbu Glacier & Everest Valley Approach',
      ),
      GalleryItem(
        imageUrl:
            'https://images.unsplash.com/photo-1486870591958-9b9d0d1dda99?q=80&w=800&auto=format&fit=crop',
        title: 'South Base Camp Ridge View',
      ),
    ],
    accentColor: Color(0xFF7C3AED),
    category: 'Himalaya',
    hasActiveExpedition: true,
    expeditionRoute: 'South Col & Southeast Ridge',
    climbingSeason: 'April – May (Pre-Monsoon)',
    camps: [
      'South Base Camp (5,364 m)',
      'Camp I (6,065 m) — Khumbu Icefall',
      'Camp II (6,400 m) — Western Cwm',
      'Camp III (7,200 m) — Lhotse Face',
      'Camp IV / South Col (7,920 m)',
      'Summit (8,848.86 m)',
    ],
  );

  // 2. K2 (8,611 m) — Karakoram Range, Pakistan / China
  static const MountainData k2 = MountainData(
    id: 'k2',
    name: 'K2',
    localName: 'Chhogori • Savage Mountain',
    elevation: '8,611 m',
    shortElevation: '8,611 m',
    range: 'Karakoram',
    location: 'Pakistan / China',
    shortLocation: 'Pakistan / China',
    firstAscentYear: '1954',
    firstAscentBy: 'Achille Compagnoni & Lino Lacedelli',
    baseCampElevation: '5,150 m',
    mountainType: 'Eight-thousander',
    description:
        'K2, at 8,611 metres above sea level, is the second-highest mountain on Earth. Located on the China–Pakistan border in the Karakoram range, it is celebrated as the Savage Mountain due to its extreme technical climbing difficulty and sheer vertical relief.',
    imageUrl:
        'https://images.unsplash.com/photo-1589182373726-e4f658ab50f0?q=80&w=1200&auto=format&fit=crop',
    galleryItems: [
      GalleryItem(
        imageUrl:
            'https://images.unsplash.com/photo-1589182373726-e4f658ab50f0?q=80&w=800&auto=format&fit=crop',
        title: 'K2 North-East Ridge & Godwin-Austen Face',
      ),
      GalleryItem(
        imageUrl:
            'https://images.unsplash.com/photo-1551632811-561732d1e306?q=80&w=800&auto=format&fit=crop',
        title: 'Baltoro Glacier Amphitheatre towards K2',
      ),
      GalleryItem(
        imageUrl:
            'https://images.unsplash.com/photo-1519681393784-d120267933ba?q=80&w=800&auto=format&fit=crop',
        title: 'High Alpine Karakoram Ridge at Sunset',
      ),
    ],
    accentColor: Color(0xFF7C3AED),
    category: 'Karakoram',
    hasActiveExpedition: true,
    expeditionRoute: 'Abruzzi Spur & The Bottleneck',
    climbingSeason: 'June – August (Summer)',
    camps: [
      'Godwin-Austen Base Camp (5,150 m)',
      'Camp I (6,000 m) — Advanced Base',
      'Camp II (6,700 m) — House\'s Chimney',
      'Camp III (7,350 m) — Black Pyramid',
      'Camp IV (8,000 m) — Shoulder',
      'Summit (8,611 m)',
    ],
  );

  // 3. Kangchenjunga (8,586 m) — Kangchenjunga Himal, Nepal / India
  static const MountainData kangchenjunga = MountainData(
    id: 'kangchenjunga',
    name: 'Kangchenjunga',
    localName: 'The Five Treasures of Snow',
    elevation: '8,586 m',
    shortElevation: '8,586 m',
    range: 'Himalaya',
    location: 'Nepal / India (Sikkim)',
    shortLocation: 'Nepal / India',
    firstAscentYear: '1955',
    firstAscentBy: 'Joe Brown & George Band',
    baseCampElevation: '5,143 m',
    mountainType: 'Eight-thousander',
    description:
        'Kangchenjunga is the third-highest mountain in the world, rising to 8,586 metres. Rising along the India–Nepal border, it consists of five distinct glaciated summits revered as sacred by the indigenous peoples of Sikkim and Darjeeling.',
    imageUrl:
        'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?q=80&w=1200&auto=format&fit=crop',
    galleryItems: [
      GalleryItem(
        imageUrl:
            'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?q=80&w=800&auto=format&fit=crop',
        title: 'Kangchenjunga Five Treasures Massif',
      ),
      GalleryItem(
        imageUrl:
            'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=800&auto=format&fit=crop',
        title: 'Sikkim Alpine Dawn over Kangchenjunga',
      ),
      GalleryItem(
        imageUrl:
            'https://images.unsplash.com/photo-1483728642387-6c3bdd6c93e5?q=80&w=800&auto=format&fit=crop',
        title: 'Yalung Glacier Face & West Ridge',
      ),
    ],
    accentColor: Color(0xFF7C3AED),
    category: 'Himalaya',
    hasActiveExpedition: false,
    expeditionRoute: 'Southwest Face (Yalung Glacier)',
    climbingSeason: 'April – May & October',
    camps: [
      'Pangpema Base Camp (5,143 m)',
      'Camp I (6,200 m)',
      'Camp II (7,000 m) — Great Shelf',
      'Camp III (7,600 m)',
      'Camp IV (8,200 m)',
      'Summit Ridge (8,586 m)',
    ],
  );

  // 4. Lhotse (8,516 m) — Mahalangur Himal, Nepal / China
  static const MountainData lhotse = MountainData(
    id: 'lhotse',
    name: 'Lhotse',
    localName: 'South Peak • E1',
    elevation: '8,516 m',
    shortElevation: '8,516 m',
    range: 'Himalaya',
    location: 'Nepal / China (Tibet)',
    shortLocation: 'Nepal / China',
    firstAscentYear: '1956',
    firstAscentBy: 'Ernst Reiss & Fritz Luchsinger',
    baseCampElevation: '5,364 m',
    mountainType: 'Eight-thousander',
    description:
        'Lhotse is the fourth-highest mountain on Earth at 8,516 metres. Connected directly to Mount Everest via the South Col, its sheer South Face rises over 3.2 kilometres, forming one of the most formidable vertical rock-and-ice walls in the high Himalayas.',
    imageUrl:
        'https://images.unsplash.com/photo-1571771019784-3ff35f4f4277?q=80&w=1200&auto=format&fit=crop',
    galleryItems: [
      GalleryItem(
        imageUrl:
            'https://images.unsplash.com/photo-1571771019784-3ff35f4f4277?q=80&w=800&auto=format&fit=crop',
        title: 'Lhotse 3.2 km Sheer South Face',
      ),
      GalleryItem(
        imageUrl:
            'https://images.unsplash.com/photo-1454496522488-7a8e488e8606?q=80&w=800&auto=format&fit=crop',
        title: 'South Col High Wall & Western Cwm',
      ),
      GalleryItem(
        imageUrl:
            'https://images.unsplash.com/photo-1465056836041-7f43ac27dcb5?q=80&w=800&auto=format&fit=crop',
        title: 'Lhotse Couloir Route to Summit',
      ),
    ],
    accentColor: Color(0xFF7C3AED),
    category: 'Himalaya',
    hasActiveExpedition: true,
    expeditionRoute: 'Lhotse Couloir & West Face',
    climbingSeason: 'April – May',
    camps: [
      'Everest South Base Camp (5,364 m)',
      'Camp II (6,400 m) — Western Cwm',
      'Camp III (7,200 m) — Lhotse Face',
      'Camp IV (7,850 m) — Yellow Band',
      'Lhotse Couloir to Summit (8,516 m)',
    ],
  );

  static const List<MountainData> all = [
    everest,
    k2,
    kangchenjunga,
    lhotse,
  ];
}
