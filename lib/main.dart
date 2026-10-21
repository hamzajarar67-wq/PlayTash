import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(const PlayTashApp());
}

const gold = Color(0xFFD4AF37);



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLogin = true;
  bool loading = false;
  bool showPassword = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> submitEmailPassword() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email aur password likho')),
      );
      return;
    }

    setState(() => loading = true);

    try {
      if (isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      }

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainPage()),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Login failed')),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Widget inputField(
    String label,
    TextEditingController controller, {
    bool obscure = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        obscureText: obscure && !showPassword,
decoration: InputDecoration(
  labelText: label,
  suffixIcon: obscure
      ? IconButton(
          icon: Icon(
            showPassword
                ? Icons.visibility_off
                : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              showPassword = !showPassword;
            });
          },
        )
      : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.sports_esports, size: 70, color: gold),
                const SizedBox(height: 12),
                const Text(
                  'PlayTash',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  isLogin ? 'Login' : 'Create New Account',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                if (!isLogin)
                  inputField('User Name', TextEditingController()),
                inputField('Email', emailController),
                inputField('Password', passwordController, obscure: true),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: loading ? null : submitEmailPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: Text(
                    loading
                        ? 'Please wait...'
                        : isLogin
                            ? 'Login'
                            : 'Sign Up',
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() => isLogin = !isLogin),
                  child: Text(
                    isLogin
                        ? 'Create New Account / Sign Up'
                        : 'Already have an account? Login',
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 12),
                socialButton(
                  Icons.phone_android,
                  'Continue with Mobile OTP',
                ),
                const SizedBox(height: 10),
                socialButton(Icons.g_mobiledata, 'Continue with Google'),
                const SizedBox(height: 10),
                socialButton(Icons.facebook, 'Continue with Facebook'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget socialButton(IconData icon, String label) {
    return OutlinedButton.icon(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ye option baad mein activate hoga'),
          ),
        );
      },
      icon: Icon(icon, color: Colors.black),
      label: Text(label, style: const TextStyle(color: Colors.black)),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        side: const BorderSide(color: Colors.black),
      ),
    );
  }
}





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
      home: const LoginPage(),
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
  final User? currentUser = FirebaseAuth.instance.currentUser;

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

    int selectedRoomTab = 0;

  Widget roomPage() {
    final roomTabs = [
      'All Room',
      'Popular Room',
      'My Room',
    ];

    final allRooms = [
      {'name': 'Ali', 'id': '100001', 'popular': true, 'mine': false},
      {'name': 'Hamza', 'id': '100002', 'popular': true, 'mine': true},
      {'name': 'Bilal', 'id': '100003', 'popular': false, 'mine': false},
      {'name': 'Umar', 'id': '100004', 'popular': true, 'mine': false},
    ];

    final filteredRooms = allRooms.where((room) {
      if (selectedRoomTab == 1) return room['popular'] == true;
      if (selectedRoomTab == 2) return room['mine'] == true;
      return true;
    }).toList();

    return StatefulBuilder(
      builder: (context, setRoomState) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search room name or 6-digit ID',
                  prefixIcon: const Icon(Icons.search, color: gold),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: gold),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: List.generate(roomTabs.length, (index) {
                  final isSelected = selectedRoomTab == index;

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          onPressed: () {
                            setRoomState(() {
                              selectedRoomTab = index;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isSelected ? Colors.black : Colors.white,
                            foregroundColor:
                                isSelected ? Colors.white : Colors.black,
                            elevation: 0,
                            padding: EdgeInsets.zero,
                            side: const BorderSide(color: gold),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              roomTabs[index],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredRooms.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.15,
                ),
                itemBuilder: (context, index) {
                  final room = filteredRooms[index];

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: gold, width: 1.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.meeting_room_outlined,
                          size: 38,
                          color: gold,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          room['name'] as String,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'ID: ${room['id']}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
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
        'Help Center',
        'Log Out',
        'Delete Account',
      ])
        box(
          item,
          icon: item == 'Privacy'
              ? Icons.lock_outline
              : item == 'Account'
                  ? Icons.manage_accounts_outlined
                  : item == 'Help Center'
                      ? Icons.help_outline
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
              : item == 'Account'
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AccountPage(),
                        ),
                      );
                    }
                  : item == 'Help Center'
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HelpCenterPage(),
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

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPrivacySettings();
  }

  Future<void> _loadPrivacySettings() async {
  try {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      doNotFollowMe =
          prefs.getBool('doNotFollowMe') ?? false;

      doNotDisturb =
          prefs.getBool('doNotDisturb') ?? false;

      doNotRequest =
          prefs.getBool('doNotRequest') ?? false;

      profileVisitor =
          prefs.getBool('profileVisitor') ?? true;

      onlineStatus =
          prefs.getBool('onlineStatus') ?? true;

      isLoading = false;
    });
  } catch (e) {
    debugPrint('Privacy loading error: $e');

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Privacy error: $e'),
      ),
    );
  }
}

  Future<void> _savePrivacySetting(
    String key,
    bool value,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final saved = await prefs.setBool(key, value);

      await prefs.reload();

      final savedValue = prefs.getBool(key);

      if (!mounted) return;

      if (!saved || savedValue != value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Could not save setting. Please try again.',
            ),
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save privacy setting.'),
        ),
      );
    }
  }

  Future<void> _changeSetting(
    String key,
    bool value,
  ) async {
    if (isLoading) return;

    final prefs = await SharedPreferences.getInstance();

    final previousValue = prefs.getBool(key);

    setState(() {
      switch (key) {
        case 'doNotFollowMe':
          doNotFollowMe = value;
          break;
        case 'doNotDisturb':
          doNotDisturb = value;
          break;
        case 'doNotRequest':
          doNotRequest = value;
          break;
        case 'profileVisitor':
          profileVisitor = value;
          break;
        case 'onlineStatus':
          onlineStatus = value;
          break;
      }
    });

    await _savePrivacySetting(key, value);

    await prefs.reload();

    if (!mounted) return;

    final currentValue = prefs.getBool(key);

    if (currentValue != value) {
      setState(() {
        switch (key) {
          case 'doNotFollowMe':
            doNotFollowMe = previousValue ?? false;
            break;
          case 'doNotDisturb':
            doNotDisturb = previousValue ?? false;
            break;
          case 'doNotRequest':
            doNotRequest = previousValue ?? false;
            break;
          case 'profileVisitor':
            profileVisitor = previousValue ?? true;
            break;
          case 'onlineStatus':
            onlineStatus = previousValue ?? true;
            break;
        }
      });
    }
  }

  Widget privacyOption({
    required String title,
    required String description,
    required bool value,
    required String keyName,
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
            onTap: isLoading
                ? null
                : () => _changeSetting(
                      keyName,
                      !value,
                    ),
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
                  if (!value)
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
                  if (value)
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
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                privacyOption(
                  title: 'Do Not Follow Me',
                  description:
                      'Control whether friends can enter your room.',
                  value: doNotFollowMe,
                  keyName: 'doNotFollowMe',
                ),
                privacyOption(
                  title: 'Do Not Disturb',
                  description:
                      'Control visibility of your game status.',
                  value: doNotDisturb,
                  keyName: 'doNotDisturb',
                ),
                privacyOption(
                  title: 'Do Not Request',
                  description:
                      'Control whether others can send you requests.',
                  value: doNotRequest,
                  keyName: 'doNotRequest',
                ),
                privacyOption(
                  title: 'Profile Visitor',
                  description:
                      'Allow others to open your profile.',
                  value: profileVisitor,
                  keyName: 'profileVisitor',
                ),
                privacyOption(
                  title: 'Online Status',
                  description:
                      'Control the online indicator shown to friends.',
                  value: onlineStatus,
                  keyName: 'onlineStatus',
                ),
              ],
            ),
    );
  }
}



