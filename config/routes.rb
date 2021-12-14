class SlackSlashSubcommandConstraint
  def initialize(matches_subcommand:)
    @subcommand = matches_subcommand
  end

  def matches?(request)
    parsed = Utils::ParsesCliStyleCommandArgs.new.call(text: request.params["text"])
    parsed.subcommand == @subcommand
  end
end

Rails.application.routes.draw do
  if Rails.env.test?
    TestOnlyRoutes = ActionDispatch::Routing::RouteSet.new unless defined?(::TestOnlyRoutes)
    mount TestOnlyRoutes, at: "/"
  end

  post "/command/doubleup", to: "chatops/slack_slash_command_list#handle", constraints: SlackSlashSubcommandConstraint.new(matches_subcommand: 'list')
  post "/command/doubleup", to: "chatops/slack_slash_command#handle"
end
