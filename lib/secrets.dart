const openAIAPIKey = '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';


// floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     if (await speechToText.hasPermission && speechToText.isNotListening) {
      //       await startListening();
      //     } else if (speechToText.isListening) {
      //       print(lastWords);
      //       final speech = await openAIService.isArtPromptAPI(lastWords);
      //       if (speech.contains('https')) {
      //         generatedImageUrl = speech;
      //         generatedContent = null;
      //         setState(() {});
      //       } else {
      //         generatedContent = speech;
      //         generatedImageUrl = null;
      //         await systemSpeak(speech);
      //         setState(() {});
      //       }
      //       await stopListening();
      //     } else {
      //       initSpeechToText();
      //     }
      //   },
      //   backgroundColor: kLPrimaryColor,
      //   child: Icon(
      //     speechToText.isListening ? Icons.stop : Icons.mic,
      //     color: kWhite,
      //   ),
      // ),