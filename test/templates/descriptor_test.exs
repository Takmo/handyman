defmodule HandymanTest.Templates.Descriptor do
  use ExUnit.Case
  alias Handyman.Templates.Descriptor
  doctest Handyman.Templates.Descriptor

  test "parse! returns template descriptor on success" do
    descriptor = Descriptor.parse!("test/templates/descriptor_resources/valid.toml")
    assert descriptor
    assert descriptor.name == "a-fine-template"
  end

  test "parse! fails when file path to descriptor is invalid" do
    assert_raise Descriptor.FileNotFoundError, fn ->
      Descriptor.parse!("test/templates/descriptor_resources/does_not_exist.toml")
    end
  end

  test "parse! fails when toml is invalid" do
    assert_raise Descriptor.InvalidTOMLError, fn ->
      Descriptor.parse!("test/templates/descriptor_resources/invalid.toml")
    end
  end

  test "parse! fails when a template doesn't have a name" do
    assert_raise Descriptor.TemplateNeedsNameError, fn ->
      Descriptor.parse!("test/templates/descriptor_resources/no_name_set.toml")
    end
  end
end
