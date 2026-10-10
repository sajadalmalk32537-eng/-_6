// lib/main.dart

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'data.dart';

void main() => runApp(const TumaneenaApp());

class TumaneenaApp extends StatelessWidget {
  const TumaneenaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'طُمَأْنِينَة',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121318),
        primaryColor: const Color(0xFFD4AF37),
        cardColor: const Color(0xFF1E2028),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _timer;
  Duration _remainingTime = const Duration(hours: 8, minutes: 28, seconds: 59);

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime.inSeconds > 0) {
        setState(() {
          _remainingTime = _remainingTime - const Duration(seconds: 1);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(d.inHours)}:${twoDigits(d.inMinutes.remainder(60))}:${twoDigits(d.inSeconds.remainder(60))}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('طُمَأْنِينَة', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFD4AF37))),
        centerTitle: true,
        backgroundColor: const Color(0xFF181A20),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // بطاقة الوقت المتبقي للصلاة
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2026),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.4)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Color(0xFF2A2D37),
                        child: Icon(Icons.access_time_filled, color: Color(0xFFD4AF37)),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF332910),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text('صلاة الفجر 04:35', style: TextStyle(color: Color(0xFFD4AF37), fontSize: 12)),
                          ),
                          const SizedBox(height: 4),
                          const Text('الوقت المتبقي', style: TextStyle(color: Colors.grey, fontSize: 11)),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    _formatDuration(_remainingTime),
                    style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // بطاقة التاريخ الهجري والميلادي
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2026),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: const Row(
                children: [
                  Icon(Icons.calendar_today_rounded, color: Color(0xFFD4AF37)),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('السبت، 28 ربيع الثاني 1448 هـ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                      SizedBox(height: 2),
                      Text('10 تشرين الأول / أكتوبر 2026 م', style: TextStyle(color: Colors.amber, fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // كارت المسائل الشرعية وجيميناي الذكي عبر الإنترنت
            InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FiqhGeminiScreen())),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3D2E0A), Color(0xFF1E2028)],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFD4AF37)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Color(0xFFD4AF37),
                          child: Icon(Icons.balance_rounded, color: Colors.black),
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('المسائل الشرعية والفقهية', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
                            SizedBox(height: 2),
                            Text('إستفتاءات واسأل المساعد الذكي جيميناي', style: TextStyle(color: Color(0xFFD4AF37), fontSize: 11)),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(color: const Color(0xFFD4AF37), borderRadius: BorderRadius.circular(20)),
                      child: const Text('إسأل جيميناي 🤖', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 11)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text('الأقسام الرئيسية', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFD4AF37))),
            const SizedBox(height: 10),

            // شبكة الأقسام
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1,
              children: [
                _buildCard(context, 'المصحف الشريف', 'قراءة واستماع صوتي', Icons.menu_book_rounded, const QuranScreen()),
                _buildCard(context, 'الزيارات الشريفة', 'زيارات الأئمة والأيام', Icons.mosque_rounded, const ZeyaratScreen()),
                _buildCard(context, 'الأدعية والمناجيات', 'أدعية الأيام والمناجيات', Icons.wb_sunny_rounded, const AzkarScreen()),
                _buildCard(context, 'فضائل المعصومين', '10 فضائل لكل معصوم', Icons.auto_awesome_rounded, const VirtuesScreen()),
                _buildCard(context, 'شرف المؤمن', 'محراب صلاة الليل', Icons.nights_stay_rounded, const SalatAlLaylScreen()),
                _buildCard(context, 'المسبحة الإلكترونية', 'تسبيح الزهراء والأذكار', Icons.touch_app_rounded, const TasabeehScreen()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext ctx, String title, String sub, IconData icon, Widget page) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E2028),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: InkWell(
        onTap: () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => page)),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(backgroundColor: const Color(0xFF2A2D37), child: Icon(icon, color: const Color(0xFFD4AF37))),
              const SizedBox(height: 8),
              Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
              const SizedBox(height: 2),
              Text(sub, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}

// شاشة القرآن الكريم مع مشغل الاستماع الصوت
class QuranScreen extends StatelessWidget {
  const QuranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('القرآن الكريم (قراءة واستماع)'), backgroundColor: const Color(0xFF181A20)),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: AppData.quranSurahs.length,
        itemBuilder: (_, i) {
          final surah = AppData.quranSurahs[i];
          return Card(
            child: ExpansionTile(
              title: Text(surah['name']!, style: const TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold)),
              subtitle: Text('${surah['type']} • ${surah['verses']}'),
              children: [
                AudioPlayerWidget(audioUrl: surah['audioUrl']!, title: surah['name']!),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(surah['content']!, style: const TextStyle(fontSize: 16, height: 1.8), textAlign: TextAlign.right),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

// مشغل الصوت
class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;
  final String title;

  const AudioPlayerWidget({super.key, required this.audioUrl, required this.title});

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _toggleAudio() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(widget.audioUrl));
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2D37),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.headphones_rounded, color: Color(0xFFD4AF37), size: 20),
              const SizedBox(width: 8),
              Text('استماع تلاوة ${widget.title}', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          IconButton(
            icon: Icon(isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill, color: const Color(0xFFD4AF37), size: 30),
            onPressed: _toggleAudio,
          ),
        ],
      ),
    );
  }
}

