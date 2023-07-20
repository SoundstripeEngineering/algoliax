defmodule Algoliax.GenSearchTest do
  use Algoliax.RequestCase

  alias Algoliax.GenSearch

  test "search_multiple/2" do
    assert GenSearch.search_multiple([%{indexName: "index_1", params: %{query: "foo"}}])
  end
end
