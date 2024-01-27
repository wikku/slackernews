defmodule Slackernews.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SlackernewsWeb.Telemetry,
      Slackernews.Repo,
      {DNSCluster, query: Application.get_env(:slackernews, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Slackernews.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Slackernews.Finch},
      # Start a worker by calling: Slackernews.Worker.start_link(arg)
      # {Slackernews.Worker, arg},
      # Start to serve requests, typically the last entry
      SlackernewsWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Slackernews.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SlackernewsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
