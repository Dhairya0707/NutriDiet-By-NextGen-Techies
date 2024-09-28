import 'package:diet/login/login.dart';
import 'package:diet/login/signin.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF7F53AC), Color(0xFF647DEE)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),

          // Page content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App name
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Text(
                  'Nutrition Planner',
                  style: GoogleFonts.montserrat(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              // Tagline
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Your personalized diet and health tracker',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Carousel of features
              CarouselSlider(
                options: CarouselOptions(
                  height: 300.0,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                ),
                items: const [
                  FeatureCard(
                    title: "Track Your Meals",
                    description:
                        "Log your meals and monitor your calorie and nutrient intake.",
                    icon: Icons.restaurant,
                  ),
                  FeatureCard(
                    title: "Set Your Goals",
                    description:
                        "Define your weight, calorie, and nutrient goals easily.",
                    icon: Icons.flag,
                  ),
                  FeatureCard(
                    title: "Personalized Tips",
                    description: "Get AI-driven tips and meal recommendations",
                    icon: Icons.lightbulb,
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Call-to-action buttons (Login/Sign Up)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to login
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color(0xFF647DEE),
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF647DEE),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to sign-up
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.transparent,
                      side: const BorderSide(color: Colors.white),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                    child: Text(
                      'Sign Up',
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const FeatureCard(
      {super.key,
      required this.title,
      required this.description,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            spreadRadius: 5.0,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 80,
            color: const Color(0xFF647DEE),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF647DEE),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
