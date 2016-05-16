defmodule Ratchet do
  @doc """
  Transform a scoped element in the view with data

      iex> Ratchet.transform(~S(<div data-scope="article" data-prop="body"></div>), "article", %{"body" => "Wow!"})
      ~S(<div data-scope="article" data-prop="body">Wow!</div>)
  """
  def transform(view, scope, data) do
    tree = Floki.parse(view)
    result = Ratchet.Html.transform(tree, scope, data)
    Floki.raw_html(result)
  end
end
