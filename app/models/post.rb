class Post < ActiveRecord::Base
	has_many :comments, dependent: :destroy
 	validates :title, presence: true,
                    length: { minimum: 5 }
    validates_presence_of :category
  	belongs_to :category
end
