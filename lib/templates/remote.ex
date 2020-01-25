defmodule Handyman.Templates.Remote do
  @moduledoc """
  Functions for fetching remote resources.
  """

  @config_file_name "handyman.toml"

  @doc """
  Remove all template directories specified.
  """
  @spec clean_all_templates!([String]) :: no_return
  def clean_all_templates!(names) do
    names
    |> Enum.map(&Task.async(fn -> clean_template!(&1) end))
    |> Enum.map(&Task.await(&1))
  end

  @doc """
  Delete a template directory.
  """
  @spec clean_template!(String) :: no_return
  def clean_template!(name) do
    File.rm_rf!(name)
  end

  @doc """
  Fetch the template descriptors for all provided URLs.
  """
  @spec fetch_all_configs!([String]) :: [Descriptor.descriptor() | {:error, String}] | no_return
  def fetch_all_configs!(config_urls) do
    config_urls
    |> Enum.map(&Task.async(fn -> fetch_config!(&1) end))
    |> Enum.map(&Task.await(&1))
  end

  @doc """
  Fetch all templates for all provided names and URLs.
  """
  @spec fetch_all_templates!([{String, String}]) ::
          [Descriptor.descriptor() | {:error, String}] | no_return
  def fetch_all_templates!(templates_info) do
    templates_info
    |> Enum.map(fn {name, url} -> Task.async(fn -> fetch_template!(name, url) end) end)
    |> Enum.map(&Task.await(&1))
  end

  @doc """
  Fetch descriptor(s) from a remote URL.
  """
  @spec fetch_config!(String) :: [Descriptor.descriptor()] | {:error, String} | no_return
  def fetch_config!(config_url) do
    case HTTPoison.get!(config_url) do
      %HTTPoison.Response{status_code: 200, body: body} ->
        Handyman.Templates.Descriptor.parse_string!(body)

      %HTTPoison.Response{status_code: status} ->
        {:error, "could not fetch remote config file (status code #{status}"}
    end
  end

  @doc """
  Fetch an entire template given its name and repository URL.
  """
  @spec fetch_template!(String, String) ::
          {:ok, [Descriptor.descriptor()]} | {:error, String} | no_return
  def fetch_template!(name, repo_url) do
    {output, return_code} = System.cmd("git", ["clone", repo_url, name])

    case return_code do
      0 -> Handyman.Templates.Descriptor.parse_file!("#{name}/#{@config_file_name}")
      _ -> {:error, output}
    end
  end
end