// شاشة الفقه وجيميناي بالإنترنت
class FiqhGeminiScreen extends StatefulWidget {
  const FiqhGeminiScreen({super.key});

  @override
  State<FiqhGeminiScreen> createState() => _FiqhGeminiScreenState();
}

class _FiqhGeminiScreenState extends State<FiqhGeminiScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  final String _apiKey = "YOUR_GEMINI_API_KEY";

  final List<Map<String, String>> _messages = [
    {'sender': 'gemini', 'text': 'أهلاً بك يا سجاد في قسم المسائل الشرعية. اكتب سؤالك وسأجيبك فوراً عبر الذكاء الاصطناعي (Gemini) بالربط الحي.'}
  ];

  Future<void> _askGemini(String userQuery) async {
    if (userQuery.trim().isEmpty) return;
    setState(() {
      _messages.add({'sender': 'user', 'text': userQuery});
      _isLoading = true;
    });
    _controller.clear();

    final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$_apiKey');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": "أنت مساعد فقهي شيعي متخصص تجيب باختصار ودقة وفق فتاوى أهل البيت والسيد السيستاني. السؤال هو: $userQuery"}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['candidates'][0]['content']['parts'][0]['text'];
        setState(() {
          _messages.add({'sender': 'gemini', 'text': reply});
        });
      } else {
        setState(() {
          _messages.add({'sender': 'gemini', 'text': 'عذراً، حدث خطأ في الاتصال بالإنترنت أو بمفتاح API.'});
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({'sender': 'gemini', 'text': 'تأكد من اتصالك بشبكة الإنترنت وأعد المحاولة.'});
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المسائل الشرعية • الذكاء الاصطناعي'), backgroundColor: const Color(0xFF181A20)),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                const Text('استفتاءات وفتاوى شائعة:', style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 8),
                ...AppData.fiqhQuestions.map((q) => Card(
                  color: const Color(0xFF1E2028),
                  child: ExpansionTile(
                    title: Text(q['question']!, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                    subtitle: Text('القسم: ${q['category']}', style: const TextStyle(color: Colors.amber, fontSize: 10)),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(q['answer']!, style: const TextStyle(color: Colors.grey, fontSize: 13, height: 1.5)),
                      )
                    ],
                  ),
                )),
                const Divider(color: Color(0xFFD4AF37), height: 30),
                const Text('إسأل جيميناي (مباشر عبر الإنترنت):', style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 10),
                ..._messages.map((m) => Align(
                  alignment: m['sender'] == 'user' ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: m['sender'] == 'user' ? const Color(0xFFD4AF37) : const Color(0xFF2A2D37),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(m['text']!, style: TextStyle(color: m['sender'] == 'user' ? Colors.black : Colors.white, fontSize: 13)),
                  ),
                )),
                if (_isLoading) const Center(child: Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator(color: Color(0xFFD4AF37))))
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: const Color(0xFF181A20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'اكتب سؤالك الفقهي هنا للبحث بالإنترنت...',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(icon: const Icon(Icons.send_rounded, color: Color(0xFFD4AF37)), onPressed: () => _askGemini(_controller.text)),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// الزيارات الشريفة
class ZeyaratScreen extends StatelessWidget {
  const ZeyaratScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الزيارات الشريفة'), backgroundColor: const Color(0xFF181A20)),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: AppData.zeyaratList.length,
        itemBuilder: (_, i) => Card(
          child: ExpansionTile(
            title: Text(AppData.zeyaratList[i]['title']!, style: const TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold)),
            children: [Padding(padding: const EdgeInsets.all(16.0), child: Text(AppData.zeyaratList[i]['text']!, style: const TextStyle(fontSize: 15, height: 1.7)))],
          ),
        ),
      ),
    );
  }
}

