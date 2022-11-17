defmodule Issues.Printer do
  def print(list) do
    list
    |> Enum.map(fn issue -> {issue["title"], issue["html_url"]} end)
    |> Enum.map(fn item -> formatted_item(item) end)
    |> IO.puts()
  end

  defp formatted_item({title, url}) do
    "[(#{url}) | #{title}] \n"
  end
end
