defmodule Handyman.Templates.Descriptor do
  @moduledoc """
  Loads and interacts with a template descriptor file.
  """

  @typedoc "The handyman.toml template descriptor."
  @type descriptor :: %{
          name: String,
          description: String,
          url: String,
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
  @spec parse_file!(String) :: [descriptor] | no_return
  def parse_file!(path) do
    Toml.decode_file!(path) |> do_parse!
  end

  @doc """
  Load one or more template descriptors from a provided TOML string.
  """
  @spec parse_string!(String) :: [descriptor] | no_return
  def parse_string!(descriptor_string) do
    Toml.decode!(descriptor_string) |> do_parse!
  end

  @spec do_parse!(struct) :: [descriptor] | no_return
  defp do_parse!(data) do
    Enum.map(data, fn {name, descriptor} ->
      %{
        name: name,
        description: descriptor["description"],
        dependencies: Map.get(descriptor, "dependencies", []),
        snippets: Map.get(descriptor, "snippets", []),
        source_files: Map.get(descriptor, "source_files", []),
        variables: Map.get(descriptor, "variables", [])
      }
    end)
  end
end
