# frozen_string_literal: true

# name: discourse-username-in-email
# about: TODO
# meta_topic_id: TODO
# version: 0.0.1
# authors: Discourse
# url: TODO
# required_version: 2.7.0

enabled_site_setting :discourse_username_in_email_enabled

module ::DiscourseUsernameInEmail
  PLUGIN_NAME = "discourse-username-in-email"
end

require_relative "lib/discourse_username_in_email/engine"

after_initialize do
  # Code which should run after Rails has finished booting
end
