class ApplicationChatopsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :verify_slack_hmac

  def verify_slack_hmac
    slack_request = Slack::Events::Request.new(request)
    slack_request.verify!
  rescue Slack::Events::Request::MissingSigningSecret, Slack::Events::Request::InvalidSignature, Slack::Events::Request::TimestampExpired
    render plain: "Nope.", status: :unauthorized
  end

  def subcommand
    Utils::ParsesCliStyleCommandArgs.new.call(text: params[:text]).subcommand
  end

  def command_params
    parsed = Utils::ParsesCliStyleCommandArgs.new.call(text: params[:text])
    ActionController::Parameters.new(parsed.args)
  end
end
