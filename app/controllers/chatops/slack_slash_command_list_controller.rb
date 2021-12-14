module Chatops
  class SlackSlashCommandListController < ::ApplicationChatopsController
    def handle
      render plain: "Sorry! There are no configured channels for groupings."
    end
  end
end
