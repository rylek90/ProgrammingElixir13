defmodule Issues.GithubIssues do
  @user_agent [ {"User-agent", "Elixir rylek90"} ]
  @github_url Application.get_env(:issues, :github_url)

  import Poison.Parser, only: [parse!: 1]

  def fetch(user, project) do
    issues_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  def issues_url(user, project), do:
    "#{@github_url}/repos/#{user}/#{project}/issues"

  def handle_response({:ok, %{status_code: 200, body: body}}), do:
    {:ok, parse!(body)}

  def handle_response({_, %{status_code: _, body: body}}), do:
    {:error, parse!(body)}

end
