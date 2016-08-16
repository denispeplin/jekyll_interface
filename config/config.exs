# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :jekyll_interface,
  ecto_repos: [JekyllInterface.Repo]

# Configures the endpoint
config :jekyll_interface, JekyllInterface.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "TzcBKLrGt7sfEhQFljVVaW1bo3+2ldsn9WpCXU3Y1FNnTpsqSQHQdAtafPEYwJ9j",
  render_errors: [view: JekyllInterface.ErrorView, accepts: ~w(html json)],
  pubsub: [name: JekyllInterface.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
