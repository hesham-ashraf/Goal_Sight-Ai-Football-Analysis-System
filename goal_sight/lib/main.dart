import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'providers/match_provider.dart';
import 'pages/add_match_page.dart';
import 'pages/settings_page.dart';
import 'pages/match_history_page.dart';
import 'pages/about_page.dart';
import 'pages/charts_page.dart';
import 'models/match.dart';

// Premium Luxury Color Palette
const Color _primaryGold = Color(0xFFFFD700); // Rich Gold
const Color _accentAmber = Color(0xFFFFA000); // Deep Amber
const Color _darkBackground = Color(0xFF0A0A0F); // Deep Black
const Color _darkerBackground = Color(0xFF050508); // Almost Black
const Color _cardDark = Color(0xFF1A1A24); // Rich Dark Blue-Gray
const Color _cardLighter = Color(0xFF252530); // Lighter Dark Blue-Gray
const Color _textPrimary = Color(0xFFFFFFFF);
const Color _textSecondary = Color(0xFFB8B8C8);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(GoalSightApp());
}

class GoalSightApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MatchProvider()..loadMatches(),
      child: MaterialApp(
      title: 'GoalSight',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: _darkBackground,
        colorScheme: ColorScheme.dark(
          primary: _primaryGold,
          secondary: _accentAmber,
          surface: _cardDark,
          onSurface: _textPrimary,
          onPrimary: _darkBackground,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: _primaryGold),
        ),
        textTheme: TextTheme(
          displayLarge: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w900,
            color: _textPrimary,
            letterSpacing: -1.0,
            height: 1.1,
          ),
          headlineLarge: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: _textPrimary,
            letterSpacing: -0.5,
          ),
          headlineMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: _textPrimary,
            letterSpacing: 0.0,
          ),
          headlineSmall: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: _textPrimary,
            letterSpacing: 0.5,
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: _textPrimary,
            letterSpacing: 0.3,
          ),
          titleMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: _textPrimary,
            letterSpacing: 0.2,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: _textSecondary,
            height: 1.5,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: _textSecondary,
            height: 1.5,
          ),
        ),
      ),
      home: MainNavigation(),
      ),
    );
  }
}

// Modern Card Widget 
class ModernCard extends StatefulWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final bool showBorder;
  final VoidCallback? onTap;

  const ModernCard({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius,
    this.backgroundColor,
    this.showBorder = true,
    this.onTap,
  }) : super(key: key);

  @override
  _ModernCardState createState() => _ModernCardState();
}

class _ModernCardState extends State<ModernCard> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPressed = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _glowAnimation = Tween<double>(begin: 0.08, end: 0.25).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap?.call();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _isPressed ? 0.98 : _scaleAnimation.value,
              child: Container(
                width: widget.width,
                height: widget.height,
                margin: widget.margin,
                padding: widget.padding,
                decoration: BoxDecoration(
                  color: widget.backgroundColor ?? _cardDark,
                  borderRadius: widget.borderRadius ?? BorderRadius.circular(20),
                  border: widget.showBorder
                      ? Border.all(
                          color: _primaryGold.withOpacity(_isHovered ? 0.4 : 0.2),
                          width: _isHovered ? 1.5 : 1,
                        )
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: _isHovered ? 28 : 20,
                      offset: Offset(0, _isHovered ? 8 : 4),
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: _primaryGold.withOpacity(_glowAnimation.value),
                      blurRadius: _isHovered ? 40 : 30,
                      offset: Offset(0, 0),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: widget.child,
              ),
            );
          },
        ),
      ),
    );
  }
}

// Hover Button Widget
class _HoverButton extends StatefulWidget {
  final Widget child;
  final bool isPrimary;
  final VoidCallback onPressed;

  const _HoverButton({
    Key? key,
    required this.child,
    required this.isPrimary,
    required this.onPressed,
  }) : super(key: key);

  @override
  _HoverButtonState createState() => _HoverButtonState();
}

