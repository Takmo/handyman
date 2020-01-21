defmodule Handyman.Templates.Descriptor do
  @moduledoc """
  Loads and interacts with a template descriptor file.
  """

  @moduledoc """
  Denotes that the template descriptor is missing the required 'name' field.
  """
  defmodule TemplateNeedsNameError do
    defexception message: "the template needs a name"
  end

  @typedoc "The handyman.toml template descriptor."
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
  @spec parse!(String) :: descriptor | no_return
  def parse!(path) do
    toml_data = Toml.decode_file!(path)

    descriptor = %{
      name: toml_data["name"],
      description: toml_data["description"],
      dependencies: Map.get(toml_data, "dependencies", []),
      snippets: Map.get(toml_data, "snippets", []),
      source_files: Map.get(toml_data, "source_files", []),
      variables: Map.get(toml_data, "variables", [])
    }

    if descriptor.name == nil do
      raise TemplateNeedsNameError,
        message: "The template file at " <> path <> " is missing a required name property."
    else
      descriptor
    end
  end
end
