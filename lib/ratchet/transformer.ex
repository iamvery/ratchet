defmodule Ratchet.Transformer do
  import Ratchet.EEx

  @doc """
  Build EEx statements from Ratchet AST
  """
  def transform(_, scope \\ "data")

  def transform([], _), do: []
  def transform([child|rest], scope) do
    [transform(child, scope)|transform(rest, scope)] |> List.flatten
  end

  def transform(text, _scope) when is_binary(text), do: text
  def transform(element, scope) when is_tuple(element) do
    case get_type(element) do
      :none -> transform_children(element, scope)
      type -> transform_element(element, scope, type)
    end
  end

  @doc """
  Get the "type" of a node. First property is returned.

      iex> Transformer.get_type({"div", [{"data-prop", "bar"}], []})
      {:property, "bar"}
      iex> Transformer.get_type({"div", [], []})
      :none
  """
  def get_type({_tag, attributes, _children}) do
    Enum.find_value attributes, :none, fn
      {"data-prop", prop} -> {:property, prop}
      _ -> false
    end
  end

  defp transform_element(element, scope, {_type, property} = type) do
    [
      eex_comprehension_open(scope, property),
      transform_element(element, type),
      eex_close,
    ]
  end

  defp transform_element(element, {:property, property}) do
    {element, property}
    |> transform_attributes
    |> transform_content
    |> elem(0)
  end

  defp transform_children({tag, attributes, children}, property) do
    children = transform(children, property)
    {tag, attributes, children}
  end

  defp transform_content({{tag, attributes, children}, property}) do
    children = eex_content(property, transform(children, property))
    {{tag, attributes, children}, property}
  end

  defp transform_attributes({{tag, attributes, children}, property}) do
    attributes = [eex_attributes(property, attributes)]
    {{tag, attributes, children}, property}
  end
end
