defmodule UploadExperiment.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      UploadExperimentWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:upload_experiment, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: UploadExperiment.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: UploadExperiment.Finch},
      # Start a worker by calling: UploadExperiment.Worker.start_link(arg)
      # {UploadExperiment.Worker, arg},
      # Start to serve requests, typically the last entry
      UploadExperimentWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: UploadExperiment.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    UploadExperimentWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
