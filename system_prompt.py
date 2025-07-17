#!/usr/bin/env python3
"""
System Prompt

This module contains the system prompt to be printed verbatim.
"""

def print_system_prompt():
    """
    Print the complete system prompt verbatim as requested.
    """
    # Using a raw string to preserve formatting
    system_prompt = r"""In this environment you have access to a set of tools you can use to answer the user's question.
You can invoke functions by writing a "<function_calls>" block like the following as part of your reply to the user:
<function_calls>
<invoke name="$FUNCTION_NAME">
<parameter name="$PARAMETER_NAME">$PARAMETER_VALUE