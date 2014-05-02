# encoding: utf-8

require 'nuggets/string/wc'

describe_extended String, Nuggets::String::WcMixin do

  describe 'empty' do

    before do
      @str = ''
    end

    example { @str.wc.should == [0, 0, 0] }

    example { @str.line_count.should == 0 }

    example { @str.word_count.should == 0 }

    example { @str.byte_count.should == 0 }

    example { @str.char_count.should == 0 }

  end

  describe 'non-empty' do

    before do
      @str = <<-STR
The fox went out on a chilly night / Prayed for the moon to give him light / For he had many a mile to go that night / Before he reached the town o
He ran til he came to a great big bin / Where the ducks and the geese were kept therein / Said, a couple of you are going to grease my chin / Before I leave this town o
He grabbed the grey goose by the neck / Throwed a duck across his back / He didn't mind the quack, quack, quack / And the legs all dangling down o
Then old mother Flipper-flopper jumped out of bed / Out of the window she cocked her head / Crying, John, John the grey goose is gone / and the fox is on the town o
Then John he went to the top of the hill / Blew his horn both loud and shrill / The fox, he said, I better flee with my kill / Or they'll soon be on my trail o
He ran till he came to his cozy den / There were the little ones, eight, nine, ten / Saying, Daddy, daddy, Better go back again / For it must be a mighty fine town o
Then the fox and his wife, without any strife / Cut up the goose with a carving knife / They never had such a supper in their life / And the little ones chewed on the bones o
      STR
    end

    example { @str.wc.should == [7, 252, 1130] }

    example { @str.line_count.should == 7 }

    example { @str.word_count.should == 252 }

    example { @str.byte_count.should == 1130 }

    example { @str.char_count.should == 1130 }

  end

  describe 'special' do

    before do
      @str = <<-STR
TECHNICIÄNS ÖF SPÅCE SHIP EÅRTH
THIS IS YÖÜR CÄPTÅIN SPEÄKING
YÖÜR ØÅPTÅIN IS DEA̋D
      STR
    end

    example { @str.wc.should == [3, 14, 99] }

    example { @str.line_count.should == 3 }

    example { @str.word_count.should == 14 }

    example { @str.byte_count.should == 99 }

    example { @str.char_count.should == 84 }

  end

end
