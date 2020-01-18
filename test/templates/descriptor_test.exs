defmodule HandymanTest.Templates.Descriptor do
  use ExUnit.Case
  doctest Handyman.Templates.Descriptor

  test "parse! returns template descriptor on success" do
    descriptor =
      Handyman.Templates.Descriptor.parse!("test/templates/descriptor_resources/valid.toml")

    assert descriptor
    assert descriptor.name == "a-fine-template"
  end

  test "parse! fails when file path to descriptor is invalid" do
    assert_raise Handyman.Templates.Descriptor.FileNotFound, fn ->
      Handyman.Templates.Descriptor.parse!(
        "test/templates/descriptor_resources/does_not_exist.toml"
      )
    end
  end

  test "parse! fails when toml is invalid" do
    assert_raise Handyman.Templates.Descriptor.InvalidToml, fn ->
      Handyman.Templates.Descriptor.parse!("test/templates/descriptor_resources/invalid.toml")
    end
  end

  test "parse! fails when a template doesn't have a name" do
    assert_raise Handyman.Templates.Descriptor.TemplateNeedsName, fn ->
      Handyman.Templates.Descriptor.parse!("test/templates/descriptor_resources/no_name_set.toml")
    end
  end
end
