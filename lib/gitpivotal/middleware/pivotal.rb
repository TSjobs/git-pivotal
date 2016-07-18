require 'tracker_api'
require 'sinatra/config_file'


module Middleware
  class Pivotal
    STATES = {
      DELIVERED: 'delivered'
    }
    CONFIG = YAML.load_file(File.join(Dir.pwd, 'config/secrets.yml'))

    def initialize
      @client = TrackerApi::Client.new(token: CONFIG['pivotal_token'])
    end

    def pr(git)
      @git = git

      case git[:action]
      when 'closed'
        deliver_story
        #TODO: add a comment on the story with PR link and merged by name
      when 'opened'
        #TODO: slack the assigned person
        nil
      else
        nil
      end
    end

    def deliver_story
      return if !@git[:merged]
      story = @client.story(@git[:tracker_id])
      story.attributes = { current_state: STATES[:DELIVERED] }
      story.save
    end
  end
end