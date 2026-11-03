import '../models/story.dart';

// Urutan parameter: Indonesia, Inggris, Bali.
// CATATAN: teks Bali adalah DRAF. Mohon dikoreksi guru/penutur asli.
L10n _l(String id, String en, String bali) => L10n(bali: bali, id: id, en: en);

StoryScene _s(String id, String en, String bali) =>
    StoryScene(imageUrl: '', narration: _l(id, en, bali));

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
      Question(
        afterScene: 1,
        text: _l('Kambing memakan apa?', 'What does the goat eat?', 'Kambing ngamah napi?'),
        options: [
          _l('Rumput', 'Grass', 'Padang'),
          _l('Daging', 'Meat', 'Be'),
          _l('Batu', 'Stones', 'Batu'),
          _l('Tulang', 'Bones', 'Tulang'),
        ],
        correctIndex: 0,
        explanation: _l(
          'Kambing memakan tumbuhan seperti rumput. Hewan pemakan tumbuhan disebut herbivora.',
          'Goats eat plants such as grass. Animals that eat plants are called herbivores.',
          'Kambing ngamah tumbuh-tumbuhan sakadi padang. Buron sané ngamah tumbuhan kaparabin herbivora.',
        ),
      ),
      Question(
        afterScene: 3,
        text: _l('Macan termasuk kelompok hewan apa?', 'Which group of animals does the tiger belong to?', 'Macan kalebet kelompok buron napi?'),
        options: [
          _l('Herbivora', 'Herbivore', 'Herbivora'),
          _l('Karnivora', 'Carnivore', 'Karnivora'),
          _l('Omnivora', 'Omnivore', 'Omnivora'),
          _l('Produsen', 'Producer', 'Produsen'),
        ],
        correctIndex: 1,
        explanation: _l(
          'Macan memakan daging hewan lain, jadi macan adalah karnivora.',
          'Tigers eat the meat of other animals, so they are carnivores.',
          'Macan ngamah be buron lianan, dadosnyane macan karnivora.',
        ),
      ),
      Question(
        afterScene: 5,
        text: _l('Dalam rantai makanan, rumput berperan sebagai apa?', 'In a food chain, what is the role of grass?', 'Ring rantai pangan, padang dados napi?'),
        options: [
          _l('Pengurai', 'Decomposer', 'Pengurai'),
          _l('Konsumen tingkat satu', 'Primary consumer', 'Konsumen tingkat satu'),
          _l('Konsumen tingkat dua', 'Secondary consumer', 'Konsumen tingkat kalih'),
          _l('Produsen', 'Producer', 'Produsen'),
        ],
        correctIndex: 3,
        explanation: _l(
          'Rumput membuat makanannya sendiri dengan bantuan cahaya matahari, sehingga disebut produsen.',
          'Grass makes its own food using sunlight, so it is called a producer.',
          'Padang ngwangun ajengan padewekan nganggen sunar surya, dadosnyane produsen.',
        ),
      ),
      Question(
        afterScene: 6,
        text: _l('Manakah urutan rantai makanan yang benar?', 'Which is the correct food chain order?', 'Napi urutan rantai pangan sané patut?'),
        options: [
          _l('Macan, Kambing, Rumput', 'Tiger, Goat, Grass', 'Macan, Kambing, Padang'),
          _l('Rumput, Macan, Kambing', 'Grass, Tiger, Goat', 'Padang, Macan, Kambing'),
          _l('Rumput, Kambing, Macan', 'Grass, Goat, Tiger', 'Padang, Kambing, Macan'),
          _l('Kambing, Rumput, Macan', 'Goat, Grass, Tiger', 'Kambing, Padang, Macan'),
        ],
        correctIndex: 2,
        explanation: _l(
          'Rantai makanan dimulai dari produsen: rumput, lalu kambing, lalu macan.',
          'A food chain starts with the producer: grass, then the goat, then the tiger.',
          'Rantai pangan miwiti saking produsen: padang, kambing, wusan macan.',
        ),
      ),
      Question(
        afterScene: 7,
        text: _l('Jika semua rumput di hutan hilang, siapa yang lebih dulu kekurangan makanan?', 'If all the grass in the forest disappeared, who would run out of food first?', 'Yéning padang ring alas telas, sira sané malih nuju kakirangan ajengan?'),
        options: [
          _l('Kambing', 'The goat', 'Kambing'),
          _l('Macan', 'The tiger', 'Macan'),
          _l('Matahari', 'The sun', 'Surya'),
          _l('Batu', 'Stones', 'Batu'),
        ],
        correctIndex: 0,
        explanation: _l(
          'Kambing bergantung pada rumput. Jika rumput hilang, kambing kehabisan makanan lebih dulu, lalu macan pun ikut kekurangan.',
          'Goats depend on grass. If the grass disappears, the goat runs out of food first, and then the tiger runs short too.',
          'Kambing ngandelang padang. Yéning padang telas, kambing malih kakirangan ajengan, wusan macan taler.',
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
      Question(
        afterScene: 1,
        text: _l('Apa yang dibutuhkan tunas pisang agar bisa tumbuh?', 'What does a banana sprout need in order to grow?', 'Napi sané kabuatang tunas biu mangda dados tumbuh?'),
        options: [
          _l('Air dan cahaya matahari', 'Water and sunlight', 'Yéh lan sunar surya'),
          _l('Hanya batu', 'Only stones', 'Batu dogén'),
          _l('Tempat gelap tanpa air', 'A dark place with no water', 'Genah peteng tanpa yéh'),
          _l('Es batu', 'Ice cubes', 'Es batu'),
        ],
        correctIndex: 0,
        explanation: _l(
          'Tumbuhan membutuhkan air, cahaya matahari, dan tanah yang subur untuk tumbuh.',
          'Plants need water, sunlight, and fertile soil to grow.',
          'Tumbuhan mabuat yéh, sunar surya, lan tanah sané subur mangda tumbuh.',
        ),
      ),
      Question(
        afterScene: 3,
        text: _l('Bagian tumbuhan yang menyerap air dari dalam tanah adalah...', 'Which part of a plant absorbs water from the soil?', 'Bagian tumbuhan sané nyerep yéh saking tanah inggih punika...'),
        options: [
          _l('Daun', 'The leaves', 'Don'),
          _l('Akar', 'The roots', 'Akar'),
          _l('Buah', 'The fruit', 'Buah'),
          _l('Bunga', 'The flower', 'Sekar'),
        ],
        correctIndex: 1,
        explanation: _l(
          'Akar menyerap air dan zat hara dari tanah, lalu menyalurkannya ke seluruh bagian tumbuhan.',
          'Roots absorb water and nutrients from the soil and send them to every part of the plant.',
          'Akar nyerep yéh lan zat hara saking tanah, lantas nyaluran ka sakancan bagian tumbuhan.',
        ),
      ),
      Question(
        afterScene: 5,
        text: _l('Manakah urutan pertumbuhan pisang yang benar?', 'Which is the correct growth order of a banana?', 'Napi urutan tumbuh biu sané patut?'),
        options: [
          _l('Pohon, Buah, Tunas', 'Tree, Fruit, Sprout', 'Punyan, Buah, Tunas'),
          _l('Buah, Tunas, Pohon', 'Fruit, Sprout, Tree', 'Buah, Tunas, Punyan'),
          _l('Tunas, Pohon, Buah', 'Sprout, Tree, Fruit', 'Tunas, Punyan, Buah'),
          _l('Tunas, Buah, Pohon', 'Sprout, Fruit, Tree', 'Tunas, Buah, Punyan'),
        ],
        correctIndex: 2,
        explanation: _l(
          'Pisang tumbuh dari tunas, menjadi pohon, lalu berbuah.',
          'A banana grows from a sprout into a tree, and then bears fruit.',
          'Biu tumbuh saking tunas, dados punyan, wusan mabuah.',
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
      Question(
        afterScene: 1,
        text: _l('Mula-mula 3 anak bermain, lalu 2 anak menyusul. Ada berapa anak yang bermain?', 'At first 3 children were playing, then 2 more joined. How many children are playing?', 'Mula 3 oka mabebanggan, lantas 2 oka rauh. Sapunapi akéhnyané oka sané mabebanggan?'),
        options: [_l('4', '4', '4'), _l('5', '5', '5'), _l('6', '6', '6'), _l('7', '7', '7')],
        correctIndex: 1,
        explanation: _l('3 ditambah 2 sama dengan 5.', '3 plus 2 equals 5.', '3 tambah 2 pateh sareng 5.'),
      ),
      Question(
        afterScene: 3,
        text: _l('Ada 6 anak dan setiap anak mendapat 2 pisang. Berapa pisang semuanya?', 'There are 6 children and each child gets 2 bananas. How many bananas are there in all?', 'Wénten 6 oka lan soang-soang polih 2 biu. Sapunapi akéhnyané biu sami?'),
        options: [_l('10', '10', '10'), _l('14', '14', '14'), _l('12', '12', '12'), _l('8', '8', '8')],
        correctIndex: 2,
        explanation: _l('6 kali 2 sama dengan 12, atau 2 ditambah 2 sebanyak enam kali.', '6 times 2 equals 12, or 2 added six times.', '6 kali 2 pateh sareng 12.'),
      ),
      Question(
        afterScene: 4,
        text: _l('Dari 6 anak, 2 anak pergi ke sawah. Berapa anak yang masih di rumah?', 'Of the 6 children, 2 went to the rice field. How many children are still at home?', 'Saking 6 oka, 2 luas ka carik. Sapunapi akéhnyané oka sané kantun ring umah?'),
        options: [_l('4', '4', '4'), _l('2', '2', '2'), _l('6', '6', '6'), _l('3', '3', '3')],
        correctIndex: 0,
        explanation: _l('6 dikurangi 2 sama dengan 4.', '6 minus 2 equals 4.', '6 kuangin 2 pateh sareng 4.'),
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
      Question(
        afterScene: 1,
        text: _l('Bunyi gamelan terjadi karena benda yang...', 'The sound of the gamelan is made when an object...', 'Suaran gamelan wénten krana sarana sané...'),
        options: [
          _l('Diam', 'Stays still', 'Meneng'),
          _l('Bergetar', 'Vibrates', 'Mabyayuh'),
          _l('Dingin', 'Is cold', 'Tis'),
          _l('Basah', 'Is wet', 'Basah'),
        ],
        correctIndex: 1,
        explanation: _l(
          'Bunyi dihasilkan oleh benda yang bergetar. Itu sebabnya bilah gender terasa bergetar saat dipukul.',
          'Sound is made by vibrating objects. That is why the gender key trembles when it is struck.',
          'Suara wénten saking sarana sané mabyayuh. Punika awinan bilah gender mabyayuh yéning kapukul.',
        ),
      ),
      Question(
        afterScene: 3,
        text: _l('Jika gong dipukul lebih kuat, bunyinya menjadi...', 'If the gong is struck harder, the sound becomes...', 'Yéning gong kapukul langkung kuat, suaranipun dados...'),
        options: [
          _l('Lebih pelan', 'Softer', 'Langkung aluh'),
          _l('Hilang', 'Gone', 'Ical'),
          _l('Lebih keras', 'Louder', 'Langkung banter'),
          _l('Tidak berubah', 'The same', 'Nénten malih'),
        ],
        correctIndex: 2,
        explanation: _l(
          'Pukulan yang lebih kuat membuat getaran lebih besar, sehingga bunyi menjadi lebih keras.',
          'A harder strike makes a bigger vibration, so the sound becomes louder.',
          'Pukulan sané langkung kuat ngwetuang mabyayuh sané langkung ageng, dadosnyane suara langkung banter.',
        ),
      ),
      Question(
        afterScene: 5,
        text: _l('Bunyi bisa sampai ke telinga kita karena merambat melalui...', 'Sound reaches our ears because it travels through...', 'Suara prasida kapireng krana mamargi saking...'),
        options: [
          _l('Udara', 'Air', 'Angin'),
          _l('Cahaya', 'Light', 'Sunar'),
          _l('Warna', 'Colour', 'Warna'),
          _l('Bayangan', 'Shadow', 'Bayang-bayang'),
        ],
        correctIndex: 0,
        explanation: _l(
          'Bunyi merambat melalui zat perantara seperti udara, sehingga sampai ke telinga kita.',
          'Sound travels through a medium such as air, which is how it reaches our ears.',
          'Suara mamargi saking sarana sakadi angin, dadosnyane prasida kapireng.',
        ),
      ),
    ],
  ),
];