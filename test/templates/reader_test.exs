defmodule HandymanTest.Templates.Reader do
  use ExUnit.Case
  doctest Handyman.Templates.Reader
  alias Handyman.Templates.Reader

  @spec collect_hook_points([String | {:hook_point, String}]) :: [String]
  defp collect_hook_points([{:hook_point, name} | tail]), do: [name | collect_hook_points(tail)]
  defp collect_hook_points([_line | tail]), do: collect_hook_points(tail)
  defp collect_hook_points([]), do: []

  test "read_source_file! works on a file with no hooks" do
    f = Reader.read_source_file!("test/templates/reader_resources/source_file_no_hooks.py")
    assert length(f.contents) > 0
    hook_points = collect_hook_points(f.contents)
    assert length(hook_points) == 0
  end

  test "read_source_file! works on a file with one hook" do
    f = Reader.read_source_file!("test/templates/reader_resources/source_file_one_hook.py")
    assert length(f.contents) > 0
    hook_points = collect_hook_points(f.contents)
    assert length(hook_points) == 1
    assert List.first(hook_points) == "first-hook-point"
  end

  test "read_source_file! works on a file with many hooks" do
    f = Reader.read_source_file!("test/templates/reader_resources/source_file_four_hooks.py")
    assert length(f.contents) > 0
    hook_points = collect_hook_points(f.contents)
    assert length(hook_points) == 4
    assert List.last(hook_points) == "last-hook-point"
  end

  test "read_source_file! errors when hook is missing name" do
    assert_raise Reader.NeedsHookNameError, fn ->
      Reader.read_source_file!("test/templates/reader_resources/source_file_missing_hook_name.py")
    end
  end

  test "read_snippets! works when a file has no snippets" do
    snippets =
      Reader.read_snippets!("test/templates/reader_resources/snippets_file_no_snippets.py")

    assert length(snippets) == 0
  end

  test "read_snippets! works when a file has one snippet" do
    snippets =
      Reader.read_snippets!("test/templates/reader_resources/snippets_file_one_snippet.py")

    assert length(snippets) == 1
    s = List.first(snippets)
    first_line = List.first(s.contents)
    last_line = List.last(s.contents)
    assert s.destination_name == "first-hook-point"
    assert String.trim(first_line) == "# first-line-in-first-snippet"
    assert String.trim(last_line) == "# last-line-in-first-snippet"
  end

  test "read_snippets! works when a file has many snippets" do
    snippets =
      Reader.read_snippets!("test/templates/reader_resources/snippets_file_four_snippets.py")

    assert length(snippets) == 4
    s = List.last(snippets)
    first_line = List.first(s.contents)
    last_line = List.last(s.contents)
    assert s.destination_name == "last-hook-point"
    assert String.trim(first_line) == "# first-line-in-last-snippet"
    assert String.trim(last_line) == "# last-line-in-last-snippet"
  end

  test "read_snippets! errors when snippet is missing name" do
    assert_raise Reader.NeedsHookNameError, fn ->
      Reader.read_snippets!("test/templates/reader_resources/snippets_file_missing_hook_name.py")
    end
  end

  test "read_snippets! errors when snippet is missing a beginning marker" do
    assert_raise Reader.SnippetIncompleteError, fn ->
      Reader.read_snippets!("test/templates/reader_resources/snippets_file_missing_beginning.py")
    end
  end

  test "read_snippets! errors when snippet is missing an ending marker" do
    assert_raise Reader.SnippetIncompleteError, fn ->
      Reader.read_snippets!("test/templates/reader_resources/snippets_file_missing_ending.py")
    end
  end

  test "inject_hooks! works when there are no hook points in a file" do
    # TODO
  end

  test "inject_hooks! works when there are no snippets compatible with hook points in a file" do
    # TODO
  end

  test "inject_hooks! works when there is one snippet to inject at a hook point" do
    # TODO
  end

  test "inject_hooks! works when there are multiple snippets to inject at a hook point" do
    # TODO
  end

  test "inject_hooks! works when there are multiple hook points with a snippet for each" do
    # TODO
  end
end
