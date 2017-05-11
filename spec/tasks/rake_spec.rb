require 'rails_helper'
require 'rake'

describe 'rake', type: :request do
  before(:all) do
    @rake = Rake::Application.new
    Rake.application = @rake
    Rake.application.rake_require 'tasks/event' # Point 1
    Rake::Task.define_task(:environment)
  end

  before(:each) do
    @rake[task].reenable
  end

  describe 'event:update' do
    let(:task) { 'event:update' }
    it 'エラーが発生しないこと', vcr: 'event:update' do
      expect { @rake[task].invoke }.not_to raise_error
    end
  end
end
