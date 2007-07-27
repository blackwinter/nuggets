class String

  # call-seq:
  #   str.word_wrap(line_width) => new_str
  #
  # Word wrap a string not exceeding max width. Based on the Ruby Facets
  # implementation, but preserves paragraphs. Thus (save trailing newline)
  # <tt>str == str.word_wrap(str.split("\n").map { |l| l.length }.max)</tt>.
  def word_wrap(line_width = 80)
    dup.word_wrap!(line_width)
  end

  # call-seq:
  #   str.word_wrap!(line_width) => str
  #
  # As with #word_wrap, but modifies the string in place.
  def word_wrap!(line_width = 80)
    gsub!(/\n/, "\n\n")
    gsub!(/(.{1,#{line_width}})(?:[ \t]+|$)/, "\\1\n")
    gsub!(/\n\n/, "\n")
    gsub!(/\n\n/, "\n")
    self
  end

end

if $0 == __FILE__
  s = <<EOT
Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Nullam nulla arcu,
ullamcorper non, vulputate eget, elementum quis, sapien. Quisque consequat
porta enim. Phasellus porta libero et turpis. Ut felis.

Phasellus eget est a enim rutrum accumsan. Integer nec purus. Maecenas
facilisis urna sed arcu. Suspendisse potenti. Vestibulum lacus metus, faucibus
sit amet, mattis non, mollis sed, pede. Aenean vitae sem nec sem euismod
sollicitudin. Cras rhoncus.

Phasellus condimentum, ante a cursus dictum, lectus ipsum convallis magna, sed
tincidunt massa eros vitae ante. Suspendisse nec sem.
In hac habitasse platea dictumst. Fusce purus leo, ullamcorper sit amet, luctus
in, mollis mollis, enim. In adipiscing erat.
EOT
  puts s

  puts '=' * 80

  puts s.word_wrap(60)
  puts '=' * 80
  puts s.word_wrap(79)

  puts '=' * 80

  s.word_wrap!(60)
  puts s
end
