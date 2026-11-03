import '../models/story.dart';

// Urutan parameter: Indonesia, Inggris, Bali.
// CATATAN: teks Bali adalah DRAF. Mohon dikoreksi guru/penutur asli.
L10n _l(String id, String en, String bali) => L10n(bali: bali, id: id, en: en);

/// Pilihan angka: sama di semua bahasa.
L10n _n(String s) => L10n(bali: s, id: s, en: s);

StoryScene _s(String id, String en, String bali) =>
    StoryScene(imageUrl: '', narration: _l(id, en, bali));

// Tingkat kelas: A = kelas 2, B = kelas 3-4, C = kelas 5-6.
const _kA = {GradeBand.a};
const _kB = {GradeBand.b};
const _kC = {GradeBand.c};
const _kAB = {GradeBand.a, GradeBand.b};
const _kBC = {GradeBand.b, GradeBand.c};
const _kABC = {GradeBand.a, GradeBand.b, GradeBand.c};

Question _q(
  int after,
  Set<GradeBand> grades,
  L10n text,
  List<L10n> options,
  int correct,
  L10n explanation, {
  bool keepOrder = false,
}) =>
    Question(
      afterScene: after,
      grades: grades,
      text: text,
      options: options,
      correctIndex: correct,
      explanation: explanation,
      keepOrder: keepOrder,
    );