class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  static const Color gold = Color(0xFFD4AF37);

  void _showMessage(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title ki functionality baad mein connect hogi.'),
      ),
    );
  }

  Widget _accountOption(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: gold, width: 1.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: gold, size: 27),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: gold,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Account',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _accountOption(
            context,
            title: 'Change Email',
            icon: Icons.email_outlined,
            onTap: () => _showMessage(context, 'Change Email'),
          ),
          _accountOption(
            context,
            title: 'Change Phone Number',
            icon: Icons.phone_android,
            onTap: () => _showMessage(context, 'Change Phone Number'),
          ),
          _accountOption(
            context,
            title: 'Change Password',
            icon: Icons.lock_outline,
            onTap: () => _showMessage(context, 'Change Password'),
          ),
          _accountOption(
            context,
            title: 'Google Link',
            icon: Icons.g_mobiledata,
            onTap: () => _showMessage(context, 'Google Link'),
          ),
          _accountOption(
            context,
            title: 'Facebook Link',
            icon: Icons.facebook,
            onTap: () => _showMessage(context, 'Facebook Link'),
          ),
          _accountOption(
            context,
            title: 'Account Information',
            icon: Icons.info_outline,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const AccountInformationPage(),
                ),
              );
            },
          ),
          _accountOption(
            context,
            title: 'Account Icon',
            icon: Icons.account_circle_outlined,
            onTap: () => _showMessage(context, 'Account Icon'),
          ),
        ],
      ),
    );
  }
}

