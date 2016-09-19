defmodule Ratchet.TemplateTest do
  use ExUnit.Case, async: true
  alias Ratchet.Template
  doctest Template

  describe "property/2" do
    defmodule Foo do
      defstruct bar: nil
    end

    test "properties may be fetched from structs" do
      assert Template.property(%Foo{bar: "baz"}, :bar) == "baz"
    end
  end

  test "attributes names are safe" do
    attributes = Template.attributes(nil, [{~S{onclick="alert('HACKED!')" class}, ""}])

    assert attributes == {:safe, ~S{onclick=&quot;alert(&#39;HACKED!&#39;)&quot; class=""}}
  end

  test "attributes values are safe" do
    attributes = Template.attributes(nil, [{"class", ~S{" onclick="alert('HACKED!')}}])

    assert attributes == {:safe, ~S{class="&quot; onclick=&quot;alert(&#39;HACKED!&#39;)"}}
  end
end
