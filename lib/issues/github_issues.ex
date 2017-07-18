defmodule Issues.GithubIssues do

  require Logger

  @user_agent [ {"User-agent", "Elixir rylek90"} ]
  @github_url Application.get_env(:issues, :github_url)

  import Poison.Parser, only: [parse!: 1]

  def fetch(user, project) do
    Logger.info("Fetching user #{user}'s project #{project}'")
    issues_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  def issues_url(user, project), do:
    "#{@github_url}/repos/#{user}/#{project}/issues"

  def handle_response({:ok, %{status_code: 200, body: body}}) do
    Logger.info("Successful response")
    Logger.debug fn -> inspect(body) end
    {:ok, parse!(body)}
  end

  def handle_response({_, %{status_code: status, body: body}}) do
    Logger.error("Error #{status} returned")
    {:error, parse!(body)}
  end

end
