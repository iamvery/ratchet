defmodule Ratchet.Renderer do
  @moduledoc """
  Renders Ratchet templates
  """

  import Ratchet.Transformer, only: [transform: 1]

  @doc """
  Render template to markup given data

      iex> Renderer.render(~S{<div><p data-prop="txt"></p></div>}, %{txt: "Hi!"})
      ~S{<div><p data-prop="txt">Hi!</p></div>}
  """
  def render(template, data) do
    template
    |> parse
    |> transform
    |> compile
    |> eval(data)
  end

  @doc """
  Parse template to AST

      iex> Renderer.parse("<div></div>")
      {"div", [], []}
  """
  def parse(template) do
    Floki.parse(template)
  end

  @doc """
  Compile markup from AST

      iex> Renderer.compile({"div", [], []})
      "<div></div>"
  """
  def compile(ast) do
    Floki.raw_html(ast)
  end

  defp eval(template, data) do
    EEx.eval_string(template, [data: data], engine: Phoenix.HTML.Engine)
    |> Phoenix.HTML.safe_to_string
  end
end
