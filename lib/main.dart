import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const PlayTashApp());
}

const gold = Color(0xFFD4AF37);

class PlayTashApp extends StatelessWidget {
  const PlayTashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PlayTash',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: gold,
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int page = 0;

  final titles = [
    'Home',
    'Room',
    'Game',
    'Wallet',
    'Profile',
    'Setting',
  ];

  @override
  Widget build(BuildContext context) {
    final pages = [
      homePage(),
      roomPage(),
      gamePage(),
      walletPage(),
      profilePage(),
      settingPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          page == 0 ? 'Welcome to PlayTash' : titles[page],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(child: pages[page]),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFFFF3CC),
        selectedIndex: page,
        onDestinationSelected: (index) {
          setState(() => page = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.mic_none),
            label: 'Room',
          ),
          NavigationDestination(
            icon: Icon(Icons.style_outlined),
            label: 'Game',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: 'Wallet',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            label: 'Setting',
          ),
        ],
      ),
    );
  }

  Widget box(
    String text, {
    IconData? icon,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 17,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: gold, width: 1.3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: gold),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (onTap != null)
              const Icon(
                Icons.arrow_forward_ios,
                size: 15,
                color: gold,
              ),
          ],
        ),
      ),
    );
  }

  Widget heading(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        border: Border.all(color: gold, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget homePage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final item in [
          'New Event',
          'New Update',
          'Free Reward',
          'Daily Task',
          'New Daily Reward',
        ])
          box(item, icon: Icons.star_outline),
      ],
    );
  }

  Widget roomPage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'Search room name or 6-digit ID',
            prefixIcon: const Icon(Icons.search, color: gold),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: gold),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            for (final item in [
              'All Room',
              'Popular Room',
              'My Room',
            ])
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      side: const BorderSide(color: gold),
                    ),
                    child: Text(
                      item,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget gamePage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        heading('NOW PLAYING TASH'),
        Row(
          children: [
            for (final item in [
              'Tash Box',
              'Tash Board',
              'Tash',
            ])
              Expanded(
                child: Container(
                  height: 90,
                  margin: const EdgeInsets.only(right: 7),
                  decoration: BoxDecoration(
                    border: Border.all(color: gold, width: 1.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      item,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: box('2 Player', icon: Icons.person),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: box('4 Player', icon: Icons.people),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: box('Battle Game 1v1'),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: box('Private Game'),
            ),
          ],
        ),
      ],
    );
  }

  Widget walletPage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        heading('My Wallet'),
        box('Coins: 0', icon: Icons.monetization_on_outlined),
        box('Recharge', icon: Icons.add_card),
        box('Transaction History', icon: Icons.history),
      ],
    );
  }

  Widget profilePage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        heading('👤  Profile Name\nUID: 000000'),
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 18),
          decoration: BoxDecoration(
            border: Border.all(color: gold, width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            children: [
              Expanded(child: Text('Followers\n0', textAlign: TextAlign.center)),
              Expanded(child: Text('Following\n0', textAlign: TextAlign.center)),
              Expanded(child: Text('Sent Gift\n0', textAlign: TextAlign.center)),
              Expanded(child: Text('Received Gift\n0', textAlign: TextAlign.center)),
            ],
          ),
        ),
        for (final item in [
          'Edit Profile',
          'Customize Centre',
          'Friend Center',
          'Notification',
          'Royal Badge & Achievement',
          'Profile Activity',
        ])
          box(item, icon: Icons.arrow_forward),
      ],
    );
  }

  Widget settingPage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final item in [
          'Privacy',
          'Account',
          'Language',
          'Help Center',
          'Personal Info',
          'Log Out',
          'Delete Account',
        ])
         box(
  item,
  icon: item == 'Privacy'
      ? Icons.lock_outline
      : Icons.settings_outlined,
  onTap: item == 'Privacy'
      ? () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PrivacyPage(),
            ),
          );
        }
      : null,
),
      ],
    );
  }
}



class PrivacyPage extends StatefulWidget {
  const PrivacyPage({super.key});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
    bool doNotFollowMe = false;
  bool doNotDisturb = false;
  bool doNotRequest = false;
  bool profileVisitor = true;
  bool onlineStatus = true;

  @override
  void initState() {
    super.initState();
    _loadPrivacySettings();
  }

  Future<void> _loadPrivacySettings() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      doNotFollowMe = prefs.getBool('doNotFollowMe') ?? false;
      doNotDisturb = prefs.getBool('doNotDisturb') ?? false;
      doNotRequest = prefs.getBool('doNotRequest') ?? false;
      profileVisitor = prefs.getBool('profileVisitor') ?? true;
      onlineStatus = prefs.getBool('onlineStatus') ?? true;
    });
  }

  Future<void> _savePrivacySetting(
  String key,
  bool value,
) async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setBool(key, value);

  final checkPrefs = await SharedPreferences.getInstance();
  final savedValue = checkPrefs.getBool(key);

  if (savedValue != value && mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Privacy setting could not be saved. Please try again.',
        ),
      ),
    );
  }
    
    Widget privacyOption({
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: gold,
          width: 1.2,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => onChanged(!value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 88,
              height: 36,
              padding: const EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: value
                    ? Colors.green.shade600
                    : Colors.red.shade600,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                mainAxisAlignment: value
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  if (!value) ...[
                    const Expanded(
                      child: Center(
                        child: Text(
                          'OFF',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                  Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      value ? Icons.check : Icons.close,
                      size: 17,
                      color: value
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                  if (value) ...[
                    const Expanded(
                      child: Center(
                        child: Text(
                          'ON',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
  backgroundColor: Colors.white,
  elevation: 0,
  leadingWidth: 64,
  leading: IconButton(
    icon: const Icon(
      Icons.arrow_back,
      size: 32,
      color: Colors.black,
    ),
    onPressed: () {
      Navigator.pop(context);
    },
  ),
  title: const Text(
    '🔒 Privacy',
    style: TextStyle(
      color: Colors.black,
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
  ),
),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          privacyOption(
            title: 'Do Not Follow Me',
            description: 'Control whether friends can enter your room.',
            value: doNotFollowMe,
            onChanged: (value) async {
  setState(() => doNotFollowMe = value);
  await _savePrivacySetting('doNotFollowMe', value);
},
          ),

          
          privacyOption(
            title: 'Do Not Disturb',
            description: 'Control visibility of your game status.',
            value: doNotDisturb,
            onChanged: (value) async {
  setState(() => doNotDisturb = value);
  await _savePrivacySetting('doNotDisturb', value);
},
          ),

          
          privacyOption(
            title: 'Do Not Request',
            description: 'Control whether others can send you requests.',
            value: doNotRequest,
            onChanged: (value) async {
  setState(() => doNotRequest = value);
  await _savePrivacySetting('doNotRequest', value);
},
          ),

          
          privacyOption(
            title: 'Profile Visitor',
            description: 'Allow others to open your profile.',
            value: profileVisitor,
            onChanged: (value) async {
  setState(() => profileVisitor = value);
  await _savePrivacySetting('profileVisitor', value);
},
          ),



          
          privacyOption(
            title: 'Online Status',
            description: 'Control the online indicator shown to friends.',
            value: onlineStatus,
            onChanged: (value) async {
  setState(() => onlineStatus = value);
  await _savePrivacySetting('onlineStatus', value);
},
          ),
        ],
      ),
    );
  }
}




