class Kitten < ApplicationRecord
  belongs_to :user

  mount_uploader :image, ImageUploader

  acts_as_votable

  validates :name, presence: true
  validates :age, presence: true, numericality: { only_integer: true }
  #validates_inclusion_of :age, :in => 1..99
  validates :cuteness, presence: true, numericality: { only_integer: true }
  #validates_inclusion_of :cuteness, :in => 0..11
  validates :softness, presence: true, numericality: { only_integer: true }
  #validates_inclusion_of :softness, :in => 0..11
  validates :image, presence: true
  validate :age_limits
  validate :cuteness_limits
  validate :softness_limits

   def as_json(options={})
#   options hash accepts four keys for better customization :only, :methods, :include, :except
#   so whenever such keys are found, we call super with those keys to provide response consisting only those keys  
    if options.key?(:only) or options.key?(:methods) or options.key?(:include) or options.key?(:except)

       current_user = options[:current_user]
       #binding.pry
      options.delete(:current_user)
       h = super(options)
      h[:my_kitten] = my_kitten(current_user.id) if current_user.present?
      h[:liked_by_me] = liked_by_me(current_user) if current_user.present?
      h
    else
      h = super( methods: [:like_count, :like_by]) 
         
    end 
  end

  def like_count
    self.get_likes.size
  end

  def like_by
    self.votes_for.up.by_type(User).voters
  end

  def my_kitten(current_user_id)
    if current_user_id == self.user.id
      true
    else
      false
    end
  end

  def liked_by_me(current_user)
    if current_user == self.votes_for.up.by_type(User).voters
      true
    else
      false
    end
  end



  private

  def age_limits
    if age > 99
      errors.add(:age,"must be less than 99 ")
    elsif age < 0
      errors.add(:age,"Cant be negative")
    end
  end

  def cuteness_limits
    if cuteness > 11
      errors.add(:cuteness,"must be less than 11 ")
    elsif cuteness < 0
      errors.add(:cuteness,"Cant be negative")
    end
  end

  def softness_limits
    if softness > 11
      errors.add(:softness,"must be less than 11")
    elsif softness < 0
      errors.add(:softness,"Cant be negative")
    end
  end


end