// الأدعية والمناجيات
class AzkarScreen extends StatelessWidget {
  const AzkarScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الأدعية والمناجيات الخمس عشرة'), backgroundColor: const Color(0xFF181A20)),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          const Padding(padding: EdgeInsets.all(8.0), child: Text('الأدعية المشهورة', style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold))),
          ...AppData.adiyaList.map((item) => Card(
            child: ExpansionTile(title: Text(item['title']!, style: const TextStyle(fontWeight: FontWeight.bold)), children: [Padding(padding: const EdgeInsets.all(16), child: Text(item['text']!, style: const TextStyle(fontSize: 15, height: 1.7)))]),
          )),
          const Padding(padding: EdgeInsets.all(8.0), child: Text('المناجيات الخمس عشرة (الإمام السجاد ع)', style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold))),
          ...AppData.munajatList.map((item) => Card(
            child: ExpansionTile(title: Text(item['title']!, style: const TextStyle(fontWeight: FontWeight.bold)), children: [Padding(padding: const EdgeInsets.all(16), child: Text(item['text']!, style: const TextStyle(fontSize: 15, height: 1.7)))]),
          )),
        ],
      ),
    );
  }
}

// فضائل المعصومين (ع)
class VirtuesScreen extends StatelessWidget {
  const VirtuesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('10 فضائل وأحاديث لكل معصوم (ع)'), backgroundColor: const Color(0xFF181A20)),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: AppData.virtuesData.length,
        itemBuilder: (_, i) => Card(
          child: ExpansionTile(
            leading: const Icon(Icons.star, color: Color(0xFFD4AF37)),
            title: Text(AppData.virtuesData[i]['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            children: (AppData.virtuesData[i]['virtues'] as List<String>).map((v) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Align(alignment: Alignment.centerRight, child: Text(v, style: const TextStyle(fontSize: 13, height: 1.4))),
            )).toList(),
          ),
        ),
      ),
    );
  }
}

// شرف المؤمن (صلاة الليل)
class SalatAlLaylScreen extends StatelessWidget {
  const SalatAlLaylScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('شرف المؤمن (صلاة الليل)'), backgroundColor: const Color(0xFF181A20)),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: const [
          Card(child: ListTile(title: Text('أقوال في فضل صلاة الليل', style: TextStyle(color: Color(0xFFD4AF37))), subtitle: Text('"شرف المؤمن صلاته بالليل، وعزه كف الأذى عن الناس" - الرسول الأعظم (ص)\n\n"صلاة الليل تبيض الوجه وتجلب الرزق" - الإمام الصادق (ع)'))),
          Card(child: ListTile(title: Text('1. نافلة الليل (8 ركعات)'), subtitle: Text('تُصلى ركعتين ركعتين بنية نافلة الليل كصلاة الصبح (4 مرات).'))),
          Card(child: ListTile(title: Text('2. ركعتا الشفع (ركعتان)'), subtitle: Text('تُصلى ركعتين متصلتين دون قنوت، يُقرأ فيهما سورتا الفلق والناس.'))),
          Card(child: ListTile(title: Text('3. ركعة الوتر (ركعة واحدة)'), subtitle: Text('ركعة واحدة يُقرأ فيها القنوت مع الاستغفار 70 مرة والدعاء لـ 40 مؤمناً.'))),
        ],
      ),
    );
  }
}

// المسبحة الإلكترونية التفاعلية
class TasabeehScreen extends StatefulWidget {
  const TasabeehScreen({super.key});

  @override
  State<TasabeehScreen> createState() => _TasabeehState();
}

class _TasabeehState extends State<TasabeehScreen> {
  int _counter = 0;
  String _currentZikr = 'سُبْحَانَ اللَّهِ';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المسبحة الإلكترونية'), backgroundColor: const Color(0xFF181A20)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              dropdownColor: const Color(0xFF1E2028),
              value: _currentZikr,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFD4AF37)),
              items: <String>[
                'سُبْحَانَ اللَّهِ',
                'الْحَمْدُ لِلَّهِ',
                'لا إِلَهَ إِلا اللَّهُ',
                'اللَّهُ أَكْبَرُ',
                'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَآلِ مُحَمَّدٍ',
                'أَسْتَغْفِرُ اللَّهَ وَأَتُوبُ إِلَيْهِ'
              ].map((String value) => DropdownMenuItem<String>(value: value, child: Text(value))).toList(),
              onChanged: (newValue) => setState(() {
                _currentZikr = newValue!;
                _counter = 0;
              }),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () => setState(() => _counter++),
              child: CircleAvatar(
                radius: 90,
                backgroundColor: const Color(0xFF1E2028),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('$_counter', style: const TextStyle(fontSize: 52, fontWeight: FontWeight.bold, color: Color(0xFFD4AF37))),
                    const Text('اضغط للتسبيح', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => setState(() => _counter = 0),
              icon: const Icon(Icons.refresh),
              label: const Text('تصفير العدّاد'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade900, foregroundColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
