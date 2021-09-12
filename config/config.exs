# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :todoApp,
  ecto_repos: [TodoApp.Repo]

# Configures the endpoint
config :todoApp, TodoAppWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "XYojTMU7QGuzOGF2cwGL9GX5C26ohaGpXYU+PTGOz88COSkBDRmdhUi9BId03HhT",
  render_errors: [view: TodoAppWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: TodoApp.PubSub,
  live_view: [signing_salt: "yZxUJLra"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
