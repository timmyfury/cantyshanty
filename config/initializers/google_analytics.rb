class GoogleAnalytics
  ACCOUNT = ENV['CANTYSHANTY_GOOGLE_ANALYTICS_ACCOUNT']
  DOMAIN = ENV['CANTYSHANTY_GOOGLE_ANALYTICS_DOMAIN']
  USER_AGENT = 'Canty Shanty Agent'

  def self.track(title, page, secondary_source=nil, utma=nil, agent=USER_AGENT)
    gabba = Gabba::Gabba.new(GoogleAnalytics::ACCOUNT, GoogleAnalytics::DOMAIN, agent=agent)

    gabba.identify_user(utma) if utma
    gabba.set_custom_var(1, 'Secondary Source', secondary_source, Gabba::Gabba::PAGE) if secondary_source
    gabba.page_view(title, page)
  end
end
