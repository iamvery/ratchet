defmodule Ratchet.Template do
  @moduledoc """
  Handles Ratchet data during EEx rendering
  """

  require Logger

  @doc """
  Get the specified property from the given data

  Data is defined in the following forms:

  1. A map of property keys to data values
  2. A tuple who's first element is such a map and second element is data attributes
  3. Something else...

  This function provides a consistent interface for fetching a property from
  some body of data.

      iex> Template.property(%{}, :foo)
      nil
      iex> Template.property(%{foo: "bar"}, :foo)
      "bar"
      iex> Template.property({%{foo: "bar"}, []}, :foo)
      "bar"
      iex> Template.property({"Content", []}, :foo)
      nil
      iex> Template.property([attr: "value"], :foo)
      nil
  """
  def property({data, _attributes}, property), do: property(data, property)
  def property(map, property) when is_map(map) do
    Map.get(map, property) |> log(property, map)
  end
  def property(data, property), do: log(nil, property, data)

  defp log(nil, property, data) do
    Logger.warn "Property #{inspect property} not available in data #{inspect data}"
    nil
  end
  defp log(value, _property, _data), do: value

  @doc """
  Prepares data for list comprehension

  Ratchet must be able to consistently treat data as a list to facilitate
  rendering multiple elements. This function supports that requirement by
  ensuring elements are wrapped in a list.

      iex> Template.prepare("data")
      ["data"]
      iex> Template.prepare(["one", "two"])
      ["one", "two"]
      iex> Template.prepare([href: "/"])
      [[href: "/"]]
      iex> Template.prepare([{"foo", href: "/"}])
      [{"foo", href: "/"}]
      iex> Template.prepare({"foo", class: "btn"})
      [{"foo", class: "btn"}]
      iex> Template.prepare(nil)
      [nil]
  """
  def prepare(nil), do: [nil]
  def prepare([{key,_value}|_rest] = data) when is_atom(key), do: [data]
  def prepare(data), do: List.wrap(data)

  @doc """
  Determines if the given data provides plain text content

      iex> Template.content?("text")
      true
      iex> Template.content?({"text", href: "/foo/bar"})
      true
      iex> Template.content?(123)
      true
      iex> Template.content?({:safe, "<p>lolwat</p>"})
      true
      iex> Template.content?([href: "/"])
      false
      iex> Template.content?(%{foo: "bar"})
      false
      iex> Template.content?({%{foo: "bar"}, action: "/baz"})
      false
      iex> Template.content?(nil)
      false
  """
  def content?(map) when is_map(map), do: false
  def content?(list) when is_list(list), do: false
  def content?({map, _attributes}) when is_map(map), do: false
  def content?(nil), do: false
  def content?(_), do: true

  @doc """
  Extract content from a data property

      iex> Template.content("text")
      "text"
      iex> Template.content(123)
      123
      iex> Template.content({"text", []})
      "text"
      iex> Template.content({:safe, "<p>lolwat</p>"})
      {:safe, "<p>lolwat</p>"}
      iex> Template.content({{:safe, "<p>lolwat</p>"}, []})
      {:safe, "<p>lolwat</p>"}
  """
  def content({:safe, _} = content), do: content
  def content({content, _attrs}), do: content
  def content(content), do: content

  @doc """
  Extract attributes from a data property

      iex> Template.attributes({"", href: "https://google.com", rel: "nofollow"}, [])
      {:safe, ~S(href="https://google.com" rel="nofollow")}
      iex> Template.attributes([href: "/"], [{"data-prop", "link"}])
      {:safe, ~S(href="/" data-prop="link")}
      iex> Template.attributes([{"foo", href: "/"}], [{"data-prop", "link"}])
      {:safe, ~S(data-prop="link")}
      iex> Template.attributes("lolwat", [{"data-prop", "joke"}])
      {:safe, ~S(data-prop="joke")}
      iex> Template.attributes({:safe, "lolwat"}, [{"lol", "wat"}])
      {:safe, ~S(lol="wat")}
  """
  def attributes({:safe, _content}, elem_attrs), do: build_attrs(elem_attrs)
  def attributes({_content, data_attrs}, elem_attrs) do
    build_attrs(data_attrs ++ elem_attrs)
  end
  def attributes([{key,_value}|_rest] = data_attrs, elem_attrs) when is_atom(key) do
    build_attrs(data_attrs ++ elem_attrs)
  end
  def attributes(_data, elem_attrs), do: build_attrs(elem_attrs)

  defp build_attrs(attributes) do
    Enum.map_join(attributes, " ", &build_attr/1)
    |> Phoenix.HTML.raw
  end

  defp build_attr({attribute, value}) do
    ~s(#{escape attribute}="#{escape value}")
  end

  defp escape(value) do
    value |> Phoenix.HTML.html_escape |> Phoenix.HTML.safe_to_string
  end
end
