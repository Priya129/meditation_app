import 'package:flutter/material.dart';
import 'package:meditation/signin_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();

}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<Map<String, String>> onboardingData = [

    {
      "title": "Express your day with gratitude",
      "subtitle": "Explore the new app that allow you to show gratitude towards yours life.",
      "imagePath": "assets/Images/gratitude.png"
    },
    {
      "title": "Relax with Nature",
      "subtitle": "Experience calmness with nature-inspired sounds to help you relax.",
      "imagePath": "assets/Images/meditation.png"
    },
    {
      "title": "Sleep Analytics",
      "subtitle": "Track your sleep patterns and improve your sleep quality with detailed analytics.",
      "imagePath": "assets/Images/sleep.png"
    },

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF1A1A2E),
        body: Column(
          children: [
            Expanded(child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: onboardingData.length,
                itemBuilder: (context, index) =>
                    OnboardingContent(
                      title: onboardingData[index]['title']!,
                        subtitle: onboardingData[index]['subtitle']!,
                        imagePath: onboardingData[index]['imagePath']!,
                        isLastPage: index == onboardingData.length - 1,
                        onSignInPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignInPage())
                        );
                        },
                        currentPage: _currentPage,
                        totalPages: onboardingData.length,


                    )
            ))
          ],
        )
    );
  }
}
class OnboardingContent  extends StatelessWidget{
  final String title, subtitle, imagePath;
  final bool isLastPage;
  final VoidCallback onSignInPressed;
  final int currentPage;
  final int totalPages;

  const OnboardingContent({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.isLastPage,
    required this.onSignInPressed,
    required this.currentPage,
    required this.totalPages,

});
  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            height: 250,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 16,),
          Text(title,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10,),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
                totalPages,
                (index) => buildDot(index: index, currentPage: currentPage)

            )
              ,
          ),
          const SizedBox(height: 20,),
          if(isLastPage)
            Container(
              width: 200,
              height: 50,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                ),
                onPressed: onSignInPressed,
                child: const Text(
                  "Sign In",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )

        ],
      ),
    );
  }
  Widget buildDot({required int index, required int currentPage}){
    return Container(
      height: 10,
        width: currentPage == index ? 20 : 10,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: currentPage == index ? Colors.white : Colors.white54,
        borderRadius: BorderRadius.circular(5)
      ),
    );
  }
}



