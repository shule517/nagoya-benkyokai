require 'rails_helper'

describe EventUpdater do
  it '例外が発生しないこと' do
    expect{ EventUpdater.call }.not_to raise_error
  end
end
