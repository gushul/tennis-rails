class CoachesCourt < ActiveRecord::Base
  belongs_to :coach
  belongs_to :court

end