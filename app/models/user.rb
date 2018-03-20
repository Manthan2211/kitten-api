class User < ApplicationRecord
  has_many :kittens, dependent: :destroy  

  acts_as_voter

  validates :name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,presence: true,
                  length: { maximum: 255 },
                  format: { with: VALID_EMAIL_REGEX },
                  uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }

   def as_json(options={})
#   options hash accepts four keys for better customization :only, :methods, :include, :except
#   so whenever such keys are found, we call super with those keys to provide response consisting only those keys  
    if options.key?(:only) or options.key?(:methods) or options.key?(:include) or options.key?(:except)
      h = super(options)
    else
      h = super(only: [:id , :name]) 
         
    end 
  end
end
