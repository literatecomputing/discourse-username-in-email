# frozen_string_literal: true

DiscourseUsernameInEmail::Engine.routes.draw do
  get "/examples" => "examples#index"
  # define routes here
end

Discourse::Application.routes.draw { mount ::DiscourseUsernameInEmail::Engine, at: "discourse-username-in-email" }
