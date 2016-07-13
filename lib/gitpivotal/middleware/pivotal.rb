module Middleware
  class Pivotal
    STATES = {
      DELIVERED: 'devlivered'
    }

    def initialize
      @client = TrackerApi::Client.new(token: ENV['pivotal_token'])
    end

    def pr(git)
      @git = git
      case git
      when 'closed'
        deliver_story(git)
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
      story = TrackerApi::Resources::Story.new(client: @client, id: @git[:tracker_id])
      story.attributes = { current_state: STATES[:DELIVERED] }
      story.save
    end
  end
end