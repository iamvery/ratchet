defmodule Ratchet.Transformer do
  import Ratchet.EEx

  @doc """
  Build EEx statements from Ratchet AST
  """
  def transform(_, scope \\ "data")

  def transform([], _), do: []
  def transform([child|rest], scope) do
    [transform(child, scope)|transform(rest, scope)]
  end

  def transform(text, _scope) when is_binary(text), do: text
  def transform(element, scope) when is_tuple(element) do
    case get_type(element) do
      :none -> transform_element(element, scope)
      type -> transform_element(type, element, scope)
    end
  end

  @doc """
  Get the "type" of a node. First property or scope is returned.

      iex> Transformer.get_type({"div", [{"data-scope", "foo"}], []})
      {:scope, "foo"}
      iex> Transformer.get_type({"div", [{"data-prop", "bar"}], []})
      {:property, "bar"}
      iex> Transformer.get_type({"div", [{"data-scope", "foo"}, {"data-prop", "bar"}], []})
      {:scope, "foo"}
      iex> Transformer.get_type({"div", [], []})
      :none
  """
  def get_type({_tag, attributes, _children}) do
    Enum.find_value attributes, :none, fn
      {"data-scope", scope} -> {:scope, scope}
      {"data-prop", prop} -> {:property, prop}
      _ -> false
    end
  end

  defp transform_element({:scope, property}, {tag, attributes, children}, scope) do
    children = transform(children, property) |> List.flatten
    [
      eex_comprehension_open(scope, property),
      {tag, attributes, children},
      eex_close,
    ]
  end

  defp transform_element({:property, property}, {tag, attributes, _children}, scope) do
    children = eex(property) |> List.wrap
    [
      eex_comprehension_open(scope, property),
      {tag, attributes, children},
      eex_close,
    ]
  end

  defp transform_element({tag, attributes, children}, scope) do
    children = transform(children, scope) |> List.flatten
    {tag, attributes, children}
  end
end
