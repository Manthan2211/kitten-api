class Kitten < ApplicationRecord
  belongs_to :user

  mount_uploader :image, ImageUploader

  validates :name, presence: true
  validates :age, presence: true, numericality: { only_integer: true }
  validates_inclusion_of :age, :in => 1..99
  validates :cuteness, presence: true, numericality: { only_integer: true }
  validates_inclusion_of :cuteness, :in => 0..11
  validates :softness, presence: true, numericality: { only_integer: true }
  validates_inclusion_of :softness, :in => 0..11
  validates :image, presence: true
end
