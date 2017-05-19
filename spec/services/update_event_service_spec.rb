require 'rails_helper'

describe UpdateEventService, type: :request do
  it '例外が発生しないこと', vcr: '#call' do
    expect { UpdateEventService.new.call }.not_to raise_error
  end
end
