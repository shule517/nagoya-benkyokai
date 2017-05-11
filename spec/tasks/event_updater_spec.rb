require 'rails_helper'

describe EventUpdater, type: :request do
  it '例外が発生しないこと', vcr: '#call' do
    expect { EventUpdater.call }.not_to raise_error
  end
end
