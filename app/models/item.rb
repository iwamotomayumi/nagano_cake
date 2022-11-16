class Item < ApplicationRecord

  has_one_attached :image

  belongs_to :genre
  has_many :cart_items, dependent: :destroy
  has_many :order_details, dependent: :destroy

  validates :image, presence: true
  validates :name, presence: true
  validates :introduction, presence: true
  validates :price, presence: true
  validates :is_active, presence: true


  def add_tax_price
        (self.price * 1.10).round
  end

  ## 消費税を求めるメソッド
def with_tax_price
    (price * 1.1).floor
end

end
