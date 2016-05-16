defmodule Ratchet.Html do
  import Kernel, except: [apply: 2]

  def transform(view, scope, data) do
    Macro.prewalk view, fn
      element when is_tuple(element) ->
        if scoped?(element, scope) do
          transform(element, data)
        else
          element
        end
      element -> element
    end
  end

  defp scoped?({_tag, attributes, _children}, scope) do
    {"data-scope", scope} in attributes
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
