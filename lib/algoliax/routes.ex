defmodule Algoliax.Routes do
  @moduledoc false
  alias Algoliax.Config

  @paths %{
    # Search Endpoints
    search: {"/{index_name}/query", :read, :post},
    search_multiple: {"/*/queries", :read, :post},
    search_facet: {"/{index_name}/facets/{facet_name}/query", :write, :post},
    browse_index_post: {"/{index_name}/browse", :read, :post},
    browse_index_get: {"/{index_name}/browse", :read, :get},
    # Object Endpoints
    add_object: {"/{index_name}", :write, :post},
    save_object: {"/{index_name}/{object_id}", :write, :put},
    delete_object: {"/{index_name}/{object_id}", :write, :delete},
    delete_by: {"/{index_name}/deleteByQuery", :write, :post},
    clear_objects: {"/{index_name}/clear", :write, :post},
    partial_update: {"/{index_name}/{object_id}/partial", :write, :post},
    save_objects: {"/{index_name}/batch", :write, :post},
    save_objects_multiple: {"/*/batch", :write, :post},
    get_objects_multiple: {"/*/objects", :read, :post},
    get_object: {"/{index_name}/{object_id}", :read, :get},
    # Setting Endpoints
    get_settings: {"/{index_name}/settings", :read, :get},
    configure_index: {"/{index_name}/settings", :write, :put},
    # Index Endpoints
    delete_index: {"/{index_name}", :write, :delete},
    move_index: {"/{index_name}/operation", :write, :post},
    list_indices: {"", :read, :get},
    # Synonym Endpoints
    save_synonym: {"/{index_name}/synonyms/{object_id}", :write, :put},
    save_synonyms: {"/{index_name}/synonyms/batch", :write, :post},
    get_synonym: {"/{index_name}/synonyms/{object_id}", :read, :get},
    clear_synonyms: {"/{index_name}/synonyms/clear", :write, :post},
    delete_synonym: {"/{index_name}/synonyms/{object_id}", :write, :delete},
    search_synonyms: {"/{index_name}/synonyms/search", :read, :post},
    # Key Endpoints
    # Rule Endpoints
    # Dictionary Endpoints
    # MultiCluster Endpoints
    # Vault Endpoints
    # Advanced Endpoints
    task: {"/{index_name}/task/{task_id}", :read, :get}
  }

  def url(action, url_params \\ [], retry \\ 0) do
    {action_path, method} =
      @paths
      |> Map.get(action)

    url =
      action_path
      |> build_path(url_params)
      |> build_url(method, retry)

    {method, url}
  end

  defp build_path(path, []), do: path

  defp build_path(path, args) do
    args
    |> Keyword.keys()
    |> Enum.reduce(path, fn key, path ->
      path
      |> String.replace("{#{key}}", "#{Keyword.get(args, key)}")
    end)
  end

  defp build_url(path, :get, 0) do
    url_read()
    |> String.replace(~r/{{application_id}}/, Config.application_id())
    |> Kernel.<>(path)
  end

  defp build_url(path, _method, 0) do
    url_write()
    |> String.replace(~r/{{application_id}}/, Config.application_id())
    |> Kernel.<>(path)
  end

  defp build_url(path, _method, retry) do
    url_retry()
    |> String.replace(~r/{{application_id}}/, Config.application_id())
    |> String.replace(~r/{{retry}}/, to_string(retry))
    |> Kernel.<>(path)
  end

  if Mix.env() == :test do
    defp url_read do
      port = System.get_env("SLACK_MOCK_API_PORT", "8002")
      "http://localhost:#{port}/{{application_id}}/read"
    end

    defp url_write do
      port = System.get_env("SLACK_MOCK_API_PORT", "8002")
      "http://localhost:#{port}/{{application_id}}/write"
    end

    defp url_retry do
      port = System.get_env("SLACK_MOCK_API_PORT", "8002")
      "http://localhost:#{port}/{{application_id}}/retry/{{retry}}"
    end
  else
    defp url_read do
      "https://{{application_id}}-dsn.algolia.net/1/indexes"
    end

    defp url_write do
      "https://{{application_id}}.algolia.net/1/indexes"
    end

    defp url_retry do
      "https://{{application_id}}-{{retry}}.algolianet.com/1/indexes"
    end
  end
end
