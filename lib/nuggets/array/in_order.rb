class Array

  # call-seq:
  #   array.in_order(*ordered) => new_array
  #
  # Force order, but ignore non-existing and keep remaining.
  #
  # Examples:
  #   [:created_at, :email, :login, :updated_at].in_order(:login, :email)    #=> [:login, :email, :created_at, :updated_at]
  #   [:created_at, :email, :login, :updated_at].in_order(:email, :address)  #=> [:email, :created_at, :login, :updated_at]
  def in_order(*ordered)
    ordered &= self
    ordered + (self - ordered)
  end

  # call-seq:
  #   array.in_order!(*ordered) => array
  #
  # Destructive version of #in_order.
  def in_order!(*ordered)
    replace in_order(*ordered)
  end

end

if $0 == __FILE__
  a = [:created_at, :email, :login, :updated_at]
  p a

  p a.in_order(:login, :email)
  p a.in_order(:email, :address)

  a.in_order!(:login, :email)
  p a
end
