# frozen_string_literal: true

# name: discourse-username-in-email
# about: Adds recipient username to email notifications
# version: 0.1
# authors: pfaffman
# url: https://github.com/pfaffman/discourse-username-in-email

enabled_site_setting :discourse_username_in_email_enabled

module ::DiscourseUsernameInEmail
  PLUGIN_NAME = "discourse-username-in-email"
end

require_relative "lib/discourse_username_in_email/engine"

after_initialize do
  # Add plugin view path to Rails paths so UserNotificationRenderer picks it up
  plugin_view_path = File.expand_path("../app/views", __FILE__)
  Rails.configuration.paths["app/views"].unshift(plugin_view_path)

  add_to_class(:post, :recipient_username) { @recipient_username }
  add_to_class(:post, :recipient_username=) { |v| @recipient_username = v }

  module ::UserNotificationsExtension
    def send_notification_email(opts)
      if opts[:post] && opts[:user]
        # Only add username for watched topics/categories
        # "posted" is used for watched topics, but also overridden for PMs, so we exclude PMs explicitly.
        watched_types = %w[posted watching_category_or_tag watching_first_post]

        if watched_types.include?(opts[:notification_type].to_s) && !opts[:post].topic.private_message?
          opts[:post].recipient_username = opts[:user].username
        end
      end
      super
    end
  end

  ::UserNotifications.prepend(::UserNotificationsExtension)
end
