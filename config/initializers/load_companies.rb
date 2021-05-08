class ConfigurationFileNotFound < RuntimeError; end

$COMPANIES = begin
  file = File.read(Rails.root.join('config','companies.json'))
  raw = JSON.parse(file)

  companies = {}

  raw.each do |c|
    companies[c['ticker']] = {
      'company_name' => c['company_name'],
      'ticker_color' => c['ticker_color'],
      'tags' => c['tags']
    }
  end

  companies
rescue Errno::ENOENT => e
  raise ConfigurationFileNotFound, 'config/companies.json not found.'
end
