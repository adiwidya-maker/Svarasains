import '../models/story.dart';

final List<Story> sampleStories = [
  Story(
    id: 'stem-01',
    title: const L10n(
      bali: 'I Kambing teken I Macan',
      id: 'Si Kambing dan Si Macan',
      en: 'The Goat and the Tiger',
    ),
    category: 'Ekosistem',
    description: 'Mengenal rantai makanan lewat cerita rakyat Bali.',
    coverUrl: '',
    parts: [
      StoryPart(
        imageUrl: '',
        narration: const L10n(
          bali: 'Ring alas Bali, wénten kambing cenik sané nuju ngajeng padang gadang.',
          id: 'Di sebuah hutan di Bali, hiduplah seekor kambing kecil yang sedang memakan rumput hijau.',
          en: 'In a forest in Bali, a little goat was eating green grass.',
        ),
        question: const Question(
          text: L10n(
            bali: 'I Kambing ngamah napi?',
            id: 'Kambing memakan apa?',
            en: 'What does the goat eat?',
          ),
          options: [
            L10n(bali: 'Padang', id: 'Rumput', en: 'Grass'),
            L10n(bali: 'Be', id: 'Daging', en: 'Meat'),
            L10n(bali: 'Yéh', id: 'Air', en: 'Water'),
            L10n(bali: 'Batu', id: 'Batu', en: 'Stones'),
          ],
          correctIndex: 0,
          explanation: L10n(
            bali: 'Kambing ngamah padang. Buron sakadi puniki kasengguh herbivora.',
            id: 'Kambing memakan rumput. Hewan pemakan tumbuhan disebut herbivora.',
            en: 'Goats eat grass. Animals that eat plants are called herbivores.',
          ),
        ),
      ),
      StoryPart(
        imageUrl: '',
        narration: const L10n(
          bali: 'Dadakan wénten macan ngeleper teka nyedek. "Mémé, mémé, ada buron tawah mé!" Macané majalan alon-alon.',
          id: 'Tiba-tiba seekor macan yang lapar datang mendekat. "Mémé, mémé, ada buron tawah mé!" Macan itu berjalan pelan-pelan.',
          en: 'Suddenly a hungry tiger came closer. "Mémé, mémé, ada buron tawah mé!" The tiger crept slowly.',
        ),
        question: const Question(
          text: L10n(
            bali: 'Macan manut kelompok buron napi?',
            id: 'Macan termasuk kelompok hewan apa?',
            en: 'Which group of animals does the tiger belong to?',
          ),
          options: [
            L10n(bali: 'Karnivora', id: 'Karnivora', en: 'Carnivore'),
            L10n(bali: 'Herbivora', id: 'Herbivora', en: 'Herbivore'),
            L10n(bali: 'Omnivora', id: 'Omnivora', en: 'Omnivore'),
            L10n(bali: 'Produsen', id: 'Produsen', en: 'Producer'),
          ],
          correctIndex: 0,
          explanation: L10n(
            bali: 'Macan ngamah be saking buron lianan, dados karnivora.',
            id: 'Macan memakan daging hewan lain, jadi macan adalah karnivora.',
            en: 'Tigers eat the meat of other animals, so they are carnivores.',
          ),
        ),
      ),
      StoryPart(
        imageUrl: '',
        narration: const L10n(
          bali: 'I Kambing mabaos, "Icang ngamah padang dogén, tusing ngamah be." Macané dados bingung.',
          id: 'Kambing berkata, "Aku hanya makan rumput, bukan daging." Macan pun menjadi bingung.',
          en: 'The goat said, "I only eat grass, not meat." The tiger became confused.',
        ),
        question: const Question(
          text: L10n(
            bali: 'Kambing manut kelompok buron napi?',
            id: 'Kambing termasuk kelompok hewan apa?',
            en: 'Which group of animals does the goat belong to?',
          ),
          options: [
            L10n(bali: 'Herbivora', id: 'Herbivora', en: 'Herbivore'),
            L10n(bali: 'Karnivora', id: 'Karnivora', en: 'Carnivore'),
            L10n(bali: 'Omnivora', id: 'Omnivora', en: 'Omnivore'),
            L10n(bali: 'Dekomposer', id: 'Pengurai', en: 'Decomposer'),
          ],
          correctIndex: 0,
          explanation: L10n(
            bali: 'Kambing ngamah tumbuh-tumbuhan dogén, dados herbivora.',
            id: 'Kambing hanya memakan tumbuhan, jadi kambing adalah herbivora.',
            en: 'Goats only eat plants, so they are herbivores.',
          ),
        ),
      ),
      StoryPart(
        imageUrl: '',
        narration: const L10n(
          bali: 'Padang tumbuh krana sunar surya. I Kambing ngamah padang, tur macan ngamah buron lianan. Ipun makejang magandengan ring rantai pangan.',
          id: 'Rumput tumbuh karena cahaya matahari. Kambing memakan rumput, dan macan memakan hewan lain. Semuanya terhubung dalam rantai makanan.',
          en: 'Grass grows thanks to sunlight. Goats eat grass, and tigers eat other animals. All of them are linked in a food chain.',
        ),
        question: const Question(
          text: L10n(
            bali: 'Ring rantai pangan, padang dados napi?',
            id: 'Dalam rantai makanan, rumput berperan sebagai apa?',
            en: 'In a food chain, what is the role of grass?',
          ),
          options: [
            L10n(bali: 'Produsen', id: 'Produsen', en: 'Producer'),
            L10n(bali: 'Konsumen tingkat satu', id: 'Konsumen tingkat satu', en: 'Primary consumer'),
            L10n(bali: 'Konsumen tingkat kalih', id: 'Konsumen tingkat dua', en: 'Secondary consumer'),
            L10n(bali: 'Pengurai', id: 'Pengurai', en: 'Decomposer'),
          ],
          correctIndex: 0,
          explanation: L10n(
            bali: 'Padang ngwangun ajengan padewekan nganggen sunar surya, dados produsen.',
            id: 'Rumput membuat makanannya sendiri dengan bantuan cahaya matahari, sehingga disebut produsen.',
            en: 'Grass makes its own food using sunlight, so it is called a producer.',
          ),
        ),
      ),
      StoryPart(
        imageUrl: '',
        narration: const L10n(
          bali: 'Wekasan macané sadar, soang-soang buron madué ajengan sané mabinaan. Ipun lantas luas ngalih ajengan lianan.',
          id: 'Akhirnya macan sadar bahwa setiap hewan punya makanan yang berbeda. Ia pun pergi mencari makanan lain.',
          en: 'Finally the tiger realized that every animal has different food. He went off to find something else to eat.',
        ),
        question: const Question(
          text: L10n(
            bali: 'Napi urutan rantai pangan sané patut?',
            id: 'Manakah urutan rantai makanan yang benar?',
            en: 'Which is the correct food chain order?',
          ),
          options: [
            L10n(bali: 'Padang, Kambing, Macan', id: 'Rumput, Kambing, Macan', en: 'Grass, Goat, Tiger'),
            L10n(bali: 'Macan, Kambing, Padang', id: 'Macan, Kambing, Rumput', en: 'Tiger, Goat, Grass'),
            L10n(bali: 'Kambing, Padang, Macan', id: 'Kambing, Rumput, Macan', en: 'Goat, Grass, Tiger'),
            L10n(bali: 'Padang, Macan, Kambing', id: 'Rumput, Macan, Kambing', en: 'Grass, Tiger, Goat'),
          ],
          correctIndex: 0,
          explanation: L10n(
            bali: 'Rantai pangan miwiti saking produsen: padang, kambing, wusan macan.',
            id: 'Rantai makanan dimulai dari produsen: rumput, lalu kambing, lalu macan.',
            en: 'A food chain starts with the producer: grass, then the goat, then the tiger.',
          ),
        ),
      ),
    ],
  ),
];