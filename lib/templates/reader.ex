defmodule Handyman.Templates.Reader do
  @moduledoc """
  Parses snippets and source files from a given file path.
  """

  @hook_point_identifier "HANDYMAN_HOOK_POINT"
  @snippet_start_identifier "HANDYMAN_HOOK_INTO"
  @snippet_end_identifier "HANDYMAN_HOOK_FINISHED"

  @typedoc "A snippet to be copied from a source to a destination in the rendered template."
  @type snippet :: %{
          destination_name: String,
          contents: [String]
        }

  @typedoc "A source file from a template to be rendered."
  @type source_file :: %{
          relative_path: String,
          contents: [String | {:hook_point, String}]
        }

  @doc """
  Fill and replace all hook points in a file with their associated snippets, or remove them.
  """
  @spec inject_hooks(source_file, [snippet]) :: source_file
  def inject_hooks(original_source_file, snippets) do
    %{
      original_source_file
      | contents:
          original_source_file.contents
          |> Enum.flat_map(fn line -> do_inject_hooks(snippets, line) end)
    }
  end

  @spec do_inject_hooks([snippet], String | {:hook_point, String}) :: [String]
  defp do_inject_hooks(snippets, {:hook_point, name}) do
    snippets
    |> Enum.filter(fn snippet -> snippet.destination_name == name end)
    |> Enum.flat_map(fn snippet -> snippet.contents end)
  end

  defp do_inject_hooks(_snippets, line), do: [line]

  @doc """
  Parse available snippets from a given file path.
  """
  @spec read_snippets(String) :: [snippet]
  def read_snippets(path) do
    File.stream!(path) |> do_read_snippets(path, 1)
  end

  @spec do_read_snippets([String], String, non_neg_integer) :: [snippet]
  defp do_read_snippets([], _path, _line_offset), do: []

  defp do_read_snippets(lines, path, line_offset) do
    start_snippet =
      Enum.find_index(lines, fn line -> String.contains?(line, @snippet_start_identifier) end)

    end_snippet =
      Enum.find_index(lines, fn line -> String.contains?(line, @snippet_end_identifier) end)

    cond do
      start_snippet == nil && end_snippet == nil ->
        []

      start_snippet != nil && end_snippet == nil ->
        line_number = line_offset + start_snippet

        raise "Snippet starting at " <>
                path <>
                ":" <>
                Integer.to_string(line_number) <> "does not have a matching termination line."

      start_snippet == nil && end_snippet != nil ->
        line_number = line_offset + end_snippet

        raise "Snippet ending at " <>
                path <>
                ":" <> Integer.to_string(line_number) <> "does not have a matching starting line."

      start_snippet + 1 > end_snippet - 1 ->
        []

      true ->
        remainder = Enum.drop(lines, end_snippet + 1)
        name_line = lines[start_snippet]
        [_first, name] = String.split(name_line, @snippet_start_identifier)

        [
          %{
            destination_name: String.trim(name),
            contents: Enum.slice(lines, start_snippet + 1, end_snippet - start_snippet - 1)
          }
          | do_read_snippets(remainder, path, line_offset + end_snippet)
        ]
    end
  end

  @doc """
  Parse a source file from a given file path.
  """
  @spec read_source_file(String) :: source_file
  def read_source_file(path) do
    %{
      relative_path: path,
      contents: File.stream!(path) |> Stream.map(fn line -> read_source_line(line) end)
    }
  end

  @spec read_source_line(String) :: String | {:hook_point, String}
  defp read_source_line(line) do
    if !String.contains?(line, @hook_point_identifier) do
      line
    else
      [_first, name] = String.split(line, @hook_point_identifier)
      {:hook_point, String.trim(name)}
    end
  end
end
