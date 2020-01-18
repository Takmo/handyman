defmodule Handyman.Templates.Reader do
  @moduledoc """
  Parses snippets and source files from a given file path.
  """

  @hook_point_identifier "HANDYMAN_HOOK_POINT"
  @snippet_start_identifier "HANDYMAN_HOOK_INTO"
  @snippet_end_identifier "HANDYMAN_HOOK_FINISHED"

  @type snippet :: %{
    source_name: String,
    destination_name: String,
    contents: [String],
  }

  @type source_file :: %{
    relative_path: String,
    contents: [String | :hook_point | [snippet]],
  }

  @doc """
  Fill and replace all hook points in a file with their associated snippets, or remove them.
  """
  @spec inject_hooks(source_file, [snippet]) :: source_file
  def inject_hooks(original_source_file, snippets) do
    # TODO
  end

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
