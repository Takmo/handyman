defmodule Handyman.Templates.Descriptor do
  @moduledoc """
  Loads and interacts with a template descriptor file.
  """

  @descriptor_file_name "handyman.toml"

  @type descriptor :: %{
    name: String,
    description: String,
    dependencies: [String],
    snippets: [String],
    source_files: [String],
    variables: [%{
      name: String,
      value: String,
    }],
  }

  @doc """
  Load a template descriptor from a given file path.
  """
  @spec load(String) :: {:ok, descriptor} | {:error, String}
  def parse(path) do
    case Toml.decode_file(path + desciptor_file_name) do
      {:error, {:invalid_toml, reason}} -> {:error, reason}
      {:error, reason} -> {:error, reason}
      {:ok, data} -> make_descriptor(data)
    end
  end

  @doc """
  Load a template descriptor from a given file path.
  """
  @spec load(String) :: descriptor | no_return
  def parse!(path) do
    case parse(path) do
      {:ok, descriptor} -> descriptor
      {:error, reason} -> raise reason
    end
  end

  @doc """
  Create a template descriptor from the loaded TOML data.
  """
  @spec make_descriptor(map) :: {:ok, descriptor} | {:error, String}
  defp make_descriptor(toml_data) do
    descriptor = %{
      name: toml_data['name'],
      description: toml_data['description'],
      dependencies: Map.get(toml_data, 'dependencies', []),
      snippets: Map.get(toml_data, 'snippets', []),
      source_files: Map.get(toml_data, 'source_files', []),
      variables: Map.get(toml_data, 'variables', []),
    }
    case descriptor.name do
      nil -> {:error, "template name must not be null"}
      _ -> {:ok, descriptor}
    end
  end

end
