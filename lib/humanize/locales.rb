module Humanize
  %w[ru ua].each do |locale|
    require_relative "./locales/#{locale}.rb"
  end
end
