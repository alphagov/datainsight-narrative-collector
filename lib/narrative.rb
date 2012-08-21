require 'bundler/setup'
Bundler.require

require 'yaml'
require 'open-uri'
require 'bunny'
require 'json'
require 'google_drive'

module Collectors
  class NarrativeCollector

    API_SCOPE = "https://docs.google.com/feeds/ https://docs.googleusercontent.com/ https://spreadsheets.google.com/feeds/"
    GOOGLE_CLIENT_ID = '1054017153726.apps.googleusercontent.com'
    GOOGLE_CLIENT_SECRET = 'eMFsc8LU3ZGrRFG93WfQCnD3'

    def initialize(authorization_code=nil)
      @authorization_code = authorization_code
    end

    def print
      response.to_json
    end

    def broadcast
      client = Bunny.new ENV['AMQP']
      client.start
      exchange = client.exchange("datainsight", :type => :topic)
      exchange.publish(response.to_json, :key => 'googledrive.narrative')
      client.stop
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

    def create_exception_message(message, current_date)
      {
        :envelope => {
          :collected_at => DateTime.now,
          :collector => "narrative",
        },
        :payload => {
          :error => message
        }
      }
    end

    private
    def response
      begin
        worksheet = get_worksheet(@authorization_code)
        row = worksheet.rows.find_all { |item| item.first == "live" }.last
        create_message(row[3], row[2])
      rescue Exception => e
        create_exception_message(e.message, Date.today)
      end
    end

    def get_worksheet(authorization_code)
      key = ENV['WORKSHEET'] || '0AhRGSTCqlCiqdDNiVXFsdmh6RVV5N1lENE14X3lTcmc'
      authentication = GoogleAuthenticationBridge::GoogleAuthentication.new(API_SCOPE, GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET)
      token = authentication.get_oauth2_access_token(authorization_code)
      session = GoogleDrive.login_with_oauth(token)
      session.spreadsheet_by_key(key).worksheets[0]
    end

  end
end
