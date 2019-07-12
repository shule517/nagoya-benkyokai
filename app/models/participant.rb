# == Schema Information
#
# Table name: participants
#
#  id         :integer          not null, primary key
#  event_id   :integer
#  user_id    :integer
#  owner      :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_participants_on_event_id  (event_id)
#  index_participants_on_user_id   (user_id)
#

class Participant < ApplicationRecord
  belongs_to :event
  belongs_to :user
end
