require "rails_helper"

class CommandParamsChatopsController < ApplicationChatopsController
  def index
    render plain: "Got command <#{subcommand}> with name <#{command_params[:name]}> and group size <#{command_params[:group_size]}>"
  end
end

RSpec.describe "ApplicationChatopsController command params", type: :request do
  before :all do
    TestOnlyRoutes.draw do
      post "/chatops/test-params", to: "command_params_chatops#index"
    end
  end

  after :all do
    TestOnlyRoutes.clear!
  end

  scenario "provides subcommand and command_params to actions" do
    slack_signing_secret = Slack::Events.config.signing_secret
    timestamp = Time.zone.now.to_i
    request_body = "token=#{slack_signing_secret}&team_id=T02PF6RHYSY&team_domain=testdouble-hq&channel_id=C02NYBB3VPH&channel_name=some-channel&user_id=U02PRHH0XEV&user_name=cliff.pruitt&command=%2Fdoubleup&text=snazzy-command+--name%3Dblargh+--group-size%3D4&api_app_id=A02PD0DUE03&is_enterprise_install=false&response_url=https%3A%2F%2Fhooks.slack.com%2Fcommands%2FT02PF6RHYSY%2F2823421496992%2F0WC0HfWeGJpHetxmF8yUmawo&trigger_id=2801968477828.2797229610916.883001cf5008d6d02fd58a3cf70f449e"
    data = ["v0", timestamp, request_body].join(":")
    mac = OpenSSL::HMAC.hexdigest("SHA256", slack_signing_secret, data)
    signature = "v0=#{mac}"

    request_headers = {
      "X-Slack-Signature" => signature,
      "X-Slack-Request-Timestamp" => timestamp
    }

    request_params = {
      "token" => slack_signing_secret,
      "team_id" => "T02PF6RHYSY",
      "team_domain" => "testdouble-hq",
      "channel_id" => "C02NYBB3VPH",
      "channel_name" => "some-channel",
      "user_id" => "U02PRHH0XEV",
      "user_name" => "cliff.pruitt",
      "command" => "/doubleup",
      "text" => "snazzy-command --name=blargh --group-size=4",
      "api_app_id" => "A02PD0DUE03",
      "is_enterprise_install" => "false",
      "response_url" =>
       "https://hooks.slack.com/commands/T02PF6RHYSY/2823421496992/0WC0HfWeGJpHetxmF8yUmawo",
      "trigger_id" => "2801968477828.2797229610916.883001cf5008d6d02fd58a3cf70f449e"
    }

    post "/chatops/test-params",
      params: request_params,
      headers: request_headers

    expect(response).to have_http_status(:ok)
    expect(response.body).to eq("Got command <snazzy-command> with name <blargh> and group size <4>")
  end

  scenario "provides subcommand and command_params to actions for empty params" do
    slack_signing_secret = Slack::Events.config.signing_secret
    timestamp = Time.zone.now.to_i
    request_body = "token=#{slack_signing_secret}&team_id=T02PF6RHYSY&team_domain=testdouble-hq&channel_id=C02NYBB3VPH&channel_name=some-channel&user_id=U02PRHH0XEV&user_name=cliff.pruitt&command=%2Fdoubleup&text=&api_app_id=A02PD0DUE03&is_enterprise_install=false&response_url=https%3A%2F%2Fhooks.slack.com%2Fcommands%2FT02PF6RHYSY%2F2823421496992%2F0WC0HfWeGJpHetxmF8yUmawo&trigger_id=2801968477828.2797229610916.883001cf5008d6d02fd58a3cf70f449e"
    data = ["v0", timestamp, request_body].join(":")
    mac = OpenSSL::HMAC.hexdigest("SHA256", slack_signing_secret, data)
    signature = "v0=#{mac}"

    request_headers = {
      "X-Slack-Signature" => signature,
      "X-Slack-Request-Timestamp" => timestamp
    }

    request_params = {
      "token" => slack_signing_secret,
      "team_id" => "T02PF6RHYSY",
      "team_domain" => "testdouble-hq",
      "channel_id" => "C02NYBB3VPH",
      "channel_name" => "some-channel",
      "user_id" => "U02PRHH0XEV",
      "user_name" => "cliff.pruitt",
      "command" => "/doubleup",
      "text" => "",
      "api_app_id" => "A02PD0DUE03",
      "is_enterprise_install" => "false",
      "response_url" =>
       "https://hooks.slack.com/commands/T02PF6RHYSY/2823421496992/0WC0HfWeGJpHetxmF8yUmawo",
      "trigger_id" => "2801968477828.2797229610916.883001cf5008d6d02fd58a3cf70f449e"
    }

    post "/chatops/test-params",
      params: request_params,
      headers: request_headers

    expect(response).to have_http_status(:ok)
    expect(response.body).to eq("Got command <> with name <> and group size <>")
  end
end
