defmodule Ratchet do
  def transform(view, scope, data) do
    tree = Floki.parse(view)
    result = Ratchet.Html.transform(tree, scope, data)
    Floki.raw_html(result)
  end
end
