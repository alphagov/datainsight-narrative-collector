require 'bundler/setup'
Bundler.require

require 'yaml'
require 'open-uri'
require 'bunny'
require 'json'
require 'google_drive'

Datainsight::Logging.configure()

module Collectors
  class NarrativeCollector

    API_SCOPE = "https://docs.google.com/feeds/ https://docs.googleusercontent.com/ https://spreadsheets.google.com/feeds/"

    def initialize(authorization_code=nil)
      @authorization_code = authorization_code
    end

    def print
      begin
        response.to_json
      rescue => e
        logger.error { e }
      end
    end

    def broadcast
      begin
        logger.info { "Starting to collect narrative ..." }
        client = Bunny.new ENV['AMQP']
        client.start
        exchange = client.exchange("datainsight", :type => :topic)
        exchange.publish(response.to_json, :key => 'googledrive.narrative')
        client.stop
        logger.info { "Collected the narrative." }
      rescue => e
        logger.error { e }
      end
    end

    def create_message(content, author)
      {
          :envelope => {
              :collected_at => DateTime.now,
              :collector => "narrative",
          },
          :payload => {
              :content => content,
              :author => author,
          }
      }
    end

    private
    def response
      worksheet = get_worksheet(@authorization_code)
      row = worksheet.rows.find_all { |item| item.first == "live" }.last
      create_message(row[3], row[2])
    end

    def get_worksheet(authorization_code)
      key = ENV['WORKSHEET'] || '0AhRGSTCqlCiqdDNiVXFsdmh6RVV5N1lENE14X3lTcmc'
      token = get_google_auth.get_oauth2_access_token(authorization_code)
      session = GoogleDrive.login_with_oauth(token)
      session.spreadsheet_by_key(key).worksheets[0]
    end

    def get_google_auth
      GoogleAuthenticationBridge::GoogleAuthentication.create_from_config_file(
          API_SCOPE,
          "/etc/govuk/datainsight/google_credentials.yml",
          "/var/lib/govuk/datainsight/google-drive-token.yml"
      )
    end

  end
end