class _HoverButtonState extends State<_HoverButton> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPressed = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _glowAnimation = Tween<double>(begin: 0.5, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onPressed();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _isPressed ? 0.95 : _scaleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  gradient: widget.isPrimary
                      ? LinearGradient(
                          colors: [_primaryGold, _accentAmber],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  borderRadius: BorderRadius.circular(20),
                  border: widget.isPrimary
                      ? null
                      : Border.all(
                          color: _primaryGold,
                          width: 2,
                        ),
                  boxShadow: widget.isPrimary
                      ? [
                          BoxShadow(
                            color: _primaryGold.withOpacity(_glowAnimation.value),
                            blurRadius: _isHovered ? 32 : 24,
                            offset: Offset(0, _isHovered ? 12 : 8),
                          ),
                          BoxShadow(
                            color: _primaryGold.withOpacity(_glowAnimation.value * 0.6),
                            blurRadius: _isHovered ? 50 : 40,
                            offset: Offset(0, 0),
                          ),
                        ]
                      : _isHovered
                          ? [
                              BoxShadow(
                                color: _primaryGold.withOpacity(0.3),
                                blurRadius: 20,
                                offset: Offset(0, 4),
                              ),
                            ]
                          : null,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: widget.child,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Subtle Gradient Background
class SubtleGradientBackground extends StatelessWidget {
  final Widget child;

  const SubtleGradientBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _darkBackground,
            _darkerBackground,
          ],
          stops: [0.0, 1.0],
        ),
      ),
      child: child,
    );
  }
}

