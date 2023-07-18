defmodule Algoliax.Routes do
  @moduledoc false
  alias Algoliax.Config

  @paths %{
    # Search Endpoints
    search: {"/1/indexes/{index_name}/query", :read, :post},
    search_multiple: {"/1/indexes/*/queries", :read, :post},
    search_facet: {"/1/indexes/{index_name}/facets/{facet_name}/query", :write, :post},
    browse_index_post: {"/1/indexes/{index_name}/browse", :read, :post},
    browse_index_get: {"/1/indexes/{index_name}/browse", :read, :get},
    # Object Endpoints
    add_object: {"/1/indexes/{index_name}", :write, :post},
    save_object: {"/1/indexes/{index_name}/{object_id}", :write, :put},
    delete_object: {"/1/indexes/{index_name}/{object_id}", :write, :delete},
    delete_by: {"/1/indexes/{index_name}/deleteByQuery", :write, :post},
    clear_objects: {"/1/indexes/{index_name}/clear", :write, :post},
    partial_update: {"/1/indexes/{index_name}/{object_id}/partial", :write, :post},
    save_objects: {"/1/indexes/{index_name}/batch", :write, :post},
    save_objects_multiple: {"/1/indexes/*/batch", :write, :post},
    get_objects_multiple: {"/1/indexes/*/objects", :read, :post},
    get_object: {"/1/indexes/{index_name}/{object_id}", :read, :get},
    # Setting Endpoints
    get_settings: {"/1/indexes/{index_name}/settings", :read, :get},
    configure_index: {"/1/indexes/{index_name}/settings", :write, :put},
    # Index Endpoints
    delete_index: {"/1/indexes/{index_name}", :write, :delete},
    move_index: {"/1/indexes/{index_name}/operation", :write, :post},
    list_indices: {"/1/indexes", :read, :get},
    # Synonym Endpoints
    save_synonym: {"/1/indexes/{index_name}/synonyms/{object_id}", :write, :put},
    save_synonyms: {"/1/indexes/{index_name}/synonyms/batch", :write, :post},
    get_synonym: {"/1/indexes/{index_name}/synonyms/{object_id}", :read, :get},
    clear_synonyms: {"/1/indexes/{index_name}/synonyms/clear", :write, :post},
    delete_synonym: {"/1/indexes/{index_name}/synonyms/{object_id}", :write, :delete},
    search_synonyms: {"/1/indexes/{index_name}/synonyms/search", :read, :post},
    # Key Endpoints
    add_api_key: {"/1/keys", :write, :post},
    update_api_key: {"/1/keys/{key}", :write, :put},
    list_api_keys: {"/1/keys", :read, :get},
    get_api_key: {"/1/keys/{key}", :read, :get},
    delete_api_key: {"/1/keys/{key}", :write, :delete},
    restore_api_key: {"/1/keys/{key}/restore", :write, :post},
    add_index_api_key: {"/1/indexes/{index_name}/keys", :write, :post},
    update_index_api_key: {"/1/indexes/{index_name}/keys/{key}", :write, :put},
    list_index_api_keys: {"/1/indexes/{index_name}/keys", :write, :get},
    list_all_index_api_keys: {"/1/indexes/*/keys", :write, :get},
    get_index_api_key: {"/1/indexes/{index_name}/keys/{key}", :write, :get},
    delete_index_api_key: {"/1/indexes/{index_name}/keys/{key}", :write, :delete},
    # Rule Endpoints
    save_rule: {"/1/indexes/{index_name}/rules/{object_id}", :write, :put},
    batch_rules: {"/1/indexes/{index_name}/rules/batch", :write, :post},
    get_rule: {"/1/indexes/{index_name}/rules/{object_id}", :write, :get},
    delete_rule: {"/1/indexes/{index_name}/rules/{object_id}", :write, :delete},
    clear_rules: {"/1/indexes/{index_name}/rules/clear", :write, :post},
    search_rules: {"/1/indexes/{index_name}/rules/search", :write, :post},
    # Dictionary Endpoints
    batch_dictionaries: {"/1/dictionaries/{dictionary_name}/batch", :write, :post},
    search_dictionaries_get: {"/1/dictionaries/{dictionary_name}/search", :write, :get},
    search_dictionaries_post: {"/1/dictionaries/{dictionary_name}/search", :write, :post},
    set_dictionary_settings: {"/1/dictionaries/*/settings", :write, :put},
    get_dictionary_settings: {"/1/dictionaries/*/settings", :write, :get},
    dictionary_languages: {"/1/dictionaries/*/languages", :write, :get},
    # MultiCluster Endpoints
    add_user_to_cluster: {"/1/clusters/mapping", :write, :post},
    add_users_to_cluster: {"/1/clusters/mapping/batch", :write, :post},
    top_users_in_clusters: {"/1/clusters/mapping/top", :write, :get},
    get_user_in_cluster: {"/1/clusters/mapping/{user_id}", :write, :get},
    list_clusters: {"/1/clusters", :write, :get},
    list_users_in_clusters: {"/1/clusters/mapping", :write, :get},
    remove_user_from_cluster: {"/1/clusters/mapping/{user_id}", :write, :delete},
    search_user_in_cluster: {"/1/clusters/mapping/search", :write, :post},
    has_pending_mappings: {"/1/clusters/mapping/pending", :write, :get},
    # Vault Endpoints
    list_allowed_sources: {"/1/security/sources", :read, :get},
    replace_allowed_sources: {"/1/security/sources", :write, :put},
    add_allowed_source: {"/1/security/sources/append", :write, :post},
    delete_allowed_source: {"/1/security/sources/{source_cidr_ip}", :write, :delete},
    # Advanced Endpoints
    get_logs: {"/1/logs", :read, :get},
    task: {"/1/indexes/{index_name}/task/{task_id}", :read, :get}
  }

  def url(action, url_params \\ [], retry \\ 0) do
    {action_path, operation_type, method} =
      @paths
      |> Map.get(action)

    url =
      action_path
      |> build_path(url_params)
      |> build_url(operation_type, retry)

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

  defp build_url(path, :read, 0) do
    url_read()
    |> String.replace(~r/{{application_id}}/, Config.application_id())
    |> Kernel.<>(path)
  end

  defp build_url(path, :write, 0) do
    url_write()
    |> String.replace(~r/{{application_id}}/, Config.application_id())
    |> Kernel.<>(path)
  end

  defp build_url(path, :write, retry) do
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
      "https://{{application_id}}-dsn.algolia.net"
    end

    defp url_write do
      "https://{{application_id}}.algolia.net"
    end

    defp url_retry do
      "https://{{application_id}}-{{retry}}.algolianet.com"
    end
  end
end
