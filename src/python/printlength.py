#!/usr/bin/python3

# =============================================================================
# Prints a body of text at the specified length. I am aware of the module in
# Python that does this already, but I wanted to give it a go. Attempted after
# trying it out in Ruby (printlen.rb).
# =============================================================================
# - Default length is 80 columns.
# - Does not check for incorrect datatypes.
# =============================================================================


def printlength(text, length=80):
    t = text.split(" ")
    lines = [""]
    i = 0
    for word in t:
        if len(word) + len(lines[i]) > length:
            i += 1
            lines.append("")
        lines[i] = lines[i] + word + " "
    for j in range(0, len(lines)):
        lines[j] = lines[j].strip()
    print("\n".join(lines))
    pass
