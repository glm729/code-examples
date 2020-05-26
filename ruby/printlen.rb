#!/usr/bin/ruby

# ==============================================================================
# Prints a body of text at the specified length. Written when writing an example
# for a literature review that involved printing a large piece of unstructured
# text (a veterinarian's examination summary notes), which runs off the page of
# an R Markdown document. Thought I'd try Ruby for a change.
# ==============================================================================
# - Default length is 80.
# - Haven't yet incorporated checks for correct datatypes.
# - I do not know anything about Ruby! Constructive comments are most welcome.
# ==============================================================================

def printlen(text,len)
  t = text.to_s.split
  lines = [""]
  i = 0
  t.each do |word|
    if word.length + lines[i].length > len.to_i
      i += 1
      lines[i] = ""
    end
    lines[i].concat("#{word} ")
  end
  (0..lines.length).each do |j|
    if lines[j].class!=NilClass
      lines[j] = lines[j].strip
    end
  end
  print(lines.join("\n").concat("\n"))
  return
end
