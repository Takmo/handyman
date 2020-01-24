defmodule HandymanTest.Templates.Descriptor do
  use ExUnit.Case
  alias Handyman.Templates.Descriptor
  doctest Handyman.Templates.Descriptor

  test "parse! returns template descriptor on success" do
    descriptors = Descriptor.parse!("test/templates/descriptor_resources/valid.toml")
    assert length(descriptors) == 1
    descriptor = hd(descriptors)
    assert descriptor
    assert descriptor.name == "a-fine-template"
  end

  test "parse_string! returns template descriptor on success" do
    test_string = """
    [a-fine-template]
    description = "haha lol"
    """

    descriptors = Descriptor.parse_string!(test_string)
    assert length(descriptors) == 1
    descriptor = hd(descriptors)
    assert descriptor
    assert descriptor.name == "a-fine-template"
  end
end
