require "rails_err_handler/version"

module RailsErrHandler
  def self.handle(err, &block)
    Rails.logger.error err.message
    Rails.logger.error err.backtrace.join("\n")
    yield(err) if block
    err
  end
end
