defmodule Algoliax.ApiMockServer do
  @moduledoc false
  require Logger

  use Plug.Router
  use Plug.ErrorHandler

  alias Algoliax.RequestsStore

  import Plug.Conn

  plug(Plug.Parsers,
    parsers: [:json, :urlencoded],
    pass: ["text/*"],
    json_decoder: Jason
  )

  plug(Plug.Logger, log: :debug)
  plug(:match)
  plug(:save_request)
  plug(:dispatch)

  # Search index (POST): https://www.algolia.com/doc/rest-api/search/#search-index-post
  post "/:application_id/:mode/:index_name/query" do
    response = search_response()
    send_resp(conn, 200, Jason.encode!(response))
  end

  # Search multiple indices (POST): https://www.algolia.com/doc/rest-api/search/#search-multiple-indices
  post "/:application_id/:mode/asterisk/query" do
    response = search_multi_response()
    send_resp(conn, 200, Jason.encode!(response))
  end

  # Search index (POST): https://www.algolia.com/doc/rest-api/search/#search-index-post
  post "/:application_id/:mode/:index_name/facets/:facet_name/query" do
    response = search_facet_response()
    send_resp(conn, 200, Jason.encode!(response))
  end

  # get settings: https://www.algolia.com/doc/rest-api/search/#get-settings
  get "/:application_id/:mode/:index_name/settings" do
    response = %{
      searchableAttributes: ["test"]
    }

    send_resp(conn, 200, Jason.encode!(response))
  end

  # set settings: https://www.algolia.com/doc/rest-api/search/#set-settings
  put "/:application_id/:mode/:index_name/settings" do
    response = %{
      updatedAt: DateTime.utc_now(),
      taskID: :rand.uniform(10_000)
    }

    send_resp(conn, 200, Jason.encode!(response))
  end

  @max_retries_before_published 3

  # get tasks info
  get "/:application_id/:mode/:index_name/task/:task_id" do
    task_id = Map.get(conn.params, "task_id")
    retry_count = Algoliax.TaskStore.get(task_id)

    status =
      if retry_count < @max_retries_before_published do
        Algoliax.TaskStore.increment(task_id)
        "notPublished"
      else
        "published"
      end

    response = %{status: status}
    send_resp(conn, 200, Jason.encode!(response))
  end

  # Add/update object (with ID): https://www.algolia.com/doc/rest-api/search/#addupdate-object-with-id
  put "/:application_id/:mode/:index_name/:object_id" do
    response = %{
      updatedAt: DateTime.utc_now(),
      taskID: :rand.uniform(10_000),
      objectID: Map.get(conn.params, "object_id")
    }

    send_resp(conn, 200, Jason.encode!(response))
  end

  # Batch write operations: https://www.algolia.com/doc/rest-api/search/#batch-write-operations
  post "/:application_id/:mode/:index_name/batch" do
    requests = conn.body_params["requests"]

    object_ids =
      Enum.map(requests, fn request ->
        request["body"]["objectID"]
        |> to_string()
      end)

    response = %{
      taskID: :rand.uniform(10_000),
      objectIDs: object_ids
    }

    send_resp(conn, 200, Jason.encode!(response))
  end

  # Copy/move index: https://www.algolia.com/doc/rest-api/search/#copymove-index
  post "/:application_id/:mode/:index_name/operation" do
    response = %{
      updatedAt: "2013-01-18T15:33:13.556Z",
      taskID: 681
    }

    send_resp(conn, 200, Jason.encode!(response))
  end

  # Raise a 403 error
  get "/:application_id/:mode/index_name_not_authorized/:object_id" do
    send_resp(
      conn,
      403,
      Jason.encode!(%{"message" => "Index not allowed with this API key", "status" => 403})
    )
  end

  # Get object: https://www.algolia.com/doc/rest-api/search/#get-object
  get "/:application_id/:mode/:count/:index_name/:object_id" do
    case Map.get(conn.params, "object_id") do
      "known" ->
        response = %{
          objectID: Map.get(conn.params, "object_id")
        }

        send_resp(conn, 200, Jason.encode!(response))

      "error" ->
        send_resp(conn, 500, "Internal server error :(")

      _ ->
        send_resp(conn, 404, Jason.encode!(%{}))
    end
  end

  get "/:application_id/:mode/:index_name/:object_id" do
    case Map.get(conn.params, "object_id") do
      "known" ->
        response = %{
          objectID: Map.get(conn.params, "object_id")
        }

        send_resp(conn, 200, Jason.encode!(response))

      "error" ->
        send_resp(conn, 500, "Internal server error :(")

      _ ->
        send_resp(conn, 404, Jason.encode!(%{}))
    end
  end

  put "/:application_id/write/settings" do
    send_resp(conn, 200, Jason.encode!(%{}))
  end

  get "/:application_id/read/settings" do
    send_resp(conn, 200, Jason.encode!(%{}))
  end

  # Delete object: https://www.algolia.com/doc/rest-api/search/#delete-object
  delete "/:application_id/:mode/:index_name/:object_id" do
    response = %{
      deletedAt: "2013-01-18T15:33:13.556Z",
      taskID: 681
    }

    send_resp(conn, 200, Jason.encode!(response))
  end

  # delete index: https://www.algolia.com/doc/rest-api/search/#delete-index
  delete "/:application_id/:mode/:index_name" do
    send_resp(conn, 200, Jason.encode!(%{}))
  end

  # delete index objects that match a query filter: https://www.algolia.com/doc/rest-api/search/#delete-by
  post "/:application_id/:mode/:index_name/deleteByQuery" do
    response = %{
      "taskID" => 6311,
      "updatedAt" => "2023-02-20T17:45:11.523Z"
    }

    send_resp(conn, 200, Jason.encode!(response))
  end

  match _ do
    Logger.warning(inspect(conn))
    send_resp(conn, 404, "oops")
  end

  defp handle_errors(conn, %{kind: kind, reason: reason, stack: stack}) do
    Logger.warning(kind, label: :kind)
    Logger.warning(reason, label: :reason)
    Logger.warning(stack, label: :stack)
    send_resp(conn, conn.status, "Something went wrong")
  end

  defp save_request(conn, _) do
    RequestsStore.save(%{
      id: :rand.uniform(100_000),
      method: conn.method,
      path: conn.request_path,
      body: conn.body_params
    })

    conn
  end

  defp search_response do
    %{
      hits: [
        %{
          name: "George Clooney",
          objectID: "2051967",
          _highlightResult: %{
            name: %{
              value: "<em>George</em> <em>Clo</em>oney",
              matchLevel: "full"
            }
          },
          _snippetResult: %{
            bio: %{
              value: "is the son of <em>George</em> <em>Clo</em>oney as was his father"
            }
          },
          _rankingInfo: %{
            nbTypos: 0,
            firstMatchedWord: 0,
            proximityDistance: 1,
            userScore: 5,
            geoDistance: 0,
            geoPrecision: 1,
            nbExactWords: 0
          }
        },
        %{
          name: "George Clooney's Irish Roots",
          year: "(2012 Documentary)",
          objectID: "825416",
          _highlightResult: %{
            name: %{
              value: "<em>George</em> <em>Clo</em>oney's Irish Roots",
              matchLevel: "full"
            },
            year: %{
              value: "(2012 Documentary)",
              matchLevel: "none"
            }
          },
          _rankingInfo: %{
            nbTypos: 0,
            firstMatchedWord: 0,
            proximityDistance: 1,
            userScore: 4,
            geoDistance: 0,
            geoPrecision: 1,
            nbExactWords: 0
          }
        }
      ],
      page: 0,
      nbHits: 38,
      nbPages: 19,
      hitsPerPage: 2,
      processingTimeMS: 6,
      query: "george clo",
      parsed_query: "george clo",
      params: "query=george%20clo&hitsPerPage=2&getRankingInfo=1"
    }
  end

  defp search_multi_response do
    %{
      results: [
        %{
          hits: [
            %{
              name: "Betty Jane Mccamey",
              company: "Vita Foods Inc.",
              email: "betty@mccamey.com",
              objectID: "6891Y2usk0",
              _highlightResult: %{
                name: %{
                  value: "Betty <b>Jan</b>e Mccamey",
                  matchLevel: "full"
                },
                company: %{
                  value: "Vita Foods Inc.",
                  matchLevel: "none"
                },
                email: %{
                  value: "betty@mccamey.com",
                  matchLevel: "none"
                }
              }
            }
          ],
          page: 0,
          nbHits: 1,
          nbPages: 1,
          hitsPerPage: 20,
          processingTimeMS: 1,
          query: "van",
          params: "query=van",
          index: "index1"
        },
        %{
          hits: [
            %{
              name: "Gayla Geimer Dan",
              company: "Ortman Mccain Co",
              email: "gayla@geimer.com",
              objectID: "ap78784310",
              _highlightResult: %{
                name: %{
                  value: "Gayla Geimer <b>Dan</b>",
                  matchLevel: "full"
                },
                company: %{
                  value: "Ortman Mccain Co",
                  matchLevel: "none"
                },
                email: %{
                  highlighted: "gayla@geimer.com",
                  matchLevel: "none"
                }
              }
            }
          ],
          page: 0,
          nbHits: 1,
          nbPages: 1,
          hitsPerPage: 20,
          processingTimeMS: 1,
          query: "van",
          params: "query=van",
          index: "index2"
        }
      ]
    }
  end

  defp search_facet_response do
    %{
      facetHits: [
        %{
          value: "Mobile phones",
          highlighted: "Mobile <em>phone</em>s",
          count: 507
        },
        %{
          value: "Phone cases",
          highlighted: "<em>Phone</em> cases",
          count: 63
        }
      ]
    }
  end
end
