defmodule Issues.CLI do
  @default_count 4

  import Issues.TableFormatter

  @moduledoc """
  Handle the command line parsing and the dispatch to
  various functions that end up generating n issues
  in a github project.
  """

  def main(argv) do
    argv
    |> parse_args
    |> process
  end

  def process(:help) do
    IO.puts("""
    usage: issues <user> <project> [ count | #{@default_count} ]
    """)

    System.halt(0)
  end

  def process({user, project, count}) do
    Issues.GithubIssues.fetch(user, project)
    |> decode_response()
    |> sort_response_desc()
    |> Enum.take(count)
    |> print_table_for_columns(["title", "html_url"])
  end

  defp decode_response({:ok, body}), do: body

  defp decode_response({:error, err}) do
    IO.puts("""
    Error fetching from github: #{err}
    """)

    System.halt(2)
  end

  defp sort_response_desc(issues) do
    issues
    |> Enum.sort(fn lhs, rhs ->
      lhs["created_at"] >= rhs["created_at"]
    end)
  end

  @spec parse_args([binary]) :: :help | {binary, binary, integer}
  @doc """
  `argv` can be -h or --help, which returns :help

  Otherwise it is a github sername, project name, and (optionally)
  the number of entries to format.

  Returns a tuple of `{ user, project, count }`, or `:help` if help
  was given.
  """
  def parse_args(argv) do
    OptionParser.parse(
      argv,
      switches: [hel: :boolean],
      aliases: [h: :help]
    )
    |> elem(1)
    |> args_to_internal_rep()
  end

  defp args_to_internal_rep([user, project, count]) do
    {user, project, String.to_integer(count)}
  end

  defp args_to_internal_rep([user, project]) do
    {user, project, @default_count}
  end

  defp args_to_internal_rep(_) do
    :help
  end
end
