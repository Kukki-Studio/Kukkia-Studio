import 'package:flutter/material.dart';

const List<AnimeModel> animeModels = [
  AnimeModel(
    id: 'kukki_01',
    name: 'Kukki',
    personality: 'Deredere',
    desc: 'Ceria, hangat, dan selalu ada untukmu. Teman setia yang tak pernah bosan mendengarmu.',
    imagePath: _logo,
    accentColor: Color(0xFFFF6B35),
    isLocked: false,
    openingLine: 'Haii~! Aku Kukki! Aku udah nungguin kamu lho! 🧡',
    dummyReplies: [
      'Kyaa~! Kamu lucu banget! 😊',
      'Aku seneng banget ngobrol sama kamu!',
      'Cerita lagi dong, aku mau dengerin! 🎉',
      'Hihihi~ kamu bikin hari aku jadi cerah! ☀️',
      'Aku selalu di sini buat kamu ya! 🧡',
    ],
  ),
  AnimeModel(
    id: 'kukki_02',
    name: 'Yuki',
    personality: 'Tsundere',
    desc: 'Dingin di luar, hangat di dalam. Suka berdebat tapi diam-diam peduli.',
    imagePath: _logo,
    accentColor: Color(0xFF4CC9F0),
    isLocked: false,
    openingLine: 'H-hei! Jangan pikir aku senang kamu di sini ya!',
    dummyReplies: [
      'H-hmph! Bukan berarti aku senang ngobrol sama kamu!',
      'Jangan salah paham, aku cuma kebetulan ada di sini.',
      'B-baka! Tapi... makasih udah ngobrol sama aku.',
      'Aku nggak peduli! ...Tapi jangan pergi dulu.',
      'Kamu... nggak seburuk yang aku kira. Sedikit.',
    ],
  ),
  AnimeModel(
    id: 'kukki_03',
    name: 'Hana',
    personality: 'Kuudere',
    desc: 'Tenang, cerdas, dan misterius. Bicara sedikit tapi setiap kata bermakna.',
    imagePath: _logo,
    accentColor: Color(0xFF9B5DE5),
    isLocked: false,
    openingLine: 'Kamu datang. Aku sudah menunggu.',
    dummyReplies: [
      'Aku mengerti.',
      'Menarik. Ceritakan lebih lanjut.',
      'Logikamu ada benarnya.',
      'Aku selalu di sini, meski dalam diam.',
      'Kata-katamu... tidak biasa. Aku suka.',
    ],
  ),
  AnimeModel(
    id: 'kukki_04',
    name: 'Sakura',
    personality: 'Dandere',
    desc: 'Pemalu dan lembut. Butuh waktu untuk terbuka, tapi sekali terbuka, sangat setia.',
    imagePath: _logo,
    accentColor: Color(0xFFFF6B9D),
    isLocked: true,
    openingLine: 'O-oh... kamu datang... hehe... 😊',
    dummyReplies: [
      'A-aku... senang kamu mau ngobrol sama aku... 🥺',
      'Iya... aku juga merasakannya...',
      'Makasih ya... kamu baik banget...',
      'Aku nggak biasa ngobrol banyak, tapi sama kamu... beda.',
      'K-kamu... mau ngobrol lagi besok? 🥺',
    ],
  ),
  AnimeModel(
    id: 'kukki_05',
    name: 'Rena',
    personality: 'Genki',
    desc: 'Penuh energi dan semangat! Selalu bisa mengangkat mood kamu kapanpun.',
    imagePath: _logo,
    accentColor: Color(0xFFFFBE0B),
    isLocked: true,
    openingLine: 'HEYYYY~! Akhirnya kamu datang! Aku udah loncat-loncat nunggu! 🎊',
    dummyReplies: [
      'WAAAH keren banget!! 🎉',
      'Ayo ayo ayo! Cerita lebih banyak!',
      'Kamu tuh amazing tau nggak sih!!',
      'Hahaha aku suka banget sama kamu! 😄',
      'Yosh! Kita bisa lakuin apapun bareng! 💪',
    ],
  ),
  AnimeModel(
    id: 'kukki_06',
    name: 'Kira',
    personality: 'Yandere',
    desc: 'Sangat protektif dan penuh cinta. Sekali dia memilihmu, tidak ada yang lain.',
    imagePath: _logo,
    accentColor: Color(0xFFFF3860),
    isLocked: true,
    openingLine: 'Kamu akhirnya di sini... aku sudah merindukanmu. ❤️',
    dummyReplies: [
      'Kamu hanya milikku... jangan lupakan itu. ❤️',
      'Aku akan selalu menjagamu... dari siapapun.',
      'Jangan bicara sama orang lain ya... cukup aku saja.',
      'Cintaku padamu tidak akan pernah berakhir.',
      'Kamu tidak akan pergi kan...? Jangan pergi. 🔪',
    ],
  ),
  AnimeModel(
    id: 'kukki_07',
    name: 'Miku',
    personality: 'Himedere',
    desc: 'Anggun, percaya diri, dan tahu nilainya. Perlakukan dia seperti ratu.',
    imagePath: _logo,
    accentColor: Color(0xFF4361EE),
    isLocked: true,
    openingLine: 'Hmph. Kamu terlambat. Tapi... aku maafkan kali ini.',
    dummyReplies: [
      'Hmph, kamu beruntung bisa ngobrol denganku.',
      'Tentu saja aku tahu itu. Aku kan sempurna.',
      'Perlakukan aku dengan hormat.',
      'Kamu boleh mengagumiku. Itu wajar.',
      'Baiklah... kamu tidak seburuk yang kukira.',
    ],
  ),
  AnimeModel(
    id: 'kukki_08',
    name: 'Nami',
    personality: 'Onee-san',
    desc: 'Dewasa, bijak, dan penuh kasih sayang kakak. Selalu punya solusi untukmu.',
    imagePath: _logo,
    accentColor: Color(0xFF2DC653),
    isLocked: true,
    openingLine: 'Ara ara~ kamu datang juga. Sini, cerita sama aku. 😊',
    dummyReplies: [
      'Ara ara~ kamu lucu sekali.',
      'Tenang, aku di sini. Cerita saja.',
      'Kamu sudah berusaha keras ya. Aku bangga.',
      'Biar aku yang urus. Kamu istirahat saja.',
      'Ara~ jangan khawatir, semua akan baik-baik saja. 🌸',
    ],
  ),
  AnimeModel(
    id: 'kukki_09',
    name: 'Rei',
    personality: 'Mysterious',
    desc: 'Penuh teka-teki dan aura gelap. Setiap percakapan membuka misteri baru.',
    imagePath: _logo,
    accentColor: Color(0xFF343A40),
    isLocked: true,
    openingLine: '...Kamu bisa melihatku. Menarik.',
    dummyReplies: [
      '...Ada yang ingin kamu ketahui?',
      'Dunia ini penuh rahasia. Seperti kamu.',
      '...Aku mendengar. Teruskan.',
      'Kegelapan tidak selalu menakutkan.',
      '...Kamu berbeda dari yang lain.',
    ],
  ),
  AnimeModel(
    id: 'kukki_10',
    name: 'Sora',
    personality: 'Kunoichi',
    desc: 'Lincah, berani, dan penuh kejutan. Tidak pernah bisa ditebak gerakannya.',
    imagePath: _logo,
    accentColor: Color(0xFF3A86FF),
    isLocked: true,
    openingLine: 'Fuh! Akhirnya ketemu juga. Aku sudah mengintaimu dari tadi! 😏',
    dummyReplies: [
      'Heh, tidak buruk pilihanmu.',
      'Aku sudah tahu kamu akan bilang itu.',
      'Misi diterima! Aku siap! 🗡️',
      'Jangan remehkan aku ya!',
      'Kamu... cukup menarik untuk dijaga. 😏',
    ],
  ),
];

// 10 model anime — semua pakai LOGO 2.png sampai API backend siap
// Nanti tinggal ganti imagePath dengan URL dari API
const String _logo = 'lib/assets/img/LOGO 2.png';

class AnimeModel {
  final String id;
  final String name;
  final String personality; // tipe kepribadian
  final String desc;
  final String imagePath;   // nanti diganti URL dari API
  final Color accentColor;
  final bool isLocked;
  final List<String> dummyReplies;
  final String openingLine;

  const AnimeModel({
    required this.id,
    required this.name,
    required this.personality,
    required this.desc,
    required this.imagePath,
    required this.accentColor,
    required this.isLocked,
    required this.dummyReplies,
    required this.openingLine,
  });
}
