defmodule Handyman.Templates.Descriptor do
  @moduledoc """
  Loads and interacts with a template descriptor file.
  """

  defmodule FileNotFound do
    defexception message: "template file not found"
  end

  defmodule InvalidToml do
    defexception message: "unknown toml error"
  end

  defmodule TemplateNeedsName do
    defexception message: "template is missing name"
  end

  @type descriptor :: %{
          name: String,
          description: String,
          dependencies: [String],
          snippets: [String],
          source_files: [String],
          variables: [
            %{
              name: String,
              value: String
            }
          ]
        }

  @doc """
  Load a template descriptor from a given file path.
  """
  @spec parse(String) :: {:ok, descriptor} | {:error, atom, String}
  def parse(path) do
    if !File.exists?(path) do
      {:error, :file_not_found, "The file " <> path <> " could not be found."}
    else
      case Toml.decode_file(path) do
        {:error, {:invalid_toml, reason}} -> {:error, :invalid_toml, reason}
        {:error, reason} -> {:error, :unknown_error, reason}
        {:ok, data} -> make_descriptor(path, data)
      end
    end
  end

  @doc """
  Load a template descriptor from a given file path.
  """
  @spec parse!(String) :: descriptor | no_return
  def parse!(path) do
    case parse(path) do
      {:ok, descriptor} -> descriptor
      {:error, :unknown_error, reason} -> raise reason
      {:error, :invalid_toml, reason} -> raise InvalidToml, message: reason
      {:error, :template_needs_name, reason} -> raise TemplateNeedsName, message: reason
      {:error, :file_not_found, reason} -> raise FileNotFound, message: reason
    end
  end

  @spec make_descriptor(String, map) :: {:ok, descriptor} | {:error, atom, String}
  defp make_descriptor(path, toml_data) do
    descriptor = %{
      name: toml_data["name"],
      description: toml_data["description"],
      dependencies: Map.get(toml_data, "dependencies", []),
      snippets: Map.get(toml_data, "snippets", []),
      source_files: Map.get(toml_data, "source_files", []),
      variables: Map.get(toml_data, "variables", [])
    }

    # IO.puts(toml_data)

    case descriptor.name do
      nil ->
        {:error, :template_needs_name,
         "The template file at " <> path <> " is missing a required name property."}

      _ ->
        {:ok, descriptor}
    end
  end
end
