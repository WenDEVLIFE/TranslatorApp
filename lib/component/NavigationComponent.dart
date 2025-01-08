import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mandtrans_app/main.dart';
import 'package:mandtrans_app/pages/text_translator_page.dart';

import '../pages/AboutUS.dart';
import '../pages/voice_translator_page.dart';

class Navigationcomponent extends StatefulWidget {
  const Navigationcomponent({super.key,});



  @override
  _NavControllerState createState() => _NavControllerState();
}

class _NavControllerState extends State<Navigationcomponent> {
  final PageController _pageController = PageController(initialPage: 0); // Set initial page to index 1
  final List<bool> _isHovering = List<bool>.filled(6, false);
  late String email;

  late String id; // Initialize id
  int _currentIndex = 0; // Initialize to index 1

  @override
  void initState() {
    super.initState();
    // Automatically select index 1 on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _pageController.jumpToPage(0);
      });
    });
  }
  List<Widget> _getNavBarItems() {
    List<Widget> items = [
        _buildNavItem(0, Icons.text_fields),
        _buildNavItem(1, Icons.mic),
        _buildNavItem(2, Icons.info),
      ];

    return items;
  }

  List<Widget> _getPageViewChildren() {
    List<Widget> pages = [
      const TextTranslatorPage(),
      const VoiceTranslatorPage(),
      const AboutPage(),
    ];


    return pages;
  }



  Widget _buildNavItem(int index, IconData icon) {
    return InkWell(
      onHover: (hovering) {
        setState(() {
          _isHovering[index] = hovering;
        });
      },
      child: Icon(
        icon,
        color: _isHovering[index] ? Colors.grey : Colors.white,
        size: 30,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index; // Track current index
          });
        },
        children: _getPageViewChildren(),
      ),
      bottomNavigationBar: Stack(
        children: [
          CurvedNavigationBar(
            backgroundColor: const Color.fromARGB(255, 245, 245, 245),
            color: const Color.fromARGB(255, 66, 66, 66),
            items: _getNavBarItems(),
            index: _currentIndex,
            // Set the initial index
            onTap: (index) {
              setState(() {
                _currentIndex = index; // Update current index on tap
                _pageController.jumpToPage(index); // Navigate to the selected page
              });
            },
          ),
        ],
      ),
    );
  }
}

class CustomPageView extends StatelessWidget {
  final PageController controller;
  final ValueChanged<int> onPageChanged;
  final List<Widget> children;

  const CustomPageView({
    required this.controller,
    required this.onPageChanged,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller,
      onPageChanged: onPageChanged,
      itemCount: children.length,
      itemBuilder: (context, index) {
        return children[index];
      },
      physics: const NeverScrollableScrollPhysics(), // Disable swipe gesture
    );
  }
}