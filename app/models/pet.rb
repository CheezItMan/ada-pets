class Pet < ActiveRecord::Base
  validates :name, presence: true
  validates :age, presence: true
  validates :human, presence: true
end
