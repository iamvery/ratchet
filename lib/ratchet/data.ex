defmodule Ratchet.Data do
  @doc """
  Extract content from a data property

      iex> Data.content("text")
      "text"
      iex> Data.content({"text", []})
      "text"
  """
  def content(text) when is_binary(text), do: text
  def content({text, _attributes}), do: text

  @doc """
  Extract attributes from a data property

      iex> Data.attributes({"", href: "https://google.com", rel: "nofollow"}, [])
      ~S(href="https://google.com" rel="nofollow")
      iex> Data.attributes("lolwat", [{"data-prop", "joke"}])
      ~S(data-prop="joke")
  """
  def attributes({_content, data_attrs}, elem_attrs) do
    build_attrs(data_attrs ++ elem_attrs)
  end
  def attributes(_data, elem_attrs), do: build_attrs(elem_attrs)

  defp build_attrs(attributes) do
    Enum.map_join(attributes, " ", &build_attr/1)
  end

  defp build_attr({attribute, value}) do
    ~s(#{attribute}="#{value}")
  end
end