// ----------------- Bottom Navigation -----------------
class MainNavigation extends StatefulWidget {
  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> with SingleTickerProviderStateMixin {
  int _index = 0;
  late AnimationController _animationController;

  final List<Widget> pages = [
    HomePage(),
    MatchAnalysisPage(),
    LiveStatsPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SubtleGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(0.1, 0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                )),
                child: child,
              ),
            );
          },
          child: pages[_index],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: _cardDark,
            border: Border(
              top: BorderSide(
                color: _primaryGold.withOpacity(0.25),
                width: 1,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            child: Container(
              height: 70,
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(Icons.home_rounded, 'Home', 0),
                  _buildNavItem(Icons.analytics_rounded, 'Analysis', 1),
                  _buildNavItem(Icons.live_tv_rounded, 'Live', 2),
                  _buildNavItem(Icons.person_rounded, 'Profile', 3),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _index == index;
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() => _index = index);
            _animationController.forward(from: 0);
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? _primaryGold.withOpacity(0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? _primaryGold
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? _darkBackground : _textSecondary,
                    size: 20,
                  ),
                ),
                SizedBox(height: 3),
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? _primaryGold : _textSecondary,
                      fontSize: 10,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ----------------- Home Page -----------------
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Load matches when page is first displayed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MatchProvider>(context, listen: false).loadMatches();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 400;
    final padding = isSmall ? 20.0 : 28.0;

    return SafeArea(
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        scrollBehavior: ScrollConfiguration.of(context).copyWith(
          scrollbars: false,
          overscroll: true,
        ),
        slivers: [
          SliverAppBar(
            expandedHeight: 160,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [_primaryGold, _accentAmber],
                ).createShader(bounds),
                child: Text(
                  'GOALSIGHT',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3.0,
                    color: Colors.white,
                  ),
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _primaryGold.withOpacity(0.12),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(padding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildWelcomeSection(context),
                SizedBox(height: 32),
                _buildActionButtons(context, isSmall),
                SizedBox(height: 40),
                _buildSectionHeader('Recent Matches', context),
                SizedBox(height: 20),
              ]),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: padding),
            sliver: Consumer<MatchProvider>(
              builder: (context, matchProvider, child) {
                if (matchProvider.isLoading && matchProvider.matches.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(_primaryGold),
                      ),
                    ),
                  );
                }

                if (matchProvider.matches.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.sports_soccer_rounded,
                            size: 64,
                            color: _textSecondary,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No matches yet',
                            style: TextStyle(
                              color: _textSecondary,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Tap "New Match" to add one',
                            style: TextStyle(
                              color: _textSecondary.withOpacity(0.7),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final match = matchProvider.matches[index];
                      return TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: Duration(milliseconds: 300 + (index * 50)),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(0, 30 * (1 - value)),
                            child: Opacity(
                              opacity: value,
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 16),
                                child: _buildMatchCard(context, match, index),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    childCount: matchProvider.matches.length,
                  ),
                );
              },
            ),
          ),
          SliverPadding(padding: EdgeInsets.only(bottom: padding)),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back,',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 18,
                color: _textSecondary,
              ),
        ),
        SizedBox(height: 8),
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [_primaryGold, _accentAmber],
          ).createShader(bounds),
          child: Text(
            'Analyst',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 48,
                  color: Colors.white,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isSmall) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildPremiumButton(
                context,
                icon: Icons.play_arrow_rounded,
                label: 'Start Live',
                isPrimary: true,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Live mode opened'),
                      backgroundColor: _primaryGold,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildPremiumButton(
                context,
                icon: Icons.analytics_rounded,
                label: 'New Match',
                isPrimary: false,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddMatchPage(),
                    ),
                  ).then((_) {
                    // Refresh matches when returning from AddMatchPage
                    Provider.of<MatchProvider>(context, listen: false).loadMatches();
                  });
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: _buildPremiumButton(
            context,
            icon: Icons.cloud_download_rounded,
            label: 'Test API Call',
            isPrimary: false,
            onPressed: () async {
            final provider = Provider.of<MatchProvider>(context, listen: false);
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(_primaryGold),
                ),
              ),
            );
            
            final data = await provider.fetchMatchDataFromAPI();
            Navigator.pop(context); // Close loading dialog
            
            if (data != null) {
              // Show API data in a dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: _cardDark,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [_primaryGold, _accentAmber],
                    ).createShader(bounds),
                    child: Text(
                      'API DATA FETCHED',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (data['homeTeam'] != null) ...[
                          _buildApiDataRow('Home Team', data['homeTeam']),
                          _buildApiDataRow('Away Team', data['awayTeam']),
                        ],
                        if (data['score'] != null && data['score']['fullTime'] != null) ...[
                          _buildApiDataRow('Score', 
                            '${data['score']['fullTime']['home']} - ${data['score']['fullTime']['away']}'),
                        ],
                        if (data['competition'] != null)
                          _buildApiDataRow('Competition', data['competition']),
                        if (data['status'] != null)
                          _buildApiDataRow('Status', data['status']),
                        if (data['statistics'] != null) ...[
                          SizedBox(height: 12),
                          Divider(color: _textSecondary.withOpacity(0.2)),
                          SizedBox(height: 12),
                          Text(
                            'Statistics:',
                            style: TextStyle(
                              color: _primaryGold,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 8),
                          if (data['statistics']['possession'] != null)
                            _buildApiDataRow('Possession', 
                              '${data['statistics']['possession']['home']}% - ${data['statistics']['possession']['away']}%'),
                          if (data['statistics']['shots'] != null)
                            _buildApiDataRow('Shots', 
                              '${data['statistics']['shots']['home']} - ${data['statistics']['shots']['away']}'),
                        ],
                        _buildApiDataRow('Fetched At', 
                          DateTime.parse(data['fetchedAt']).toString().substring(0, 19)),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Close',
                        style: TextStyle(color: _primaryGold),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.error, color: _textPrimary),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(provider.error ?? 'API call failed'),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.red[700],
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  duration: Duration(seconds: 3),
                ),
              );
            }
          },
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isPrimary,
    required VoidCallback onPressed,
  }) {
    return _HoverButton(
      isPrimary: isPrimary,
      onPressed: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 18, horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isPrimary ? _darkBackground : _primaryGold,
              size: 26,
            ),
            SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: isPrimary ? _darkBackground : _primaryGold,
                fontSize: 17,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, BuildContext context) {
    return Row(
      children: [
        Container(
          width: 5,
          height: 28,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_primaryGold, _accentAmber],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(3),
            boxShadow: [
              BoxShadow(
                color: _primaryGold.withOpacity(0.6),
                blurRadius: 10,
                offset: Offset(0, 0),
              ),
            ],
          ),
        ),
        SizedBox(width: 16),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }

  Widget _buildApiDataRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: _textSecondary,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: _textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchCard(BuildContext context, match, int index) {
    final dateStr = '${match.matchDate.day}/${match.matchDate.month}/${match.matchDate.year}';
    return ModernCard(
      padding: EdgeInsets.all(20),
      onTap: () {},
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_primaryGold, _accentAmber],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: _primaryGold.withOpacity(0.4),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'M${index + 1}',
                style: TextStyle(
                  color: _darkBackground,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${match.teamA} vs ${match.teamB}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded,
                        size: 16, color: _textSecondary),
                    SizedBox(width: 6),
                    Text(
                      dateStr,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(width: 16),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _primaryGold.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _primaryGold.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '${match.scoreA} - ${match.scoreB}',
                        style: TextStyle(
                          color: _primaryGold,
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded,
              color: _textSecondary, size: 28),
        ],
      ),
    );
  }
}

