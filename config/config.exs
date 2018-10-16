# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :phlox,
  ecto_repos: [Phlox.Repo]

# Configures the endpoint
config :phlox, PhloxWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "2qGR387R3R9mtu3jZTFdM2OgTropqQBFB/dLPSpCWN2r544obGHPELzmk4Pek7un",
  render_errors: [view: PhloxWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Phlox.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
