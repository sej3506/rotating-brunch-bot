require "rails_helper"

RSpec.describe "SlackSlashCommandListController", type: :request do
  scenario "responds to list with default message" do
    slack_signing_secret = Slack::Events.config.signing_secret
    timestamp = Time.zone.now.to_i
    request_body = "token=#{slack_signing_secret}&team_id=T02PF6RHYSY&team_domain=testdouble-hq&channel_id=C02NYBB3VPH&channel_name=some-channel&user_id=U02PRHH0XEV&user_name=cliff.pruitt&command=%2Fdoubleup&text=list&api_app_id=A02PD0DUE03&is_enterprise_install=false&response_url=https%3A%2F%2Fhooks.slack.com%2Fcommands%2FT02PF6RHYSY%2F2823421496992%2F0WC0HfWeGJpHetxmF8yUmawo&trigger_id=2801968477828.2797229610916.883001cf5008d6d02fd58a3cf70f449e"
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
      "text" => "list",
      "api_app_id" => "A02PD0DUE03",
      "is_enterprise_install" => "false",
      "response_url" =>
       "https://hooks.slack.com/commands/T02PF6RHYSY/2823421496992/0WC0HfWeGJpHetxmF8yUmawo",
      "trigger_id" => "2801968477828.2797229610916.883001cf5008d6d02fd58a3cf70f449e"
    }

    post "/command/doubleup",
      params: request_params,
      headers: request_headers

    expect(response).to have_http_status(:ok)
    expect(response.body).to eq("Sorry! There are no configured channels for groupings.")
  end
end