// ----------------- Match Analysis Page -----------------
class MatchAnalysisPage extends StatefulWidget {
  @override
  _MatchAnalysisPageState createState() => _MatchAnalysisPageState();
}

class _MatchAnalysisPageState extends State<MatchAnalysisPage> {
  Match? _selectedMatch;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<MatchProvider>(context, listen: false);
      provider.loadMatches();
      if (provider.matches.isNotEmpty) {
        setState(() {
          _selectedMatch = provider.matches.first;
        });
      }
    });
  }

  void _showMatchSummaryDialog(BuildContext context, Match match) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [_primaryGold, _accentAmber],
          ).createShader(bounds),
          child: Text(
            'DETAILED MATCH SUMMARY',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryRow('Teams', '${match.teamA} vs ${match.teamB}'),
              SizedBox(height: 12),
              _buildSummaryRow('Score', '${match.scoreA} - ${match.scoreB}'),
              SizedBox(height: 12),
              _buildSummaryRow(
                'Date',
                '${match.matchDate.day}/${match.matchDate.month}/${match.matchDate.year}',
              ),
              SizedBox(height: 12),
              _buildSummaryRow(
                'Winner',
                match.scoreA > match.scoreB
                    ? match.teamA
                    : match.scoreB > match.scoreA
                        ? match.teamB
                        : 'Draw',
              ),
              SizedBox(height: 12),
              _buildSummaryRow('Total Goals', '${match.scoreA + match.scoreB}'),
              if (match.notes != null && match.notes!.isNotEmpty) ...[
                SizedBox(height: 12),
                Divider(color: _textSecondary.withOpacity(0.2)),
                SizedBox(height: 12),
                Text(
                  'Notes:',
                  style: TextStyle(
                    color: _primaryGold,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  match.notes!,
                  style: TextStyle(
                    color: _textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(color: _primaryGold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApiDataRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: _textSecondary,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: _textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: _textSecondary,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: _textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 400;
    final padding = isSmall ? 20.0 : 28.0;

    return SafeArea(
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        scrollBehavior: ScrollConfiguration.of(context).copyWith(
          scrollbars: false,
          overscroll: true,
        ),
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [_primaryGold, _accentAmber],
                ).createShader(bounds),
                child: Text(
                  'MATCH ANALYSIS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(padding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildMatchSummaryCard(context),
                SizedBox(height: 28),
                _buildSectionHeader('Top Events', context),
                SizedBox(height: 20),
                ...List.generate(4, (i) => Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: _buildEventCard(context, i),
                    )),
                SizedBox(height: 28),
                Consumer<MatchProvider>(
                  builder: (context, provider, child) {
                    final match = _selectedMatch ?? (provider.matches.isNotEmpty ? provider.matches.first : null);
                    return _buildAdvancedChartsButton(context, match, provider.matches);
                  },
                ),
                SizedBox(height: 28),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchSummaryCard(BuildContext context) {
    return Consumer<MatchProvider>(
      builder: (context, provider, child) {
        final match = _selectedMatch ?? (provider.matches.isNotEmpty ? provider.matches.first : null);
        
        if (match == null) {
          return ModernCard(
            padding: EdgeInsets.all(28),
            child: Center(
              child: Text(
                'No matches available',
                style: TextStyle(color: _textSecondary),
              ),
            ),
          );
        }

        return ModernCard(
          padding: EdgeInsets.all(28),
          onTap: () => _showMatchSummaryDialog(context, match),
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_primaryGold, _accentAmber],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: _primaryGold.withOpacity(0.5),
                      blurRadius: 14,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(Icons.insights_rounded,
                    color: _darkBackground, size: 28),
              ),
              SizedBox(width: 16),
              Text(
                'Match Summary',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          SizedBox(height: 28),
          if (match.possessionA != null && match.possessionB != null)
            _buildStatRow('Possession', '${match.teamA} ${match.possessionA}%', '${match.teamB} ${match.possessionB}%', match.possessionA!),
          if (match.possessionA == null)
            _buildStatRow('Possession', '${match.teamA} 54%', '${match.teamB} 46%', 54),
          SizedBox(height: 20),
          if (match.shotsA != null && match.shotsB != null)
            _buildStatRow('Shots', '${match.teamA} ${match.shotsA}', '${match.teamB} ${match.shotsB}', 
              match.shotsA! > match.shotsB! ? 60 : 40),
          if (match.shotsA == null)
            _buildStatRow('Shots', '${match.teamA} 12', '${match.teamB} 8', 60),
          SizedBox(height: 20),
          if (match.shotsOnTargetA != null && match.shotsOnTargetB != null)
            _buildStatRow('Shots on Target', '${match.teamA} ${match.shotsOnTargetA}', '${match.teamB} ${match.shotsOnTargetB}', 
              match.shotsOnTargetA! > match.shotsOnTargetB! ? 60 : 40),
          SizedBox(height: 20),
          if (match.passAccuracyA != null && match.passAccuracyB != null)
            _buildStatRow('Pass Accuracy', '${match.teamA} ${match.passAccuracyA}%', '${match.teamB} ${match.passAccuracyB}%', 
              match.passAccuracyA! > match.passAccuracyB! ? 55 : 45),
          if (match.passAccuracyA == null)
            _buildStatRow('Pass Accuracy', '${match.teamA} 78%', '${match.teamB} 82%', 48),
          if (match.passesA != null && match.passesB != null) ...[
            SizedBox(height: 20),
            _buildStatRow('Total Passes', '${match.teamA} ${match.passesA}', '${match.teamB} ${match.passesB}', 
              match.passesA! > match.passesB! ? 55 : 45),
          ],
          if (match.foulsA != null && match.foulsB != null) ...[
            SizedBox(height: 20),
            _buildStatRow('Fouls', '${match.teamA} ${match.foulsA}', '${match.teamB} ${match.foulsB}', 
              match.foulsA! < match.foulsB! ? 55 : 45),
          ],
          if (match.cornersA != null && match.cornersB != null) ...[
            SizedBox(height: 20),
            _buildStatRow('Corners', '${match.teamA} ${match.cornersA}', '${match.teamB} ${match.cornersB}', 
              match.cornersA! > match.cornersB! ? 60 : 40),
          ],
        ],
          ),
        );
      },
    );
  }

  Widget _buildStatRow(String label, String teamA, String teamB, int percentage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: _textSecondary,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
            Row(
              children: [
                Text(
                  teamA,
                  style: TextStyle(
                    color: _textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 12),
                Text('•', style: TextStyle(color: _textSecondary)),
                SizedBox(width: 12),
                Text(
                  teamB,
                  style: TextStyle(
                    color: _textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 12),
        Container(
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: _cardDark,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                _primaryGold,
              ),
              minHeight: 8,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, BuildContext context) {
    return Row(
      children: [
        Container(
          width: 5,
          height: 28,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_primaryGold, _accentAmber],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(3),
            boxShadow: [
              BoxShadow(
                color: _primaryGold.withOpacity(0.6),
                blurRadius: 10,
                offset: Offset(0, 0),
              ),
            ],
          ),
        ),
        SizedBox(width: 16),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }

  Widget _buildEventCard(BuildContext context, int index) {
    return ModernCard(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_primaryGold, _accentAmber],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: _primaryGold.withOpacity(0.5),
                  blurRadius: 14,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.sports_soccer_rounded,
              color: _darkBackground,
              size: 28,
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Event ${index + 1}: Shot on target',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.access_time_rounded,
                        size: 16, color: _textSecondary),
                    SizedBox(width: 6),
                    Text(
                      'Minute: ${10 * (index + 1)}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedChartsButton(BuildContext context, Match? match, List<Match> allMatches) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_primaryGold, _accentAmber],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _primaryGold.withOpacity(0.5),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
          BoxShadow(
            color: _primaryGold.withOpacity(0.3),
            blurRadius: 40,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChartsPage(
                  match: match,
                  allMatches: allMatches,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 28),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bar_chart_rounded, color: _darkBackground, size: 28),
                SizedBox(width: 16),
                Text(
                  'Open Advanced Charts',
                  style: TextStyle(
                    color: _darkBackground,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ----------------- Live Stats Page -----------------
class LiveStatsPage extends StatefulWidget {
  @override
  _LiveStatsPageState createState() => _LiveStatsPageState();
}

class _LiveStatsPageState extends State<LiveStatsPage>
    with SingleTickerProviderStateMixin {
  int minute = 0;
  int shotsA = 0;
  int shotsB = 0;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _simulateTick() {
    setState(() {
      minute += 1;
      shotsA += (minute % 3 == 0) ? 1 : 0;
      shotsB += (minute % 4 == 0) ? 1 : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 400;
    final padding = isSmall ? 20.0 : 28.0;

    int scoreA = (minute >= 23) ? 1 : 0;
    int scoreB = (minute >= 67) ? 1 : 0;

    return SafeArea(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1.0 + 0.05 * (0.5 + 0.5 * (1 - _pulseController.value)),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _primaryGold.withOpacity(0.35),
                          _accentAmber.withOpacity(0.25),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: _primaryGold,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _primaryGold.withOpacity(0.5),
                          blurRadius: 24,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: _primaryGold,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: _primaryGold,
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'LIVE',
                          style: TextStyle(
                            color: _primaryGold,
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                scrollbars: false,
                overscroll: true,
              ),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(padding),
                child: Column(
                  children: [
                    _buildLiveScoreboard(context, scoreA, scoreB),
                    SizedBox(height: 28),
                    _buildSimulateButton(context),
                    SizedBox(height: 28),
                    _buildSectionHeader('Event Stream', context),
                    SizedBox(height: 20),
                    _buildEventStream(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveScoreboard(BuildContext context, int scoreA, int scoreB) {
    return ModernCard(
      padding: EdgeInsets.all(32),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTeamCard('Team A', shotsA, true),
              _buildScoreCard(scoreA, scoreB, minute),
              _buildTeamCard('Team B', shotsB, false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTeamCard(String team, int shots, bool isLeft) {
    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _primaryGold.withOpacity(0.45),
                _accentAmber.withOpacity(0.25),
              ],
            ),
            shape: BoxShape.circle,
            border: Border.all(
              color: _primaryGold.withOpacity(0.7),
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: _primaryGold.withOpacity(0.4),
                blurRadius: 24,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: Text(
              shots.toString(),
              style: TextStyle(
                color: _primaryGold,
                fontSize: 36,
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        Text(
          team,
          style: TextStyle(
            color: _textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Shots: $shots',
          style: TextStyle(
            color: _textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildScoreCard(int scoreA, int scoreB, int minute) {
    return Column(
      children: [
        Text(
          'SCORE',
          style: TextStyle(
            color: _textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.0,
          ),
        ),
        SizedBox(height: 12),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_primaryGold, _accentAmber],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: _primaryGold.withOpacity(0.6),
                    blurRadius: 18,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Text(
                '$scoreA',
                style: TextStyle(
                  color: _darkBackground,
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '-',
                style: TextStyle(
                  color: _textPrimary,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_primaryGold, _accentAmber],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: _primaryGold.withOpacity(0.6),
                    blurRadius: 18,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Text(
                '$scoreB',
                style: TextStyle(
                  color: _darkBackground,
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _cardDark,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _primaryGold.withOpacity(0.4),
              width: 1,
            ),
          ),
          child: Text(
            '$minute\'',
            style: TextStyle(
              color: _primaryGold,
              fontSize: 16,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSimulateButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_primaryGold, _accentAmber],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _primaryGold.withOpacity(0.5),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
          BoxShadow(
            color: _primaryGold.withOpacity(0.3),
            blurRadius: 40,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _simulateTick,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 28),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.timer_rounded, color: _darkBackground, size: 28),
                SizedBox(width: 16),
                Text(
                  'Simulate +1 min',
                  style: TextStyle(
                    color: _darkBackground,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, BuildContext context) {
    return Row(
      children: [
        Container(
          width: 5,
          height: 28,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_primaryGold, _accentAmber],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(3),
            boxShadow: [
              BoxShadow(
                color: _primaryGold.withOpacity(0.6),
                blurRadius: 10,
                offset: Offset(0, 0),
              ),
            ],
          ),
        ),
        SizedBox(width: 16),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }

  Widget _buildEventStream(BuildContext context) {
    return Column(
      children: [
        _buildEventItem('Kick-off', '0\'', Icons.sports_soccer_rounded),
        if (minute >= 23)
          _buildEventItem('Goal by Team A', '23\'', Icons.celebration_rounded),
      ],
    );
  }

  Widget _buildEventItem(String title, String time, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: ModernCard(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_primaryGold, _accentAmber],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: _primaryGold.withOpacity(0.5),
                    blurRadius: 14,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: _darkBackground, size: 28),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: _textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _primaryGold.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _primaryGold.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Text(
                time,
                style: TextStyle(
                  color: _primaryGold,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------- Profile Page -----------------
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _profileImagePath;

  Future<void> _pickImage() async {
    try {
      final imagePicker = ImagePicker();
      final pickedFile = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _profileImagePath = kIsWeb ? pickedFile.path : pickedFile.path;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: _darkBackground),
                SizedBox(width: 12),
                Text('Profile photo updated!'),
              ],
            ),
            backgroundColor: _primaryGold,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: _textPrimary),
              SizedBox(width: 12),
              Text('Failed to pick image: $e'),
            ],
          ),
          backgroundColor: Colors.red[700],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  Future<void> _takePhoto() async {
    try {
      final imagePicker = ImagePicker();
      final pickedFile = await imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _profileImagePath = kIsWeb ? pickedFile.path : pickedFile.path;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: _darkBackground),
                SizedBox(width: 12),
                Text('Profile photo updated!'),
              ],
            ),
            backgroundColor: _primaryGold,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: _textPrimary),
              SizedBox(width: 12),
              Text('Failed to take photo: $e'),
            ],
          ),
          backgroundColor: Colors.red[700],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  Future<void> _showImageSourceDialog() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: _cardDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Image Source',
              style: TextStyle(
                color: _textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImageSourceOption(
                  icon: Icons.camera_alt_rounded,
                  label: 'Camera',
                  onTap: () {
                    Navigator.pop(context);
                    _takePhoto();
                  },
                ),
                _buildImageSourceOption(
                  icon: Icons.photo_library_rounded,
                  label: 'Gallery',
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage();
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _primaryGold.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: _primaryGold, size: 40),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: _textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 400;
    final padding = isSmall ? 20.0 : 28.0;

    return SafeArea(
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        scrollBehavior: ScrollConfiguration.of(context).copyWith(
          scrollbars: false,
          overscroll: true,
        ),
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [_primaryGold, _accentAmber],
                ).createShader(bounds),
                child: Text(
                  'PROFILE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(padding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildProfileHeader(context),
                SizedBox(height: 36),
                _buildStatCards(context),
                SizedBox(height: 36),
                _buildMenuSection(context),
                SizedBox(height: 20),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _showImageSourceDialog,
          child: Stack(
            children: [
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [_primaryGold, _accentAmber],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _primaryGold.withOpacity(0.6),
                      blurRadius: 35,
                      offset: Offset(0, 10),
                    ),
                    BoxShadow(
                      color: _primaryGold.withOpacity(0.4),
                      blurRadius: 70,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: _profileImagePath != null
                    ? ClipOval(
                        child: kIsWeb
                            ? Image.network(
                                _profileImagePath!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Icon(
                                      Icons.person_rounded,
                                      size: 70,
                                      color: _darkBackground,
                                    ),
                                  );
                                },
                              )
                            : Image.file(
                                File(_profileImagePath!),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Icon(
                                      Icons.person_rounded,
                                      size: 70,
                                      color: _darkBackground,
                                    ),
                                  );
                                },
                              ),
                      )
                    : Center(
                        child: Icon(
                          Icons.person_rounded,
                          size: 70,
                          color: _darkBackground,
                        ),
                      ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [_primaryGold, _accentAmber],
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _darkBackground,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _primaryGold.withOpacity(0.5),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    color: _darkBackground,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Tap to change photo',
          style: TextStyle(
            color: _textSecondary,
            fontSize: 12,
            fontStyle: FontStyle.italic,
          ),
        ),
        SizedBox(height: 24),
        Text(
          'Analyst',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: _primaryGold.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _primaryGold.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Text(
            'GoalSight User',
            style: TextStyle(
              color: _primaryGold,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCards(BuildContext context) {
    return Consumer<MatchProvider>(
      builder: (context, matchProvider, child) {
        final matchCount = matchProvider.matches.length;
        return Row(
          children: [
            Expanded(
              child: _buildStatCard('Matches', matchCount.toString(), Icons.sports_soccer_rounded),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildStatCard('Analysis', matchCount.toString(), Icons.analytics_rounded),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildStatCard('Live', '0', Icons.live_tv_rounded),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return ModernCard(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_primaryGold, _accentAmber],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: _primaryGold.withOpacity(0.5),
                  blurRadius: 14,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: _darkBackground, size: 28),
          ),
          SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              color: _textPrimary,
              fontSize: 32,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
            ),
          ),
          SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: _textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Column(
      children: [
        _buildMenuItem(
          context,
          icon: Icons.settings_rounded,
          title: 'Settings',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingsPage(),
              ),
            );
          },
        ),
        SizedBox(height: 16),
        _buildMenuItem(
          context,
          icon: Icons.history_rounded,
          title: 'Match History',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MatchHistoryPage(),
              ),
            );
          },
        ),
        SizedBox(height: 16),
        _buildMenuItem(
          context,
          icon: Icons.info_rounded,
          title: 'About',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AboutPage(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ModernCard(
      padding: EdgeInsets.all(24),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_primaryGold, _accentAmber],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: _primaryGold.withOpacity(0.5),
                      blurRadius: 14,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(icon, color: _darkBackground, size: 28),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  color: _textSecondary, size: 28),
            ],
          ),
        ),
      ),
    );
  }
}

