class Torrent < ActiveRecord::Base

  scope :deleted, -> {where('deleted_at IS not null')}
  scope :current, -> {where('deleted_at IS null') }

  has_many :t_films, dependent: :destroy
end
