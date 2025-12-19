# frozen_string_literal: true

require "rails_helper"

describe UserNotifications do
  let(:user) { Fabricate(:user, username: "recipient_user") }
  let(:topic) { Fabricate(:topic, title: "This is a test topic with a sufficiently long title") }
  let(:post) { Fabricate(:post, topic: topic, user: Fabricate(:user)) }

  before do
    SiteSetting.discourse_username_in_email_enabled = true
  end

  context "when notification type is 'posted' (watched topic)" do
    it "includes the recipient username in the email body" do
      opts = {
        post: post,
        notification_type: "posted",
        notification_data_hash: {
          original_username: post.user.username,
          topic_title: topic.title,
        },
      }

      email = UserNotifications.user_posted(user, opts)
      expect(email.html_part.body.to_s).to include("recipient_user")
      expect(email.html_part.body.to_s).to include("recipient-username")
    end
  end

  context "when notification type is 'watching_category_or_tag'" do
    it "includes the recipient username in the email body" do
      opts = {
        post: post,
        notification_type: "watching_category_or_tag",
        notification_data_hash: {
          original_username: post.user.username,
          topic_title: topic.title,
        },
      }

      email = UserNotifications.user_posted(user, opts)
      expect(email.html_part.body.to_s).to include("recipient_user")
    end
  end

  context "when notification type is 'replied'" do
    it "does NOT include the recipient username" do
      opts = {
        post: post,
        notification_type: "replied",
        notification_data_hash: {
          original_username: post.user.username,
          topic_title: topic.title,
        },
      }

      email = UserNotifications.user_replied(user, opts)
      expect(email.html_part.body.to_s).not_to include("recipient-username")
    end
  end

  context "when topic is a private message" do
    let(:pm_topic) { Fabricate(:private_message_topic) }
    let(:pm_post) { Fabricate(:post, topic: pm_topic, user: Fabricate(:user)) }

    it "does NOT include the recipient username even if type is 'posted'" do
      opts = {
        post: pm_post,
        notification_type: "posted",
        notification_data_hash: {
          original_username: pm_post.user.username,
          topic_title: pm_topic.title,
        },
      }

      # PMs usually use user_private_message but internally might use posted type logic in some places,
      # but our plugin explicitly checks topic.private_message?
      # Let's test user_posted with a PM post to verify our logic handles it if it ever happens,
      # or user_private_message if that's what triggers it.
      # The plugin hooks into send_notification_email.

      email = UserNotifications.user_private_message(user, opts)
      expect(email.html_part.body.to_s).not_to include("recipient-username")
    end
  end
end
