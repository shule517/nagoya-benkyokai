class UpdateEventTagService
  def call
    @event_tags = Api::Techplay::TechplayApi.new.search_all_tags
    crate_tag
    update_event
  end

  private
  attr_reader :event_tags

  def crate_tag
    event_tags.flat_map { |title, tags| tags }.uniq.each do |tag|
      Tag.create(tag_id: tag[:id], name: tag[:name]) unless Tag.exists?(tag_id: tag[:id])
    end
  end

  def update_event
    event_tags.each do |title, tags|
      Event.where(title: title).each do |event|
        tags.each do |tag|
          tag = Tag.where(tag_id: tag[:id]).first
          event.tags << tag unless event.tags.exists?(tag)
        end
      end
    end
  end
end
