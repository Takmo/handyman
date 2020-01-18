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

  @spec do_inject_hooks([snippet], {:hook_point, String}) :: [String]
  defp do_inject_hooks(snippets, {:hook_point, name}) do
    snippets
    |> Enum.filter(fn snippet -> snippet.destination_name == name end)
    |> Enum.flat_map(fn snippet -> snippet.contents end)
  end

  @spec do_inject_hooks([snippet], String) :: [String]
  defp do_inject_hooks(snippets, line), do: [line]

  @doc """
  Parse available snippets from a given file path.
  """
  @spec read_snippets(String) :: [snippet]
  def read_snippets(path) do
    # TODO
  end

  @doc """
  Parse a source file from a given file path.
  """
  @spec read_source_file(String) :: source_file
  def read_source_file(path) do
    # TODO
  end
end
