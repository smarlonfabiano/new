"""
Demonstration of the leetspeak converter.
"""

from leetspeak import text_to_leetspeak

# Example texts to convert
examples = [
    "hello world",
    "Hello World",
    "abegiostzABEGIOSTZ",
    "This is a test of the leetspeak converter",
    "123!@#",
    ""
]

# Convert each example and print the result
print("Leetspeak Converter Demonstration")
print("================================")
for text in examples:
    leet_text = text_to_leetspeak(text)
    print(f"Original: {text}")
    print(f"Leetspeak: {leet_text}")
    print("--------------------------------")