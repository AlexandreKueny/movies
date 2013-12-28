class Film < ActiveRecord::Base

  scope :deleted, -> { where('deleted_at IS not null') }
  scope :current, -> { where('deleted_at IS null') }
end