class AccountInformationPage extends StatelessWidget {
  const AccountInformationPage({super.key});

  static const Color gold = Color(0xFFD4AF37);

  Widget _informationRow({
    required IconData icon,
    required String title,
    required String value,
    String? subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: gold, width: 1.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: gold, size: 28),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Account Information',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _informationRow(
            icon: Icons.email_outlined,
            title: 'Gmail',
            value: 'Not linked',
          ),
          _informationRow(
            icon: Icons.lock_outline,
            title: 'Password',
            value: 'Hidden for security',
          ),
          _informationRow(
            icon: Icons.person_outline,
            title: 'User Name',
            value: 'Not set',
          ),
          _informationRow(
            icon: Icons.badge_outlined,
            title: 'UID',
            value: 'Not Assigned',
            subtitle: 'Future mein 6-digit UID yahan show hoga.',
          ),
          _informationRow(
            icon: Icons.phone_android,
            title: 'Mobile Number',
            value: 'Not linked',
          ),
        ],
      ),
    );
  }
}

// ================= HELP CENTER =================

const Color helpGold = Color(0xFFD4AF37);

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  static const Map<String, List<String>> categories = {
    'FAQ': [
      'Account Creation FAQs',
      'Coins Purchase FAQs',
      'Gifts FAQs',
      'Rooms & Voice Chat FAQs',
      'Games FAQs',
      'Profile & UID FAQs',
    ],
    'Coins Help Center': [
      'How to Purchase Coins',
      'Payment Methods',
      'Purchase Failed',
      'Coins Not Received',
      'Purchase History',
      'Refund Policy',
      'Purchase FAQs',
    ],
    'Room Help Center': [
      'How to Join a Room',
      'How to Create a Room',
      'Microphone Not Working',
      'Voice Chat Problems',
      'Room Owner & Admin Help',
    ],
    'Game Help Center': [
      'How to Play Games',
      'Game Rules',
      'Game Not Opening',
      'Game Problems & Errors',
    ],
    'Account & Profile': [
      'Login Problems',
      'Forgot Password',
      'Change Username',
      'Profile Photo Problems',
      'UID Help',
      'Account Security',
    ],
    'Safety & Report': [
      'Report a User',
      'Harassment or Abuse Report',
      'Block a User',
      'Report a Fake Account',
      'Community Guidelines',
    ],
    'Contact Support': [
      'Contact Support',
      'Report a Technical Problem',
      'Submit a Purchase Complaint',
      'Check Support Request',
    ],
    'Policies & Information': [
      'Terms of Service',
      'Privacy Policy',
      'Refund Policy',
      'Community Guidelines',
      'About PlayTash',
      'App Version',
    ],
    'Report Problem': [
      'App Not Working',
      'Login Error',
      'Coins Purchase Problem',
      'Room Problem',
      'Game Problem',
      'Other Problems',
    ],
  };

  static const List<IconData> categoryIcons = [
    Icons.quiz_outlined,
    Icons.monetization_on_outlined,
    Icons.meeting_room_outlined,
    Icons.sports_esports_outlined,
    Icons.person_outline,
    Icons.shield_outlined,
    Icons.support_agent,
    Icons.policy_outlined,
    Icons.report_problem_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    final names = categories.keys.toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Help Center',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: helpGold, width: 1.5),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.support_agent,
                  size: 48,
                  color: helpGold,
                ),
                SizedBox(height: 10),
                Text(
                  'How can we help you?',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Select a category to find help.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          for (int i = 0; i < names.length; i++)
            _HelpCard(
              title: names[i],
              icon: categoryIcons[i],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HelpCategoryPage(
                      title: names[i],
                      topics: categories[names[i]]!,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

// ================ CATEGORY PAGE =================

class HelpCategoryPage extends StatelessWidget {
  final String title;
  final List<String> topics;

  const HelpCategoryPage({
    super.key,
    required this.title,
    required this.topics,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Choose a topic below.',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 16),
          for (final topic in topics)
            _HelpCard(
              title: topic,
              icon: Icons.article_outlined,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HelpTopicPage(title: topic),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

// ================= TOPIC PAGE ===================

class HelpTopicPage extends StatelessWidget {
  final String title;

  const HelpTopicPage({
    super.key,
    required this.title,
  });

  String get description {
    if (title.contains('Coin') ||
        title.contains('Purchase') ||
        title.contains('Payment') ||
        title.contains('Refund')) {
      return 'Yahan coins aur purchases se related maloomat di jayegi. '
          'Agar payment ya coins ka masla ho, to apni purchase details '
          'tayyar rakhein. Support functionality baad mein connect hogi.';
    }

    if (title.contains('Room') ||
        title.contains('Microphone') ||
        title.contains('Voice Chat')) {
      return 'Room aur voice chat ke masail ke liye apna internet '
          'connection aur microphone permission check karein. '
          'Mazeed room support options baad mein add honge.';
    }

    if (title.contains('Game')) {
      return 'Game se related maslay ke liye internet connection '
          'check karein aur app ko dobara khol kar dekhein. '
          'Mazeed game help details baad mein add hongi.';
    }

    if (title.contains('Login') ||
        title.contains('Account') ||
        title.contains('Password') ||
        title.contains('Username') ||
        title.contains('Profile') ||
        title.contains('UID')) {
      return 'Account aur profile se related madad ke liye '
          'apni account information tayyar rakhein. '
          'Account support ki functionality baad mein connect hogi.';
    }

    if (title.contains('Report') ||
        title.contains('Problem') ||
        title.contains('Error')) {
      return 'Apne maslay ki tafseel note karein. '
          'Report submit karne aur support se rabta karne ka '
          'system baad mein connect kiya jayega.';
    }

    if (title.contains('Policy') ||
        title.contains('Terms') ||
        title.contains('Guidelines') ||
        title.contains('About') ||
        title.contains('Version')) {
      return 'Is page par PlayTash ki mutaliqa information '
          'di jayegi. Asal policy aur app details baad mein '
          'add ki jayengi.';
    }

    if (title.contains('Block') ||
        title.contains('Safety') ||
        title.contains('Abuse') ||
        title.contains('Fake')) {
      return 'Safety se related maslay ko sanjeedgi se lein. '
          'Report aur block karne ki functionality baad mein '
          'connect ki jayegi.';
    }

    return 'Yahan "$title" se related tafseeli madad di jayegi. '
        'Yeh abhi design ka hissa hai. Asal help aur support '
        'functionality baad mein connect ki jayegi.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: helpGold, width: 1.5),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.help_outline,
                  size: 42,
                  color: helpGold,
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'PlayTash Help Center',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// ================= REUSABLE CARD =================

class _HelpCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _HelpCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: helpGold, width: 1.3),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 5,
        ),
        leading: Icon(icon, color: helpGold, size: 27),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: helpGold,
          size: 17,
        ),
        onTap: onTap,
      ),
    );
  }
}
