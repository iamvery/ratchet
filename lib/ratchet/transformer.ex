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

  defp transform_element({:scope, property}, element, scope) do
    {element, _} = {element, property}
    |> transform_children

    [
      eex_comprehension_open(scope, property),
      element,
      eex_close,
    ]
  end

  defp transform_element({:property, property}, element, scope) do
    {element, _} = {element, property}
    |> transform_content

    [
      eex_comprehension_open(scope, property),
      element,
      eex_close,
    ]
  end

  defp transform_element(element, scope) do
    transform_children({element, scope}) |> elem(0)
  end

  defp transform_children({{tag, attributes, children}, property}) do
    children = transform(children, property) |> List.flatten
    {{tag, attributes, children}, property}
  end

  defp transform_content({{tag, attributes, _children}, property}) do
    children = eex(property) |> List.wrap
    {{tag, attributes, children}, property}
  end
end
