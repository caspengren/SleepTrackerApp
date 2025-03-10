import 'package:flutter_survey/flutter_survey.dart';

final List<Question> behaviorQuiz = [
  Question(
      singleChoice: true,
      isMandatory: true,
      question: "How much caffeine have you had today?",
      answerChoices: {
        "No caffeine": null, // 10
        "1-100 mg": null, // 8
        "101-200 mg": null, // 6
        "201-300 mg": null, // 5
        "301-400 mg": null, // 4
        "401-500 mg": null, // 2
        "501+ mg": null, // 0
      }
  ),
  Question(
      singleChoice: true,
      isMandatory: true,
      question: "How many alcoholic drinks have you had today?",
      answerChoices: {
        "No alcoholic drinks": null, // 10
        "1-2 drinks": null, // 8
        "3-4 drinks": null, // 5
        "4-5 drinks": null, // 3
        "6+ drinks": null, // 0
      }
  ),
  Question(
      singleChoice: true,
      isMandatory: true,
      question: "How much screen time did you have today?",
      answerChoices: {
        "No screen time": null, // 10
        "Less than 1 hour": null, // 9
        "1-2 hours": null, // 8
        "2-3 hours": null, // 7
        "4-5 hours": null, // 6
        "6+ hours": null, // 4
      }
  ),
  Question(
      singleChoice: true,
      isMandatory: true,
      question: "How many meals did you have today?",
      answerChoices: {
        "No meals": null, // 0
        "1 meal": null, // 5
        "2 meals": null, // 9
        "3 meals": null, // 10
      }
  ),
  Question(
      singleChoice: true,
      isMandatory: true,
      question: "How much water did you drink today?",
      answerChoices: {
        "No plain water": null, // 0
        "<1000 mL": null, // 2
        "1001-2000 mL": null, // 4
        "2001-3000 mL": null, // 8
        "3001-4000 mL": null, // 10
        "4001+ mL": null, // 10
      }
  ),
  Question(
      singleChoice: true,
      isMandatory: true,
      question: "Did you take a nap today?",
      answerChoices: {
        "Yes": null, // 0 hehe
        "No": null, // 0
      }
  )
];

//Caffeine, screen time, food, water, nap,