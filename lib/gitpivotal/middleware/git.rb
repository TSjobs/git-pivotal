module Middleware
  class Git
    def initialize(payload)
      @pr = extract_pr_info(payload)
    end

    def pr
      @pr
    end

    private

    def extract_pr_info(payload)
      response = {
        action: payload['action'],
        merged: payload['pull_request']['merged'],
        tracker_id: get_tracker_id_from_string(payload['pull_request']['title']),
        merged_at: payload['pull_request']['merged_at'],
        sender_username: payload['sender']['login'],
        merged_by: payload['pull_request']['merged_by']
      }
    end

    def get_tracker_id_from_string(string)
      string.match(/\d+/).to_s
    end
  end
end
