class Stadium < ActiveRecord::Base

  default_scope { order(created_at: :desc) }
  include FriendlyId
  friendly_id :name, use: [:slugged]

  enum status: [:pending, :active, :locked]
  
  belongs_to :category
  belongs_to :user
  has_many :events, through: :courts
  has_many :courts
  has_many :coaches, through: :courts
  accepts_nested_attributes_for :courts, :reject_if => :all_blank, :allow_destroy => true

  has_many :pictures, as: :imageable
  has_many :reviews, as: :reviewable

  # validates_presence_of :phone

  def as_json params={}
    {
      position: {
        lat: latitude.to_f,
        lng: longitude.to_f
      },
      name: name
    }
  end

  # ransacker :avg_price do |parent|
  #   query = 
  #   Arel.sql('')
  # end

end
