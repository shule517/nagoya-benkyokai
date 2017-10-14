# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  tag_id     :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Tag < ApplicationRecord
  has_many :event_tags
  has_many :events, through: :event_tags
end
