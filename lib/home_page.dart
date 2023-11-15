import 'package:animate_do/animate_do.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:ai_interact/constant.dart';
import 'package:ai_interact/openai_service.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:ai_interact/theme_provider.dart';
import 'package:ai_interact/widgets.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLightMode = true;

  bool isNetworkImageLoading = false;
  bool isAPIGenerating = false;
  bool isFirstSpeaked = false;

  SpeechToText speechToText = SpeechToText();
  bool speechEnabled = false;
  String lastWords = '';

  final flutterTts = FlutterTts();

  final OpenAIService openAIService = OpenAIService();

  String? generatedContent;
  String? generatedImageUrl;
  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTexttoSpeech();
    systemSpeak("Hi Mate,What is the task to do now?");
  }

  Future<void> initTexttoSpeech() async {
    await flutterTts.setSharedInstance(true);
    await flutterTts.setPitch(0.75);
    //await flutterTts.setSpeechRate(0.6);
    // await flutterTts.setLanguage('en-US');
    // await flutterTts.setVoice('en-US-language');
    setState(() {});
  }

  Future<void> initSpeechToText() async {
    speechEnabled = await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      isFirstSpeaked = true;
      lastWords = result.recognizedWords;
    });
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      //App Bar
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        surfaceTintColor: Theme.of(context).colorScheme.primary,
        title: Text(
          (Provider.of<ThemeProvider>(context).themeData == lightMode)
              ? "Tony Stark"
              : "Tyler Durden",
          style: TextStyle(
              fontSize: 22.0, fontWeight: FontWeight.bold, color: kWhite),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: IconButton(
            icon: Icon(
              (isLightMode) ? Icons.light_mode : Icons.dark_mode,
              size: 25.0,
              color: kWhite,
            ),
            onPressed: () {
              setState(() {
                isLightMode = !isLightMode;
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme();
              });
            },
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
                onPressed: () {
                  flutterTts.pause();
                  setState(() {
                    generatedContent = null;
                    generatedImageUrl = null;
                    lastWords = '';
                    isFirstSpeaked = false;
                    OpenAIService().clearMessages();
                  });

                  systemSpeak("Hi Mate,What is the task to do now?");
                },
                icon: const Icon(
                  Icons.restart_alt,
                  color: kWhite,
                  size: 25.0,
                )),
          )
        ],
      ),
      //Floating Action Button
      floatingActionButton: AvatarGlow(
        endRadius: 50.0,
        glowColor: Theme.of(context).colorScheme.primary,
        animate: speechToText.isListening,
        child: SpeedDial(
          icon: Icons.mic,
          activeIcon: speechToText.isListening ? Icons.mic : Icons.stop,
          iconTheme: const IconThemeData(color: kWhite),
          backgroundColor: Theme.of(context).colorScheme.primary,
          renderOverlay: false,
          spaceBetweenChildren: 15.0,
          onOpen: () async {
            flutterTts.pause();
            if (await speechToText.hasPermission &&
                speechToText.isNotListening) {
              await startListening();
            } else if (speechToText.isListening) {
              stopListening();
              setState(() {
                lastWords = '';
              });
              startListening();
            } else {
              initSpeechToText();
            }
          },
          children: [
            SpeedDialChild(
                child: const Icon(
                  Icons.search,
                  color: kWhite,
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
                onTap: () async {
                  if (lastWords != " " || lastWords != "") {
                    setState(() {
                      isAPIGenerating = true;
                    });
                    final speech =
                        await openAIService.isArtPromptAPI(lastWords);
                    setState(() {
                      isAPIGenerating = false;
                    });
                    if (speech.contains('https')) {
                      generatedImageUrl = speech;
                      generatedContent = null;
                      setState(() {});
                    } else {
                      generatedContent = speech;
                      generatedImageUrl = null;
                      await systemSpeak(speech);
                      setState(() {});
                    }
                    await stopListening();
                  } else {
                    await startListening();
                  }
                })
          ],
        ),
      ),
      //Body
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          width: kwidth,
          child: Column(children: [
            const SizedBox(
              height: 10.0,
            ),
            //Assistant Profile
            ZoomIn(child: const AIProfile()),
            const SizedBox(
              height: 10.0,
            ),
            //Floating Action Button

            //Initial AI Dialog Box
            FadeInLeft(
              delay: Duration(milliseconds: 200),
              child: (generatedContent == null &&
                      generatedImageUrl == null &&
                      !isAPIGenerating)
                  ? const InitialAIDialogBox()
                  : Container(),
            ),
            //Speech to text dialog box
            if (isFirstSpeaked)
              FadeInRight(
                child: Container(
                    width: kwidth! * 0.8,
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2),
                        borderRadius: BorderRadius.circular(10.0)
                            .copyWith(topRight: Radius.zero)),
                    child: Column(children: [
                      Container(
                        height: 30.0,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(5.0))),
                        child: const Center(
                            child: Text(
                          "Prompt",
                          style: TextStyle(fontSize: 17.0, color: kWhite),
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        child: Text(
                          lastWords,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ])),
              ),
            //Loaging animation
            (isAPIGenerating)
                ? Column(
                    children: [
                      const SizedBox(
                        height: 80.0,
                      ),
                      CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.primary),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        'Generating ...',
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                    ],
                  )
                : Container(),
            //Generate Text
            if (generatedContent != null)
              FadeInLeft(
                child: Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    width: kwidth! * 0.9,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2),
                        borderRadius: BorderRadius.circular(10.0)
                            .copyWith(topLeft: Radius.zero)),
                    child: Column(children: [
                      Container(
                        height: 30.0,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(5.0))),
                        child: const Center(
                            child: Text(
                          "ChatGPT Text",
                          style: TextStyle(fontSize: 17.0, color: kWhite),
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        child: AnimatedTextKit(
                          animatedTexts: [
                            TypewriterAnimatedText(
                              generatedContent!,
                              textStyle: const TextStyle(
                                fontSize: 18.0,
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
                    ])),
              ),
            //Generated Image
            if (generatedImageUrl != null)
              SizedBox(
                width: kwidth! * 0.9,
                child: Column(
                  children: [
                    Container(
                      height: 30.0,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(10.0).copyWith(
                              bottomLeft: Radius.zero,
                              bottomRight: Radius.zero)),
                      child: const Center(
                          child: Text(
                        "DALL-E Image",
                        style: TextStyle(fontSize: 17.0, color: kWhite),
                      )),
                    ),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(10.0).copyWith(
                            topLeft: Radius.zero, topRight: Radius.zero),
                        child: Image.network(
                          generatedImageUrl!,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            double loadValue = 0;

                            if (loadingProgress != null) {
                              isNetworkImageLoading = true;
                              double imageLoadPercent = loadingProgress
                                      .cumulativeBytesLoaded
                                      .toDouble() /
                                  loadingProgress.expectedTotalBytes!
                                      .toDouble();

                              loadValue = imageLoadPercent;
                            }
                            if (loadingProgress == null) {
                              isNetworkImageLoading = false;

                              return Container(
                                child: child,
                              );
                            }
                            return Column(
                              children: [
                                Shimmer.fromColors(
                                  baseColor:
                                      const Color.fromARGB(255, 224, 224, 224),
                                  highlightColor: kWhite,
                                  child: Container(
                                    width: kwidth! * 0.9,
                                    height: kwidth! * 0.9,
                                    color: Colors.grey,
                                  ),
                                ),
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    LinearProgressIndicator(
                                      backgroundColor:
                                          (Provider.of<ThemeProvider>(context)
                                                      .themeData ==
                                                  lightMode)
                                              ? kLFeature1Color
                                              : kDFeature1Color,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Theme.of(context)
                                              .colorScheme
                                              .primary),
                                      minHeight: 15.0,
                                      value: loadValue,
                                    ),
                                    Text(
                                      "${(loadValue * 100.0).toStringAsFixed(2)} %",
                                      style: const TextStyle(
                                          fontSize: 16.0, color: kWhite),
                                    )
                                  ],
                                )
                              ],
                            );
                          },
                        )),
                  ],
                ),
              ),

            //Features
            (isAPIGenerating)
                ? Container()
                : FeaturesList(
                    generatedContent: generatedContent,
                    generatedImageUrl: generatedImageUrl)
          ]),
        ),
      ),
    );
  }
}
