defmodule HandymanTest.Templates.Remote do
  use ExUnit.Case
  alias Handyman.Templates.Remote
  doctest Handyman.Templates.Remote

  test "clean_all_templates! deletes templates successfully" do
    template_names = [
      "template-a",
      "template-b"
    ]

    Remote.clean_all_templates!(template_names)
  end

  test "expand_all_configs! successfully expands all partial descriptors" do
    partials = [
      %{
        name: "template-a",
        config_url:
          "https://raw.githubusercontent.com/bitwisehero-groundwork/template-python/master/handyman.toml"
      },
      %{
        name: "template-b",
        config_url:
          "https://raw.githubusercontent.com/bitwisehero-groundwork/template-python/master/handyman.toml"
      }
    ]

    descriptors = Remote.expand_all_configs!(partials)

    assert length(descriptors) == 2
    assert List.first(descriptors).name == "python"
    assert List.first(descriptors).name == List.last(descriptors).name
    assert List.first(descriptors).repo_url != ""
    assert List.first(descriptors).repo_url == List.last(descriptors).repo_url
  end

  test "fetch_all_configs! successfully loads all remote descriptors" do
    configs = [
      "https://raw.githubusercontent.com/bitwisehero-groundwork/template-python/master/handyman.toml",
      "https://raw.githubusercontent.com/bitwisehero-groundwork/template-python/master/handyman.toml"
    ]

    descriptors = Remote.fetch_all_configs!(configs)

    assert length(descriptors) == 2
    assert List.first(descriptors).name == "python"
    assert List.first(descriptors).name == List.last(descriptors).name
    assert List.first(descriptors).repo_url != ""
    assert List.first(descriptors).repo_url == List.last(descriptors).repo_url
  end

  test "fetch_all_templates! successfully fetches all templates" do
    template_names = [
      "template-a",
      "template-b"
    ]

    # need to clean up first
    Remote.clean_all_templates!(template_names)

    templates = [
      {"template-a", "git@github.com:bitwisehero-groundwork/template-python.git"},
      {"template-b", "git@github.com:bitwisehero-groundwork/template-python.git"}
    ]

    descriptors = Remote.fetch_all_templates!(templates)

    assert length(descriptors) == 2
    assert List.first(descriptors).name == "python"
    assert List.first(descriptors).name == List.last(descriptors).name
    assert List.first(descriptors).repo_url != ""
    assert List.first(descriptors).repo_url == List.last(descriptors).repo_url

    # and clean up again if things went well
    Remote.clean_all_templates!(template_names)
  end
end
