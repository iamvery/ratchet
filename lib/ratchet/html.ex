defmodule Ratchet.Html do
  import Kernel, except: [apply: 2]

  @doc """
  Transform a particular scope in the view with data

      iex> Html.transform({"div", [], [{"p", [{"data-scope", "para"}, {"data-prop", "body"}], []}]}, "para", %{"body" => "Hi!"})
      {"div", [], [{"p", [{"data-scope", "para"}, {"data-prop", "body"}], ["Hi!"]}]}
  """
  def transform([], _, _), do: []
  def transform([element|rest], scope, data) do
    [transform(element, scope, data)|transform(rest, scope, data)]
  end
  def transform({tag, attributes, children} = element, scope, data) do
    if scoped?(element, scope) do
      transform(element, data)
    else
      {tag, attributes, List.flatten(transform(children, scope, data))}
    end
  end
  def transform(content, _, _), do: content

  defp scoped?({_tag, attributes, _children}, scope) do
    {"data-scope", scope} in attributes
  end

  @doc """
  Transform an element with data

      iex> Html.transform({"div", [], [{"p", [{"data-prop", "body"}], []}]}, %{"body" => "Hi!"})
      {"div", [], [{"p", [{"data-prop", "body"}], ["Hi!"]}]}
  """
  def transform(_, []), do: []
  def transform(element, [data|rest]) do
    [transform(element, data)|transform(element, rest)]
  end
  def transform({tag, attributes, children} = element, data) do
    case get_property(attributes) do
      {:ok, property} -> apply(element, data[property])
      :error -> {tag, attributes, List.flatten(_transform(children, data))}
    end
  end

  defp _transform([], _), do: []
  defp _transform([child|rest], data) do
    [transform(child, data)|_transform(rest, data)]
  end

  @doc """
  Get the property from a list

      iex> Html.get_property([:foo, :bar, {"data-prop", "wow"}])
      {:ok, "wow"}
      iex> Html.get_property([:foo, :bar, :baz])
      :error
  """
  def get_property(attributes) do
    case List.keyfind(attributes, "data-prop", 0) do
      {"data-prop", property} -> {:ok, property}
      _ -> :error
    end
  end

  @doc """
  Apply content to an element

      iex> Html.apply({"div", [], []}, "Content")
      {"div", [], ["Content"]}

      iex> Html.apply({"p", [], []}, ["one", "two"])
      [{"p", [], ["one"]}, {"p", [], ["two"]}]
  """
  def apply(_, []), do: []
  def apply(element, [content|rest]) do
    [apply(element, content)|apply(element, rest)]
  end

  def apply({tag, attributes, _children}, content) do
    {tag, attributes, [content]}
  end
end
