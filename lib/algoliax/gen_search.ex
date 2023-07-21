defmodule Algoliax.GenSearch do
  @moduledoc """
  Generic (non-index-specific) search functions
  """
  alias Algoliax.Resources.Search

  @doc """
  Search for multiple queries

  ## Example

      iex> Algoliax.GenSearch.search_multiple([%{indexName: "index_1", params: %{query: "jon"}}, %{indexName: "index_2", params: %{query: "bar"}}])
      {:ok,
        %{
          response: %{
            "results" => [
              %{
                "hits" => [
                  %{
                    "_highlightResult" => %{
                      "full_name" => %{
                        "fullyHighlighted" => false,
                        "matchLevel" => "full",
                        "matchedWords" => ["jon"],
                        "value" => "Pierre <em>Jon</em>es"
                      }
                    },
                    "age" => 69,
                    "first_name" => "Pierre",
                    "full_name" => "Pierre Jones",
                    "indexed_at" => 1570908223,
                    "last_name" => "Jones",
                    "objectID" => "b563deb6-2a06-4428-8e5a-ca1ecc08f4e2"
                  },
                  ...
                ],
                "index" => "index_1",
                "hitsPerPage" => 20,
                "nbHits" => 16,
                "nbPages" => 1,
                "page" => 0,
                "params" => "query=jon",
                "processingTimeMS" => 1,
                "query" => "jon"
              },
              %{
                "hits" => [
                  %{
                    "_highlightResult" => %{
                      "full_name" => %{
                        "fullyHighlighted" => false,
                        "matchLevel" => "full",
                        "matchedWords" => ["bar"],
                        "value" => "Glennie <em>Bar</em>nes"
                      }
                    },
                    "age" => 27,
                    "first_name" => "Glennie",
                    "full_name" => "Glennie Barnes",
                    "indexed_at" => 1570908223,
                    "last_name" => "Barnes",
                    "objectID" => "58e8ff8d-2794-41e1-a4ef-6f8db8d432b6"
                  },
                ],
                "index" => "index_2",
                "hitsPerPage" => 20,
                "nbHits" => 16,
                "nbPages" => 1,
                "page" => 0,
                "params" => "query=bar",
                "processingTimeMS" => 1,
                "query" => "bar"
              }
            ]
          }
        }
      }
  """
  @spec search_multiple(queries :: list(), strategy :: String.t()) ::
          {:ok, Algoliax.Response.t()} | {:error, String.t()}
  def search_multiple(queries, strategy \\ "none") do
    Search.search_multiple(queries, strategy)
  end
end
