module Matchmaking
  def config
    Rails.application.config.x.matchmaking
  end
  module_function :config
end
