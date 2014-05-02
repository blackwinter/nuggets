require 'nuggets/string/word_wrap'

describe String, 'word_wrap' do

  let(:s) { <<-EOT }
Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Nullam nulla arcu,
ullamcorper non, vulputate eget, elementum quis, sapien. Quisque consequat
porta enim. Phasellus porta libero et turpis. Ut felis.

Phasellus eget est a enim rutrum accumsan. Integer nec purus. Maecenas
facilisis urna sed arcu. Suspendisse potenti.


Vestibulum lacus metus, faucibus sit amet, mattis non, mollis sed, pede. Aenean
vitae sem nec sem euismod sollicitudin. Cras rhoncus.



Phasellus condimentum, ante a cursus dictum, lectus ipsum convallis magna, sed
tincidunt massa eros vitae ante. Suspendisse nec sem.
In hac habitasse platea dictumst. Fusce purus leo, ullamcorper sit amet, luctus
in, mollis mollis, enim. In adipiscing erat.
  EOT

  s60 = <<-EOT
Lorem ipsum dolor sit amet, consectetuer adipiscing elit.
Nullam nulla arcu,
ullamcorper non, vulputate eget, elementum quis, sapien.
Quisque consequat
porta enim. Phasellus porta libero et turpis. Ut felis.

Phasellus eget est a enim rutrum accumsan. Integer nec
purus. Maecenas
facilisis urna sed arcu. Suspendisse potenti.


Vestibulum lacus metus, faucibus sit amet, mattis non,
mollis sed, pede. Aenean
vitae sem nec sem euismod sollicitudin. Cras rhoncus.



Phasellus condimentum, ante a cursus dictum, lectus ipsum
convallis magna, sed
tincidunt massa eros vitae ante. Suspendisse nec sem.
In hac habitasse platea dictumst. Fusce purus leo,
ullamcorper sit amet, luctus
in, mollis mollis, enim. In adipiscing erat.
  EOT

  example {
    s.word_wrap(60).should == s60
  }

  example {
    s.word_wrap!(60); s.should == s60
  }

  example {
    s.word_wrap(79).should == <<-EOT
Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Nullam nulla arcu,
ullamcorper non, vulputate eget, elementum quis, sapien. Quisque consequat
porta enim. Phasellus porta libero et turpis. Ut felis.

Phasellus eget est a enim rutrum accumsan. Integer nec purus. Maecenas
facilisis urna sed arcu. Suspendisse potenti.


Vestibulum lacus metus, faucibus sit amet, mattis non, mollis sed, pede. Aenean
vitae sem nec sem euismod sollicitudin. Cras rhoncus.



Phasellus condimentum, ante a cursus dictum, lectus ipsum convallis magna, sed
tincidunt massa eros vitae ante. Suspendisse nec sem.
In hac habitasse platea dictumst. Fusce purus leo, ullamcorper sit amet, luctus
in, mollis mollis, enim. In adipiscing erat.
    EOT
  }

end
