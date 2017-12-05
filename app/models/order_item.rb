class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, :presence => true
  validates :quantity, :inclusion => { :in => 1..1000 }

  def switcheroo

  end

end
