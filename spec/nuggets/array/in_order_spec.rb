require 'nuggets/array/in_order'

describe Array, 'in_order' do

  let(:a) { [:created_at, :email, :login, :updated_at] }

  example { a.in_order(:login, :email).should == [:login, :email, :created_at, :updated_at] }

  example { a.in_order(:email, :address).should == [:email, :created_at, :login, :updated_at] }

  example { a.in_order!(:login, :email); a.should == [:login, :email, :created_at, :updated_at] }

end