final List<Story> sampleStories = [
  // ───────────────────────── 1. Kambing & Macan ─────────────────────────
  Story(
    id: 'stem-01',
    title: _l('Si Kambing dan Si Macan', 'The Goat and the Tiger', 'I Kambing teken I Macan'),
    category: 'Biologi: Ekosistem',
    description: 'Mengenal pemakan tumbuhan, pemakan daging, dan rantai makanan.',
    coverUrl: '',
    voiceKeys: ['kambing', 'macan', 'goat', 'tiger'],
    scenes: [
      _s(
        'Di sebuah hutan di Bali, hiduplah seekor kambing kecil. Setiap pagi ia berjalan mencari rumput hijau.',
        'In a forest in Bali lived a little goat. Every morning she walked around looking for green grass.',
        'Ring alas Bali, wénten kambing cenik. Sabilang semeng, ipun majalan ngalih padang gadang.',
      ),
      _s(
        'Kambing makan rumput dengan senang. Rumput itu tumbuh subur karena mendapat cahaya matahari dan air hujan.',
        'The goat happily ate the grass. The grass grew well because it got sunlight and rain.',
        'Kambingé ngamah padang sakadi liang. Padangé subur sawireh polih sunar surya lan yéh ujan.',
      ),
      _s(
        'Tiba-tiba seekor macan yang lapar muncul dari balik semak. Ia mendekat pelan-pelan. Mémé, mémé, ada buron tawah mé!',
        'Suddenly a hungry tiger appeared from behind the bushes. He crept closer slowly. Mémé, mémé, ada buron tawah mé!',
        'Dadakan wénten macan ngeleper ring sampingé semak-semak. Ipun nyedek alon-alon. Mémé, mémé, ada buron tawah mé!',
      ),
      _s(
        'Macan itu ingin memakan kambing. Macan memang biasa memakan daging hewan lain.',
        'The tiger wanted to eat the goat. Tigers usually eat the meat of other animals.',
        'Macané meled ngamah kambing. Macan sampun biasa ngamah be buron lianan.',
      ),
      _s(
        'Kambing berpikir cepat. Aku hanya makan rumput, bukan daging, katanya. Macan pun menjadi bingung.',
        'The goat thought fast. I only eat grass, not meat, she said. The tiger became confused.',
        'Kambingé mabaos, Icang ngamah padang dogén, nénten ngamah be. Macané dados bingung.',
      ),
      _s(
        'Kambing menunjuk rumput di sekitarnya. Rumput membuat makanannya sendiri dari cahaya matahari. Kambing memakan rumput, dan macan memakan hewan lain.',
        'The goat pointed at the grass around her. Grass makes its own food from sunlight. Goats eat grass, and tigers eat other animals.',
        'Kambingé nuding padang ring sampingné. Padangé ngwangun ajengan saking sunar surya. Kambing ngamah padang, tur macan ngamah buron lianan.',
      ),
      _s(
        'Macan mulai mengerti. Rantai makanan dimulai dari rumput, lalu kambing, lalu macan. Semuanya saling membutuhkan.',
        'The tiger began to understand. The food chain starts with grass, then the goat, then the tiger. They all need each other.',
        'Macané sampun ngerti. Rantai pangan marupa padang, kambing, wusan macan. Makejang saling mabuat.',
      ),
      _s(
        'Akhirnya macan pergi mencari makanan lain, dan kambing kembali makan rumput dengan tenang. Hutan pun kembali damai.',
        'In the end the tiger went off to find other food, and the goat went back to eating grass peacefully. The forest was calm again.',
        'Wekasan macané luas ngalih ajengan lianan, lan kambingé malih ngamah padang. Alasé dados rahayu.',
      ),
    ],
    questions: [
      // Soal lama
      _q(
        1, _kAB,
        _l('Kambing memakan apa?', 'What does the goat eat?', 'Kambing ngamah napi?'),
        [
          _l('Rumput', 'Grass', 'Padang'),
          _l('Daging', 'Meat', 'Be'),
          _l('Batu', 'Stones', 'Batu'),
          _l('Tulang', 'Bones', 'Tulang'),
        ],
        0,
        _l(
          'Kambing memakan tumbuhan seperti rumput. Hewan pemakan tumbuhan disebut herbivora.',
          'Goats eat plants such as grass. Animals that eat plants are called herbivores.',
          'Kambing ngamah tumbuh-tumbuhan sakadi padang. Buron sané ngamah tumbuhan kaparabin herbivora.',
        ),
      ),
      _q(
        3, _kBC,
        _l('Macan termasuk kelompok hewan apa?', 'Which group of animals does the tiger belong to?', 'Macan kalebet kelompok buron napi?'),
        [
          _l('Herbivora', 'Herbivore', 'Herbivora'),
          _l('Karnivora', 'Carnivore', 'Karnivora'),
          _l('Omnivora', 'Omnivore', 'Omnivora'),
          _l('Produsen', 'Producer', 'Produsen'),
        ],
        1,
        _l(
          'Macan memakan daging hewan lain, jadi macan adalah karnivora.',
          'Tigers eat the meat of other animals, so they are carnivores.',
          'Macan ngamah be buron lianan, dadosnyane macan karnivora.',
        ),
      ),
      _q(
        5, _kC,
        _l('Dalam rantai makanan, rumput berperan sebagai apa?', 'In a food chain, what is the role of grass?', 'Ring rantai pangan, padang dados napi?'),
        [
          _l('Pengurai', 'Decomposer', 'Pengurai'),
          _l('Konsumen tingkat satu', 'Primary consumer', 'Konsumen tingkat satu'),
          _l('Konsumen tingkat dua', 'Secondary consumer', 'Konsumen tingkat kalih'),
          _l('Produsen', 'Producer', 'Produsen'),
        ],
        3,
        _l(
          'Rumput membuat makanannya sendiri dengan bantuan cahaya matahari, sehingga disebut produsen.',
          'Grass makes its own food using sunlight, so it is called a producer.',
          'Padang ngwangun ajengan padewekan nganggen sunar surya, dadosnyane produsen.',
        ),
      ),
      _q(
        6, _kBC,
        _l('Manakah urutan rantai makanan yang benar?', 'Which is the correct food chain order?', 'Napi urutan rantai pangan sané patut?'),
        [
          _l('Macan, Kambing, Rumput', 'Tiger, Goat, Grass', 'Macan, Kambing, Padang'),
          _l('Rumput, Macan, Kambing', 'Grass, Tiger, Goat', 'Padang, Macan, Kambing'),
          _l('Rumput, Kambing, Macan', 'Grass, Goat, Tiger', 'Padang, Kambing, Macan'),
          _l('Kambing, Rumput, Macan', 'Goat, Grass, Tiger', 'Kambing, Padang, Macan'),
        ],
        2,
        _l(
          'Rantai makanan dimulai dari produsen: rumput, lalu kambing, lalu macan.',
          'A food chain starts with the producer: grass, then the goat, then the tiger.',
          'Rantai pangan miwiti saking produsen: padang, kambing, wusan macan.',
        ),
      ),
      _q(
        7, _kC,
        _l('Jika semua rumput di hutan hilang, siapa yang lebih dulu kekurangan makanan?', 'If all the grass in the forest disappeared, who would run out of food first?', 'Yéning padang ring alas telas, sira sané malih nuju kakirangan ajengan?'),
        [
          _l('Kambing', 'The goat', 'Kambing'),
          _l('Macan', 'The tiger', 'Macan'),
          _l('Matahari', 'The sun', 'Surya'),
          _l('Batu', 'Stones', 'Batu'),
        ],
        0,
        _l(
          'Kambing bergantung pada rumput. Jika rumput hilang, kambing kehabisan makanan lebih dulu, lalu macan pun ikut kekurangan.',
          'Goats depend on grass. If the grass disappears, the goat runs out of food first, and then the tiger runs short too.',
          'Kambing ngandelang padang. Yéning padang telas, kambing malih kakirangan ajengan, wusan macan taler.',
        ),
      ),
      // Soal baru
      _q(
        0, _kA,
        _l('Di mana kambing kecil itu tinggal?', 'Where does the little goat live?', 'Dija kambing cenik punika magenah?'),
        [
          _l('Hutan', 'Forest', 'Alas'),
          _l('Laut', 'Sea', 'Segara'),
          _l('Kota', 'City', 'Kota'),
          _l('Gurun', 'Desert', 'Gurun'),
        ],
        0,
        _l(
          'Kambing dalam cerita tinggal di hutan di Bali.',
          'The goat in the story lives in a forest in Bali.',
          'Kambing ring satua magenah ring alas ring Bali.',
        ),
      ),
      _q(
        3, _kA,
        _l('Siapa yang makan daging?', 'Who eats meat?', 'Sira sané ngamah be?'),
        [
          _l('Macan', 'The tiger', 'Macan'),
          _l('Kambing', 'The goat', 'Kambing'),
          _l('Rumput', 'The grass', 'Padang'),
          _l('Matahari', 'The sun', 'Surya'),
        ],
        0,
        _l(
          'Macan makan daging. Kambing makan rumput.',
          'The tiger eats meat. The goat eats grass.',
          'Macan ngamah be. Kambing ngamah padang.',
        ),
      ),
      _q(
        1, _kAB,
        _l('Rumput tumbuh subur karena mendapat air hujan dan...', 'Grass grows well because it gets rain and...', 'Padang tumbuh subur sawireh polih yéh ujan lan...'),
        [
          _l('Cahaya matahari', 'Sunlight', 'Sunar surya'),
          _l('Cahaya lampu', 'Lamplight', 'Sunar lampu'),
          _l('Es', 'Ice', 'Es'),
          _l('Debu', 'Dust', 'Debu'),
        ],
        0,
        _l(
          'Rumput membutuhkan air dan cahaya matahari untuk tumbuh.',
          'Grass needs water and sunlight to grow.',
          'Padang mabuat yéh lan sunar surya mangda tumbuh.',
        ),
      ),
      _q(
        7, _kC,
        _l('Jika semua macan hilang dari hutan, apa yang mungkin terjadi pada jumlah kambing?', 'If all the tigers disappeared from the forest, what might happen to the number of goats?', 'Yéning makejang macan ical saking alas, napi sané prasida kajadian ring cacah kambing?'),
        [
          _l('Bertambah banyak', 'It would increase', 'Ngaliunin'),
          _l('Langsung habis', 'They would disappear at once', 'Énggal telas'),
          _l('Selalu sama', 'It would always stay the same', 'Setata pateh'),
          _l('Berubah menjadi macan', 'They would turn into tigers', 'Dados macan'),
        ],
        0,
        _l(
          'Tanpa pemangsa, kambing bisa bertambah banyak. Kalau terlalu banyak, rumput bisa habis. Karena itu semua makhluk dalam rantai makanan saling berkaitan.',
          'Without a predator, goats can increase in number. If there are too many, the grass can run out. That is why every living thing in a food chain is connected.',
          'Tanpa pemangsa, kambing prasida ngaliunin. Yéning liu pisan, padang prasida telas. Punika awinan makejang sané idup ring rantai pangan saling kaiket.',
        ),
      ),
    ],
  ),

  // ───────────────────────── 2. Lutung & Kekua ─────────────────────────
  Story(
    id: 'stem-02',
    title: _l('Si Lutung dan Si Kura-kura', 'The Monkey and the Turtle', 'I Lutung teken I Kekua'),
    category: 'Biologi: Tumbuhan',
    description: 'Mengenal cara tumbuhan tumbuh dari tunas sampai berbuah. Cerita adaptasi, akhir cerita disederhanakan.',
    coverUrl: '',
    voiceKeys: ['lutung', 'kekua', 'kura', 'monkey', 'turtle'],
    scenes: [
      _s(
        'Di tepi sungai di Bali, Si Lutung dan Si Kekua, sang kura-kura, menemukan sebuah tunas pisang kecil.',
        'On a riverbank in Bali, Lutung the monkey and Kekua the turtle found a small banana sprout.',
        'Ring pasisi tukad, I Lutung teken I Kekua manggihin tunas biu sané cenik.',
      ),
      _s(
        'Mereka sepakat menanamnya bersama. Kekua menggali tanah, Lutung menancapkan tunasnya, lalu mereka menyiramnya dengan air sungai.',
        'They agreed to plant it together. Kekua dug the soil, Lutung planted the sprout, and they watered it with river water.',
        'Ipun makakalih mupus nandur tunas punika. Kekua nguwug tanah, I Lutung nandur tunasé, lantas nyiramin nganggén yéh tukad.',
      ),
      _s(
        'Hari demi hari berlalu. Akar tunas itu tumbuh ke dalam tanah, dan daunnya melebar menangkap cahaya matahari.',
        'Days went by. The roots of the sprout grew into the soil, and its leaves spread wide to catch the sunlight.',
        'Rahina malancaran. Akar tunasé tumbuh ka tanah, tur daunné nglebar nampi sunar surya.',
      ),
      _s(
        'Beberapa bulan kemudian, tunas itu menjadi pohon pisang yang tinggi dengan batang kokoh dan setandan buah yang ranum.',
        'A few months later the sprout had become a tall banana tree with a strong trunk and a bunch of ripe bananas.',
        'Sasih-sasih ké wekasan, tunasé dados punyan biu sané ritatit tur madué buah sané matuh.',
      ),
      _s(
        'Lutung pandai memanjat. Ia naik dan makan banyak pisang. Kekua tidak bisa memanjat, ia hanya bisa menunggu di bawah.',
        'Lutung was good at climbing. He climbed up and ate lots of bananas. Kekua could not climb, so he could only wait below.',
        'I Lutung pradnyan negak. Ipun menék tur ngamah biu akéh. Kekua nénten dados menék, ipun naler ngantosang ring wawan.',
      ),
      _s(
        'Lutung sadar bahwa pohon itu mereka tanam bersama. Ia turun dan membagi pisangnya, lalu mereka makan bersama dan berjanji merawat pohon itu.',
        'Lutung realized they had planted the tree together. He came down and shared the bananas, and they ate together and promised to look after the tree.',
        'I Lutung eling sawireh punyané punika kaúpuk sareng-sareng. Ipun mudun tur mabagi biuné, lantas ngajeng sareng-sareng.',
      ),
    ],
    questions: [
      // Soal lama
      _q(
        1, _kAB,
        _l('Apa yang dibutuhkan tunas pisang agar bisa tumbuh?', 'What does a banana sprout need in order to grow?', 'Napi sané kabuatang tunas biu mangda dados tumbuh?'),
        [
          _l('Air dan cahaya matahari', 'Water and sunlight', 'Yéh lan sunar surya'),
          _l('Hanya batu', 'Only stones', 'Batu dogén'),
          _l('Tempat gelap tanpa air', 'A dark place with no water', 'Genah peteng tanpa yéh'),
          _l('Es batu', 'Ice cubes', 'Es batu'),
        ],
        0,
        _l(
          'Tumbuhan membutuhkan air, cahaya matahari, dan tanah yang subur untuk tumbuh.',
          'Plants need water, sunlight, and fertile soil to grow.',
          'Tumbuhan mabuat yéh, sunar surya, lan tanah sané subur mangda tumbuh.',
        ),
      ),
      _q(
        3, _kBC,
        _l('Bagian tumbuhan yang menyerap air dari dalam tanah adalah...', 'Which part of a plant absorbs water from the soil?', 'Bagian tumbuhan sané nyerep yéh saking tanah inggih punika...'),
        [
          _l('Daun', 'The leaves', 'Don'),
          _l('Akar', 'The roots', 'Akar'),
          _l('Buah', 'The fruit', 'Buah'),
          _l('Bunga', 'The flower', 'Sekar'),
        ],
        1,
        _l(
          'Akar menyerap air dan zat hara dari tanah, lalu menyalurkannya ke seluruh bagian tumbuhan.',
          'Roots absorb water and nutrients from the soil and send them to every part of the plant.',
          'Akar nyerep yéh lan zat hara saking tanah, lantas nyaluran ka sakancan bagian tumbuhan.',
        ),
      ),
      _q(
        5, _kAB,
        _l('Manakah urutan pertumbuhan pisang yang benar?', 'Which is the correct growth order of a banana?', 'Napi urutan tumbuh biu sané patut?'),
        [
          _l('Pohon, Buah, Tunas', 'Tree, Fruit, Sprout', 'Punyan, Buah, Tunas'),
          _l('Buah, Tunas, Pohon', 'Fruit, Sprout, Tree', 'Buah, Tunas, Punyan'),
          _l('Tunas, Pohon, Buah', 'Sprout, Tree, Fruit', 'Tunas, Punyan, Buah'),
          _l('Tunas, Buah, Pohon', 'Sprout, Fruit, Tree', 'Tunas, Buah, Punyan'),
        ],
        2,
        _l(
          'Pisang tumbuh dari tunas, menjadi pohon, lalu berbuah.',
          'A banana grows from a sprout into a tree, and then bears fruit.',
          'Biu tumbuh saking tunas, dados punyan, wusan mabuah.',
        ),
      ),
      // Soal baru
      _q(
        0, _kA,
        _l('Apa yang ditemukan Lutung dan Kekua di tepi sungai?', 'What did Lutung and Kekua find on the riverbank?', 'Napi sané kapanggihin I Lutung teken I Kekua ring pasisi tukad?'),
        [
          _l('Tunas pisang', 'A banana sprout', 'Tunas biu'),
          _l('Batu besar', 'A big rock', 'Batu ageng'),
          _l('Ikan', 'A fish', 'Be'),
          _l('Burung', 'A bird', 'Kedis'),
        ],
        0,
        _l(
          'Mereka menemukan sebuah tunas pisang kecil.',
          'They found a small banana sprout.',
          'Ipun manggihin tunas biu sané cenik.',
        ),
      ),
      _q(
        4, _kA,
        _l('Siapa yang pandai memanjat pohon pisang?', 'Who is good at climbing the banana tree?', 'Sira sané pradnyan menék punyan biu?'),
        [
          _l('Lutung', 'Lutung, the monkey', 'I Lutung'),
          _l('Kekua', 'Kekua, the turtle', 'I Kekua'),
          _l('Pisang', 'The banana', 'Biu'),
          _l('Sungai', 'The river', 'Tukad'),
        ],
        0,
        _l(
          'Lutung pandai memanjat, sedangkan Kekua tidak bisa memanjat.',
          'Lutung is good at climbing, while Kekua cannot climb.',
          'I Lutung pradnyan menék, sakéwala I Kekua nénten dados menék.',
        ),
      ),
      _q(
        2, _kBC,
        _l('Daun tumbuh melebar untuk menangkap...', 'Leaves spread wide to catch...', 'Don nglebar mangda prasida nampi...'),
        [
          _l('Cahaya matahari', 'Sunlight', 'Sunar surya'),
          _l('Suara', 'Sound', 'Suara'),
          _l('Batu', 'Stones', 'Batu'),
          _l('Bayangan', 'Shadows', 'Bayang-bayang'),
        ],
        0,
        _l(
          'Daun menangkap cahaya matahari yang dipakai tumbuhan untuk membuat makanan.',
          'Leaves catch the sunlight that plants use to make food.',
          'Don nampi sunar surya sané anggén tumbuhan ngwangun ajengan.',
        ),
      ),
      _q(
        3, _kBC,
        _l('Bagian tumbuhan yang menopang pohon agar tegak dan mengalirkan air ke daun adalah...', 'Which part of a plant holds the tree upright and carries water to the leaves?', 'Bagian tumbuhan sané nyangga punyan mangda ngadeg tur ngalihang yéh ka don inggih punika...'),
        [
          _l('Batang', 'The trunk (stem)', 'Batang'),
          _l('Bunga', 'The flower', 'Sekar'),
          _l('Biji', 'The seed', 'Bija'),
          _l('Buah', 'The fruit', 'Buah'),
        ],
        0,
        _l(
          'Batang menopang tumbuhan dan mengalirkan air serta zat hara dari akar ke daun.',
          'The stem supports the plant and carries water and nutrients from the roots to the leaves.',
          'Batang nyangga tumbuhan tur ngalihang yéh lan zat hara saking akar ka don.',
        ),
      ),
      _q(
        5, _kC,
        _l('Tumbuhan membuat makanannya sendiri dengan bantuan cahaya matahari. Proses itu disebut...', 'Plants make their own food using sunlight. This process is called...', 'Tumbuhan ngwangun ajengan padewekan nganggen sunar surya. Prosés punika kaparabin...'),
        [
          _l('Fotosintesis', 'Photosynthesis', 'Fotosintesis'),
          _l('Penguapan', 'Evaporation', 'Penguapan'),
          _l('Pembuahan', 'Fertilisation', 'Pembuahan'),
          _l('Pembekuan', 'Freezing', 'Pembekuan'),
        ],
        0,
        _l(
          'Fotosintesis adalah cara tumbuhan hijau membuat makanan dari air, gas karbon dioksida dari udara, dan cahaya matahari.',
          'Photosynthesis is how green plants make food from water, carbon dioxide from the air, and sunlight.',
          'Fotosintesis inggih punika cara tumbuhan gadang ngwangun ajengan saking yéh, gas karbon dioksida saking angin, lan sunar surya.',
        ),
      ),
    ],
  ),

  // ───────────────────────── 3. Men Brayut ─────────────────────────
  Story(
    id: 'stem-03',
    title: _l('Men Brayut dan Anak-anaknya', 'Men Brayut and Her Children', 'Men Brayut'),
    category: 'Matematika: Berhitung',
    description: 'Belajar menjumlah, mengurang, dan mengalikan lewat satua Men Brayut. Jumlah anak di tiap versi berbeda; di sini ditetapkan 6.',
    coverUrl: '',
    voiceKeys: ['brayut', 'berhitung', 'hitung', 'matematika'],
    scenes: [
      _s(
        'Di sebuah desa di Bali tinggal Men Brayut dan suaminya, Pan Brayut. Mereka memiliki banyak anak. Pagi itu, 3 anak sudah bangun dan bermain di halaman.',
        'In a village in Bali lived Men Brayut and her husband, Pan Brayut. They had many children. That morning, 3 children were already up and playing in the yard.',
        'Ring désa ring Bali magenah Men Brayut sareng kurenanipun, Pan Brayut. Ipun madué oka akéh. Semengan punika, 3 oka sampun bangun tur mabebanggan ring natah.',
      ),
      _s(
        'Tidak lama kemudian, 2 anak lagi menyusul keluar rumah dan ikut bermain.',
        'Soon after, 2 more children came out of the house and joined the game.',
        'Sampun kejep, 2 oka malih rauh tur nyarengin mabebanggan.',
      ),
      _s(
        'Si bungsu masih tidur dan digendong Men Brayut. Jadi, anak Men Brayut ada 5 ditambah 1, yaitu 6 anak.',
        'The youngest was still asleep in Men Brayut\'s arms. So Men Brayut had 5 plus 1, which is 6 children.',
        'Oka sané panguntatan nu sepeng, kagendong antuk Men Brayut. Dadi oka Men Brayut 5 tambah 1, inggih punika 6.',
      ),
      _s(
        'Men Brayut menyiapkan pisang untuk sarapan. Setiap anak mendapat 2 pisang.',
        'Men Brayut prepared bananas for breakfast. Each child got 2 bananas.',
        'Men Brayut nyiapang biu anggén sarapan. Soang-soang oka polih 2 biu.',
      ),
      _s(
        'Setelah sarapan, 2 anak pergi membantu Pan Brayut di sawah.',
        'After breakfast, 2 of the children went to help Pan Brayut in the rice field.',
        'Sasampune ngajeng, 2 oka luas nulungin Pan Brayut ka carik.',
      ),
      _s(
        'Sore hari semua anak berkumpul lagi. Rumah menjadi ramai, dan Men Brayut tersenyum meskipun lelah.',
        'In the evening all the children gathered again. The house was lively, and Men Brayut smiled even though she was tired.',
        'Sanja, makejang oka makumpul malih. Umahé dados ramé, tur Men Brayut makenyem sakéwala sengkala.',
      ),
    ],
    questions: [
      // Soal lama
      _q(
        1, _kAB,
        _l('Mula-mula 3 anak bermain, lalu 2 anak menyusul. Ada berapa anak yang bermain?', 'At first 3 children were playing, then 2 more joined. How many children are playing?', 'Mula 3 oka mabebanggan, lantas 2 oka rauh. Sapunapi akéhnyané oka sané mabebanggan?'),
        [_n('4'), _n('5'), _n('6'), _n('7')],
        1,
        _l('3 ditambah 2 sama dengan 5.', '3 plus 2 equals 5.', '3 tambah 2 pateh sareng 5.'),
        keepOrder: true,
      ),
      _q(
        3, _kBC,
        _l('Ada 6 anak dan setiap anak mendapat 2 pisang. Berapa pisang semuanya?', 'There are 6 children and each child gets 2 bananas. How many bananas are there in all?', 'Wénten 6 oka lan soang-soang polih 2 biu. Sapunapi akéhnyané biu sami?'),
        [_n('10'), _n('14'), _n('12'), _n('8')],
        2,
        _l('6 kali 2 sama dengan 12, atau 2 ditambah 2 sebanyak enam kali.', '6 times 2 equals 12, or 2 added six times.', '6 kali 2 pateh sareng 12.'),
        keepOrder: true,
      ),
      _q(
        4, _kAB,
        _l('Dari 6 anak, 2 anak pergi ke sawah. Berapa anak yang masih di rumah?', 'Of the 6 children, 2 went to the rice field. How many children are still at home?', 'Saking 6 oka, 2 luas ka carik. Sapunapi akéhnyané oka sané kantun ring umah?'),
        [_n('4'), _n('2'), _n('6'), _n('3')],
        0,
        _l('6 dikurangi 2 sama dengan 4.', '6 minus 2 equals 4.', '6 kuangin 2 pateh sareng 4.'),
        keepOrder: true,
      ),
      // Soal baru
      _q(
        0, _kA,
        _l('Pagi itu ada berapa anak yang sudah bangun?', 'How many children were already awake that morning?', 'Semengan punika sapunapi akéhnyané oka sané sampun bangun?'),
        [_n('2'), _n('3'), _n('4'), _n('5')],
        1,
        _l('3 anak sudah bangun dan bermain di halaman.', '3 children were already up and playing in the yard.', '3 oka sampun bangun tur mabebanggan ring natah.'),
        keepOrder: true,
      ),
      _q(
        2, _kA,
        _l('Berapa jumlah semua anak Men Brayut?', 'How many children does Men Brayut have in all?', 'Sapunapi akéhnyané oka Men Brayut sami?'),
        [_n('4'), _n('5'), _n('6'), _n('7')],
        2,
        _l('Anak Men Brayut dalam cerita ini ada 6.', 'Men Brayut has 6 children in this story.', 'Oka Men Brayut ring satua puniki wénten 6.'),
        keepOrder: true,
      ),
      _q(
        3, _kB,
        _l('Setiap anak mendapat 2 pisang. Berapa pisang untuk 3 anak?', 'Each child gets 2 bananas. How many bananas for 3 children?', 'Soang-soang oka polih 2 biu. Sapunapi akéhnyané biu anggén 3 oka?'),
        [_n('4'), _n('5'), _n('6'), _n('8')],
        2,
        _l('3 kali 2 sama dengan 6.', '3 times 2 equals 6.', '3 kali 2 pateh sareng 6.'),
        keepOrder: true,
      ),
      _q(
        3, _kBC,
        _l('Men Brayut punya 12 pisang dan membaginya sama banyak kepada 6 anak. Setiap anak mendapat berapa pisang?', 'Men Brayut has 12 bananas and shares them equally among 6 children. How many bananas does each child get?', 'Men Brayut madué 12 biu tur ngabagi pateh ring 6 oka. Sapunapi akéhnyané biu sané polih soang-soang oka?'),
        [_n('1'), _n('2'), _n('3'), _n('4')],
        1,
        _l('12 dibagi 6 sama dengan 2.', '12 divided by 6 equals 2.', '12 kabagi 6 pateh sareng 2.'),
        keepOrder: true,
      ),
      _q(
        4, _kC,
        _l('Dua anak pergi ke sawah. Empat anak yang di rumah masing-masing makan 2 pisang lagi. Berapa pisang yang mereka makan?', 'Two children went to the rice field. The four children at home each eat 2 more bananas. How many bananas do they eat?', 'Kalih oka luas ka carik. 4 oka sané ring umah soang-soang ngajeng 2 biu malih. Sapunapi akéhnyané biu sané kaajeng?'),
        [_n('6'), _n('8'), _n('10'), _n('12')],
        1,
        _l('4 kali 2 sama dengan 8.', '4 times 2 equals 8.', '4 kali 2 pateh sareng 8.'),
        keepOrder: true,
      ),
      _q(
        5, _kC,
        _l('Jika setiap anak makan 3 pisang, berapa pisang yang dibutuhkan 6 anak?', 'If each child eats 3 bananas, how many bananas do 6 children need?', 'Yéning soang-soang oka ngajeng 3 biu, sapunapi akéhnyané biu anggén 6 oka?'),
        [_n('9'), _n('12'), _n('18'), _n('24')],
        2,
        _l('6 kali 3 sama dengan 18.', '6 times 3 equals 18.', '6 kali 3 pateh sareng 18.'),
        keepOrder: true,
      ),
    ],
  ),

  // ───────────────────────── 4. Gamelan ─────────────────────────
  Story(
    id: 'stem-04',
    title: _l('Made dan Gamelan', 'Made and the Gamelan', 'I Made teken Gamelan'),
    category: 'Fisika: Bunyi',
    description: 'Memahami bunyi dan getaran lewat gamelan Bali. Cerita baru bernuansa Bali (bukan satua asli).',
    coverUrl: '',
    voiceKeys: ['made', 'gamelan', 'gong', 'bunyi', 'getaran'],
    scenes: [
      _s(
        'Made datang ke sanggar gamelan di desanya. Di sana ada gong yang besar, gender, dan kendang.',
        'Made went to the gamelan studio in his village. There was a big gong, a gender, and a drum.',
        'I Made rauh ka sanggar gamelan ring désanipun. Irika wénten gong ageng, gender, lan kendang.',
      ),
      _s(
        'Pak guru memukul bilah gender. Made meraba bilahnya dan merasakan bilah itu bergetar, sementara suaranya terdengar jernih.',
        'The teacher struck a key of the gender. Made touched it and felt it vibrating, while its sound rang clear.',
        'Guru mukul bilah gender. I Made ngaba-ngaba bilahé tur ngarasayang bilahé mabyayuh, kasuaran jenék.',
      ),
      _s(
        'Pak guru memukul gong besar, dan terdengar bunyi yang dalam dan rendah. Lalu ia memukul gong kecil, dan bunyinya tinggi.',
        'The teacher struck the big gong and it made a deep, low sound. Then he struck the small gong and its sound was high.',
        'Guru mukul gong ageng, kasuaran sané ngenah tur endep. Lantas mukul gong cenik, suaranipun inggil.',
      ),
      _s(
        'Made mencoba memukul gong pelan-pelan, dan bunyinya lembut. Ia memukul lebih kuat, dan bunyinya menjadi lebih keras.',
        'Made tried striking the gong gently, and the sound was soft. He struck harder, and the sound became louder.',
        'I Made nyobi mukul gong alon-alon, suaranipun aluh. Ipun mukul langkung kuat, suaranipun dados langkung banter.',
      ),
      _s(
        'Made memegang bilah gender yang sedang berbunyi. Bunyinya langsung berhenti karena getarannya tertahan tangannya.',
        'Made held a gender key that was ringing. The sound stopped at once because his hand held back the vibration.',
        'I Made ngecélang bilah gender sané madué suara. Suaranipun énggal mandeg krana mabyayuhné kagebug antuk lima.',
      ),
      _s(
        'Mereka bermain bersama. Bunyi gamelan terdengar sampai ke rumah-rumah di sekitar sanggar, merambat lewat udara.',
        'They played together. The sound of the gamelan reached the houses around the studio, travelling through the air.',
        'Ipun makejang magambel sareng-sareng. Suaran gamelané kapireng kantos ka umah-umah ring sampingé, mamargi saking angin.',
      ),
    ],
    questions: [
      // Soal lama
      _q(
        1, _kBC,
        _l('Bunyi gamelan terjadi karena benda yang...', 'The sound of the gamelan is made when an object...', 'Suaran gamelan wénten krana sarana sané...'),
        [
          _l('Diam', 'Stays still', 'Meneng'),
          _l('Bergetar', 'Vibrates', 'Mabyayuh'),
          _l('Dingin', 'Is cold', 'Tis'),
          _l('Basah', 'Is wet', 'Basah'),
        ],
        1,
        _l(
          'Bunyi dihasilkan oleh benda yang bergetar. Itu sebabnya bilah gender terasa bergetar saat dipukul.',
          'Sound is made by vibrating objects. That is why the gender key trembles when it is struck.',
          'Suara wénten saking sarana sané mabyayuh. Punika awinan bilah gender mabyayuh yéning kapukul.',
        ),
      ),
      _q(
        3, _kABC,
        _l('Jika gong dipukul lebih kuat, bunyinya menjadi...', 'If the gong is struck harder, the sound becomes...', 'Yéning gong kapukul langkung kuat, suaranipun dados...'),
        [
          _l('Lebih pelan', 'Softer', 'Langkung aluh'),
          _l('Hilang', 'Gone', 'Ical'),
          _l('Lebih keras', 'Louder', 'Langkung banter'),
          _l('Tidak berubah', 'The same', 'Nénten malih'),
        ],
        2,
        _l(
          'Pukulan yang lebih kuat membuat getaran lebih besar, sehingga bunyi menjadi lebih keras.',
          'A harder strike makes a bigger vibration, so the sound becomes louder.',
          'Pukulan sané langkung kuat ngwetuang mabyayuh sané langkung ageng, dadosnyane suara langkung banter.',
        ),
      ),
      _q(
        5, _kBC,
        _l('Bunyi bisa sampai ke telinga kita karena merambat melalui...', 'Sound reaches our ears because it travels through...', 'Suara prasida kapireng krana mamargi saking...'),
        [
          _l('Udara', 'Air', 'Angin'),
          _l('Cahaya', 'Light', 'Sunar'),
          _l('Warna', 'Colour', 'Warna'),
          _l('Bayangan', 'Shadow', 'Bayang-bayang'),
        ],
        0,
        _l(
          'Bunyi merambat melalui zat perantara seperti udara, sehingga sampai ke telinga kita.',
          'Sound travels through a medium such as air, which is how it reaches our ears.',
          'Suara mamargi saking sarana sakadi angin, dadosnyane prasida kapireng.',
        ),
      ),
      // Soal baru
      _q(
        2, _kA,
        _l('Apa nama alat musik besar yang dipukul Pak Guru?', 'What is the name of the big instrument the teacher struck?', 'Napi arane gamelan ageng sané kapukul antuk guru?'),
        [
          _l('Gong', 'Gong', 'Gong'),
          _l('Sepatu', 'Shoe', 'Sepatu'),
          _l('Buku', 'Book', 'Buku'),
          _l('Meja', 'Table', 'Méja'),
        ],
        0,
        _l('Pak guru memukul gong yang besar.', 'The teacher struck the big gong.', 'Guru mukul gong sané ageng.'),
      ),
      _q(
        1, _kA,
        _l('Made meraba bilah gender yang dipukul. Apa yang ia rasakan?', 'Made touched the gender key that was struck. What did he feel?', 'I Made ngaba-ngaba bilah gender sané kapukul. Napi sané kaparasa?'),
        [
          _l('Bergetar', 'It vibrated', 'Mabyayuh'),
          _l('Basah', 'It was wet', 'Basah'),
          _l('Panas sekali', 'Very hot', 'Panas pisan'),
          _l('Sangat berat', 'Very heavy', 'Berat pisan'),
        ],
        0,
        _l(
          'Bilah yang dipukul bergetar, dan getaran itulah yang menghasilkan bunyi.',
          'The key that is struck vibrates, and that vibration makes the sound.',
          'Bilah sané kapukul mabyayuh, tur mabyayuh punika sané ngwetuang suara.',
        ),
      ),
      _q(
        5, _kA,
        _l('Bunyi gamelan kita dengar dengan...', 'We hear the sound of the gamelan with our...', 'Suara gamelan kapireng antuk...'),
        [
          _l('Telinga', 'Ears', 'Kuping'),
          _l('Mata', 'Eyes', 'Mata'),
          _l('Hidung', 'Nose', 'Cunguh'),
          _l('Kaki', 'Feet', 'Batis'),
        ],
        0,
        _l(
          'Telinga adalah indra untuk mendengar bunyi.',
          'The ears are the sense organs for hearing sound.',
          'Kuping inggih punika indria anggén miragi suara.',
        ),
      ),
      _q(
        2, _kB,
        _l('Gong kecil dipukul. Bunyi yang terdengar adalah bunyi yang...', 'The small gong is struck. Its sound is...', 'Gong cenik kapukul. Suaranipun...'),
        [
          _l('Tinggi', 'High', 'Inggil'),
          _l('Rendah', 'Low', 'Endep'),
          _l('Tidak ada', 'Silent', 'Nénten wénten'),
          _l('Berwarna merah', 'Red', 'Barak'),
        ],
        0,
        _l(
          'Gong yang kecil menghasilkan bunyi yang lebih tinggi, sedangkan gong besar menghasilkan bunyi yang lebih rendah.',
          'The small gong makes a higher sound, while the big gong makes a lower sound.',
          'Gong cenik ngwetuang suara sané langkung inggil, sakéwala gong ageng ngwetuang suara sané langkung endep.',
        ),
      ),
      _q(
        4, _kBC,
        _l('Mengapa bunyi bilah gender berhenti saat dipegang?', 'Why does the sound of a gender key stop when it is held?', 'Napi awinan suara bilah gender mandeg yéning kaecélang?'),
        [
          _l('Getarannya tertahan', 'Its vibration is stopped', 'Mabyayuhné kagebug'),
          _l('Bilahnya hilang', 'The key disappears', 'Bilahé ical'),
          _l('Hari menjadi gelap', 'It gets dark', 'Dados peteng'),
          _l('Bilahnya menjadi dingin', 'The key turns cold', 'Bilahé dados tis'),
        ],
        0,
        _l(
          'Bunyi berhenti ketika getarannya berhenti.',
          'The sound stops when the vibration stops.',
          'Suara mandeg yéning mabyayuhné mandeg.',
        ),
      ),
      _q(
        5, _kC,
        _l('Di ruang hampa udara, bunyi gamelan tidak bisa terdengar. Mengapa?', 'In a vacuum with no air, the sound of the gamelan cannot be heard. Why?', 'Ring genah tanpa angin, suara gamelan nénten kapireng. Napi awinannya?'),
        [
          _l('Bunyi membutuhkan zat perantara seperti udara', 'Sound needs a medium such as air', 'Suara mabuat sarana sakadi angin'),
          _l('Gamelan menjadi kecil', 'The gamelan shrinks', 'Gamelané dados cenik'),
          _l('Telinga berhenti bekerja', 'Ears stop working', 'Kuping mandeg makarya'),
          _l('Bunyi berubah menjadi cahaya', 'Sound turns into light', 'Suara dados sunar'),
        ],
        0,
        _l(
          'Bunyi merambat melalui zat perantara. Tanpa udara, bunyi tidak bisa sampai ke telinga.',
          'Sound travels through a medium. Without air, sound cannot reach our ears.',
          'Suara mamargi saking sarana. Tanpa angin, suara nénten prasida kapireng.',
        ),
      ),
    ],
  ),
];


