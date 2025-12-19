# Discourse Username In Email Plugin

This plugin adds the recipient's username to the bottom of email notifications in Discourse.

**Note:** The username is only added to notifications for watched topics, categories, or tags. It is NOT added to direct replies, mentions, or private messages.

## Customization

If you want to change how the username is displayed or add extra text (like "This email was sent to: ..."), you can modify the template file included in this plugin.

### How to modify the text

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
