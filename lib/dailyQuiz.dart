import 'package:flutter_survey/flutter_survey.dart';

final List<Question> sleepQuiz = [
  Question(
    singleChoice: true,
    isMandatory: true,
    question: "How did you sleep?",
    answerChoices: {
      "Good": null,
      "Bad": null,
    }
  ),
  Question(
    singleChoice: true,
    isMandatory: true,
    question: "Did you experience sleep interruptions?",
      answerChoices: {
        "Yes": [
          Question(
            question: "What caused these interruptions?"
          )
        ],
        "No": null,
      }
  )
];