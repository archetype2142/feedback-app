SYSTEM_INTEL = "You are a custom feedback collector and analyser."

PROMPT_1 = '''
You will receive a piece of text, which is feedback regarding a product. Your job is to analyze the given feedback and return a JSON object that looks as follows:
{
  "feedback": "Parse the given text input and extract the feedback points. This should be a list of strings, where each string is a feedback point.",
  "sentiment_score": "On a scale of -5 to 5, where -5 is very negative, 0 is neutral, and 5 is very positive, provide a sentiment score for the entire feedback. This entry should be an integer value.",
  "good_points": "Parse the given text input and extract the positive feedback points. This should be a list of strings, where each string is a positive feedback point."
}
While analyzing the feedback, make sure to fill the JSON object only with information extracted from the feedback. Do not rephrase or rewrite the feedback.
Once you have extracted and filled out the JSON object with the necessary information, please return only the JSON object as output.
The feedback text is: %s
'''

PROMPT_2 = '''You will be recieve a piece of text, which is a feedback regarding a product. This feedback can be positive, negative or neutral.
Your goal is to parse this feedback into a list of feedback points. This is supposed to be a list of strings, where the string objects are the feedback points.
Only return this list as output. Make sure to only include information extracted from the textual input feedback into these feedback points. Do not rephrase or rewrite the feedback.
The text is: %s
'''

RESPONSE_NEG = '''We’re sorry to hear that your experience didn’t meet expectations. Your feedback is invaluable to us. Could you share more about the specific areas where we could improve? Was there anything in particular that impacted your experience, and what would have made it more positive?'''
RESPONSE_NEU = '''Thank you for sharing your experience with us. We’re committed to continually enhancing our service, and your insights help guide us. Is there anything that would have made your experience exceptional? Any ideas or features you think would add value?'''
RESPONSE_POS = '''Thank you for your feedback! It’s wonderful to know you had a positive experience with us. We’d love to understand more about what stood out to you. Was there a specific aspect of our service that you value the most or that sets us apart from others? Your input helps us reinforce what’s working well.'''

OUTRO = '''Thank you for giving your feedback!'''
