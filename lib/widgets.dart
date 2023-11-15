import 'package:animate_do/animate_do.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ai_interact/constant.dart';
import 'package:ai_interact/theme_provider.dart';

class AIProfile extends StatelessWidget {
  const AIProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (Provider.of<ThemeProvider>(context).themeData == darkMode)
          Container(
            height: 120.0,
            width: 120.0,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle),
          ),
        Container(
          height: 150.0,
          width: 150.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                image: AssetImage(
                    (Provider.of<ThemeProvider>(context).themeData == lightMode)
                        ? "assets/images/tonystark.png"
                        : "assets/images/tylerdurden.png")),
          ),
        ),
      ],
    );
  }
}

class InitialAIDialogBox extends StatelessWidget {
  const InitialAIDialogBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: kwidth! * 0.8,
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          border: Border.all(
              color: Theme.of(context).colorScheme.primary, width: 2),
          borderRadius:
              BorderRadius.circular(10.0).copyWith(topLeft: Radius.zero)),
      child: Center(
        //child:Text("Hi Mate,What is the task to do now?"),
        child: AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              "Hi Mate,What is the task to do now?",
              textStyle: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
              speed: const Duration(milliseconds: 50),
            ),
          ],
          totalRepeatCount: 1,
          pause: const Duration(milliseconds: 80),
          displayFullTextOnTap: true,
          stopPauseOnTap: false,
        ),
      ),
    );
  }
}

class FeaturesList extends StatelessWidget {
  final String? generatedContent;
  final String? generatedImageUrl;
  const FeaturesList(
      {super.key,
      required this.generatedContent,
      required this.generatedImageUrl});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: generatedContent == null && generatedImageUrl == null,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(
                    left: kwidth! * 0.06, top: 15.0, bottom: 15.0),
                child: const Text(
                  "Here are a few features",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: FeatureBox(
                boxColor:
                    (Provider.of<ThemeProvider>(context).themeData == lightMode)
                        ? kLFeature1Color
                        : kDFeature1Color,
                boxTitle: "ChatGPT",
                boxDesc:
                    "A smarter way to stay organized and informed with ChatGPT"),
          ),
          FadeInUp(
            delay: const Duration(milliseconds: 400),
            child: FeatureBox(
                boxColor:
                    (Provider.of<ThemeProvider>(context).themeData == lightMode)
                        ? kLFeature2Color
                        : kDFeature2Color,
                boxTitle: "Dall-E",
                boxDesc:
                    "Get Inspired and stay creative with your personal assistant powered by Dall-E"),
          ),
          FadeInUp(
            delay: const Duration(milliseconds: 600),
            child: FeatureBox(
                boxColor:
                    (Provider.of<ThemeProvider>(context).themeData == lightMode)
                        ? kLFeature3Color
                        : kDFeature3Color,
                boxTitle: "Smart Voice Assistant",
                boxDesc:
                    "Get a best of both worlds with a voice assistant powered by Dall-E and ChatGPT"),
          ),
        ],
      ),
    );
  }
}

class FeatureBox extends StatelessWidget {
  final Color boxColor;
  final String boxTitle;
  final String boxDesc;
  const FeatureBox(
      {super.key,
      required this.boxColor,
      required this.boxTitle,
      required this.boxDesc});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: kwidth! * 0.9,
      margin: const EdgeInsets.only(bottom: 15.0),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
      decoration: BoxDecoration(
          color: boxColor, borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            boxTitle,
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          Text(boxDesc, style: const TextStyle(fontSize: 15.0))
        ],
      ),
    );
  }
}
