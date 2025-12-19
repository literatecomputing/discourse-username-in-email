# Discourse Username In Email Plugin

This plugin adds the recipient's username to the bottom of email notifications in Discourse. It also supports adding a subtle watermark of the username to the background, and injecting the username into the middle of the email body.

**Note:** The username, watermark, and body injection are only added to notifications for watched topics, categories, or tags. They are NOT added to direct replies, mentions, or private messages.

## Customization

You can customize the text displayed using the `discourse_username_in_email_intended_for_text` site setting. Use `username` as a placeholder for the recipient's username.

Example: `This email is intended for username`

### Features

*   **Footer Text**: Adds the intended for text to the bottom of the email. (Enable via `discourse_username_in_email_footer_enabled`, default: true)
*   **Watermark**: Adds a subtle background watermark. (Enable via `discourse_username_in_email_watermark_enabled`)
*   **Mid-Body Injection**: Injects the intended for text into the middle of the email body (between paragraphs). (Enable via `discourse_username_in_email_inject_mid_body`)

If you need more advanced customization (like changing HTML structure or styles), you can modify the template file included in this plugin.

### Advanced: How to modify the template

1.  Open the file `plugins/discourse-username-in-email/app/views/email/_post.html.erb`.
2.  Scroll to the bottom of the file.
3.  Look for this block of code:

    ```erb
    <% if post.recipient_username %>
      <div class='recipient-username'>
        <%= post.recipient_username %>
      </div>
    <% end %>
    ```

4.  You can add HTML or text around `<%= post.recipient_username %>`.

### Examples

**Example 1: Add a label**

```erb
<% if post.recipient_username %>
  <div class='recipient-username'>
    This email was sent to: <strong><%= post.recipient_username %></strong>
  </div>
<% end %>
```

**Example 2: Change the style**

```erb
<% if post.recipient_username %>
  <div class='recipient-username' style='color: #888; font-size: 12px; margin-top: 10px;'>
    Recipient: <%= post.recipient_username %>
  </div>
<% end %>
```

### Applying Changes

After modifying the file, you may need to restart your Discourse server for the changes to take effect.

## Testing

To verify that the plugin is working correctly and to see your changes without sending real emails, you can run the following command in your terminal from the Discourse root directory:

```bash
bin/rails runner "user = User.last; post = Post.last; opts = { post: post, notification_type: 'posted', notification_data_hash: { original_username: post.user.username, topic_title: post.topic.title } }; email = UserNotifications.user_posted(user, opts); puts email.html_part.body.to_s"
```

This command generates a sample email notification using the last user and post in your database and prints the HTML body to the console. You should see your changes at the bottom of the output.

### Testing Negative Cases (Should NOT show username)

To verify that the username is NOT shown for other notification types (like replies), run:

```bash
bin/rails runner "user = User.last; post = Post.last; opts = { post: post, notification_type: 'replied', notification_data_hash: { original_username: post.user.username, topic_title: post.topic.title } }; email = UserNotifications.user_replied(user, opts); puts email.html_part.body.to_s"
```
