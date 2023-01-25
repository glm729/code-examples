#!/usr/bin/ruby

# Prints a body of text at the specified length.  Written when writing an
# example for a literature review that involved printing a large piece of
# unstructured text (a veterinarian's examination summary notes), which runs
# off the page of an R Markdown document.  Thought I'd try Ruby for a change.

# - Default length is 80.
# - Haven't yet incorporated checks for correct datatypes.
# - I know a bit more about Ruby but I'm still pretty much a novice, so
#   comments and tips are most welcome.

def printlength(text, len = 80)
  t = text.to_s.split
  lines = ['']
  i = 0
  t.each do |word|
    if word.length + lines[i].length > len.to_i
      i += 1
      lines[i] = ''
    end
    lines[i].concat("#{word} ")
  end
  lines.map{|l| l.strip!}
  return "#{lines.join("\n")}\n"
end
