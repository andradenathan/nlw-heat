defmodule Microservice.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Microservice.Repo,
      # Start the Telemetry supervisor
      MicroserviceWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Microservice.PubSub},
      # Start the Endpoint (http/https)
      MicroserviceWeb.Endpoint,
      # Start a worker by calling: Microservice.Worker.start_link(arg)
      # {Microservice.Worker, arg}
      Microservice.Scheduler
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Microservice.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MicroserviceWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
