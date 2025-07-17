# Leetspeak Converter

A simple Python module to convert text to leetspeak and back.

## What is Leetspeak?

Leetspeak (or "1337speak") is a type of internet slang where standard letters are replaced with numbers or special characters. For example:
- 'a' becomes '4'
- 'e' becomes '3'
- 'i' becomes '1'
- 'o' becomes '0'
- 't' becomes '7'
- 's' becomes '5'
- 'l' becomes '1'

## Features

- Convert normal text to leetspeak
- Convert leetspeak back to normal text
- Handles ambiguous characters by remembering the original text

## Usage

### Basic Usage

```python
from leetspeak import text_to_leetspeak, leetspeak_to_text

# Convert text to leetspeak
leetspeak = text_to_leetspeak("who are you")
print(leetspeak)  # Output: "wh0 4r3 y0u"

# Convert leetspeak back to normal text
normal_text = leetspeak_to_text(leetspeak)
print(normal_text)  # Output: "who are you"
```

### Running the Demo

```bash
python main.py
```

This will demonstrate the conversion of "who are you" to leetspeak and back.

### Running the Tests

```bash
python test_leetspeak.py
```

## Implementation Details

The module uses a dictionary to map between normal characters and their leetspeak equivalents. For the reverse conversion, it uses a combination of:

1. A mapping of previously converted texts (to handle ambiguous characters)
2. A best-effort conversion for texts not in the mapping

## License

This project is open source and available under the MIT License.