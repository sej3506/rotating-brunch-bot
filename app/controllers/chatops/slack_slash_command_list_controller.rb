module Chatops
  class SlackSlashCommandListController < ::ApplicationChatopsController
    def handle
      config = Matchmaking.config
      message = config.to_h.keys.sort.each_with_object([]) do |key, result|
        grouping = config[key]
        next unless include_grouping_in_list?(grouping)
        result << "*#{key.to_s.titleize}*: Meets #{grouping.schedule} in groups of #{grouping.size} (Join: ##{grouping.channel})"
      end.join("\n")

      if config.to_h.keys.any?
        render plain: message
      else
        render plain: "Sorry! There are no configured channels for groupings."
      end
    end

    private

    def include_grouping_in_list?(grouping)
      grouping.active || command_params.key?(:all)
    end
  end
end
