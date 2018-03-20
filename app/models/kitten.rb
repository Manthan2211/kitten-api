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
  validates :age_limits
  validates :cuteness_limits
  validates :softness_limits

  private

  def age_limits
    if age > 99
      errors.add(:age,"age must be less than 99 ")
    elsif age < 0
      errors.add(:age,"Age Cant be negative")
    end
  end

  def cuteness_limits
    if cuteness > 11
      errors.add(:age,"age must be less than 99 ")
    elsif cuteness < 0
      errors.add(:age,"Age Cant be negative")
    end
  end

  def softness_limits
    if softness > 11
      errors.add(:age,"age must be less than 99 ")
    elsif softness < 0
      errors.add(:age,"Age Cant be negative")
    end
  end
end
