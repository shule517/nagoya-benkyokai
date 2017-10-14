# == Schema Information
#
# Table name: event_tags
#
#  id         :integer          not null, primary key
#  event_id   :integer
#  tag_id     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_event_tags_on_event_id  (event_id)
#  index_event_tags_on_tag_id    (tag_id)
#

require 'rails_helper'

RSpec.describe EventTag, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
