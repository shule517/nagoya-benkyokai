class UsersController < ApplicationController
  def show
    @user = User.find_by(twitter_id: params[:userid])
    participants = Participant.where(user_id: @user.id)
    event_ids = participants.map(&:event_id)
    users_events = Event.where('id in (?)', event_ids)

    @events = users_events.scheduled
    @events_histories = users_events.ended
  end
end
