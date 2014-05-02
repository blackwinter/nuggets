# encoding: utf-8

require 'nuggets/i18n'

describe String, 'i18n' do

  let(:s) { 'Äh, Rüby iß sö cüül, nö? SÖS!' }

  example { s.replace_diacritics.should == 'Aeh, Rueby iss soe cueuel, noe? SOES!' }

  example { s.replace_diacritics!; s.should == 'Aeh, Rueby iss soe cueuel, noe? SOES!' }

end
