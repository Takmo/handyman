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

  test "fetch_all_configs! successfully loads all remote descriptors" do
    configs = [
      "https://raw.githubusercontent.com/bitwisehero-groundwork/template-python/master/handyman.toml",
      "https://raw.githubusercontent.com/bitwisehero-groundwork/template-python/master/handyman.toml",
      "https://raw.githubusercontent.com/bitwisehero-groundwork/template-python/master/handyman.toml"
    ]

    descriptors = Remote.fetch_all_configs!(configs)
  end

  test "fetch_all_templates! successfully fetches all templates" do
    # need to clean up first
    template_names = [
      "template-a",
      "template-b"
    ]

    Remote.clean_all_templates!(template_names)

    # now run test
    templates = [
      {"template-a", "git@github.com:bitwisehero-groundwork/template-python.git"},
      {"template-b", "git@github.com:bitwisehero-groundwork/template-python.git"}
    ]

    descriptors = Remote.fetch_all_templates!(templates)

    # and clean up again if things went well
    template_names = [
      "template-a",
      "template-b"
    ]

    Remote.clean_all_templates!(template_names)
  end
end
