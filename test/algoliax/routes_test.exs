defmodule Algoliax.RoutesTest do
  use ExUnit.Case, async: true

  alias Algoliax.Resources.Object
  alias Algoliax.Routes

  @index_name :algolia_index

  setup do
    Application.put_env(:algoliax, :application_id, "APPLICATION_ID")

    people = %{objectID: 10}

    {:ok, %{people: people}}
  end

  describe "First attempts" do
    # Search Endpoints
    test "url search" do
      assert Routes.url(:search, index_name: @index_name) ==
               {:post, "http://localhost:8002/APPLICATION_ID/read/1/indexes/algolia_index/query"}
    end

    test "url search_multiple" do
      assert Routes.url(:search_multiple) ==
               {:post, "http://localhost:8002/APPLICATION_ID/read/1/indexes/*/queries"}
    end

    test "url search_facet" do
      assert Routes.url(:search_facet, index_name: @index_name, facet_name: "test") ==
               {:post,
                "http://localhost:8002/APPLICATION_ID/write/1/indexes/algolia_index/facets/test/query"}
    end

    test "url browse_index_post" do
      assert Routes.url(:browse_index_post, index_name: @index_name) ==
               {:post, "http://localhost:8002/APPLICATION_ID/read/1/indexes/algolia_index/browse"}
    end

    test "url browse_index_get" do
      assert Routes.url(:browse_index_get, index_name: @index_name) ==
               {:get, "http://localhost:8002/APPLICATION_ID/read/1/indexes/algolia_index/browse"}
    end

    # Object Endpoints
    test "url add_object" do
      assert Routes.url(:add_object, index_name: @index_name) ==
               {:post, "http://localhost:8002/APPLICATION_ID/write/1/indexes/algolia_index"}
    end

    test "url save_object" do
      assert Routes.url(:save_object, index_name: @index_name, object_id: 10) ==
               {:put, "http://localhost:8002/APPLICATION_ID/write/1/indexes/algolia_index/10"}
    end

    test "url delete_object" do
      assert Routes.url(:delete_object, index_name: @index_name, object_id: 10) ==
               {:delete, "http://localhost:8002/APPLICATION_ID/write/1/indexes/algolia_index/10"}
    end

    test "url delete_by" do
      assert Routes.url(:delete_by, index_name: @index_name) ==
               {:post,
                "http://localhost:8002/APPLICATION_ID/write/1/indexes/algolia_index/deleteByQuery"}
    end

    test "url clear_objects" do
      assert Routes.url(:clear_objects, index_name: @index_name) ==
               {:post, "http://localhost:8002/APPLICATION_ID/write/1/indexes/algolia_index/clear"}
    end

    test "url partial_update" do
      assert Routes.url(:partial_update, index_name: @index_name, object_id: 10) ==
               {:post,
                "http://localhost:8002/APPLICATION_ID/write/1/indexes/algolia_index/10/partial"}
    end

    test "url save_objects" do
      assert Routes.url(:save_objects, index_name: @index_name) ==
               {:post, "http://localhost:8002/APPLICATION_ID/write/1/indexes/algolia_index/batch"}
    end

    test "url save_objects_multiple" do
      assert Routes.url(:save_objects_multiple) ==
               {:post, "http://localhost:8002/APPLICATION_ID/write/1/indexes/*/batch"}
    end

    test "url get_objects_multiple" do
      assert Routes.url(:get_objects_multiple) ==
               {:post, "http://localhost:8002/APPLICATION_ID/read/1/indexes/*/objects"}
    end

    test "url get_object" do
      assert Routes.url(:get_object, index_name: @index_name, object_id: 10) ==
               {:get, "http://localhost:8002/APPLICATION_ID/read/1/indexes/algolia_index/10"}
    end

    # Setting Endpoints
    test "url get_settings" do
      assert Routes.url(:get_settings, index_name: @index_name) ==
               {:get,
                "http://localhost:8002/APPLICATION_ID/read/1/indexes/algolia_index/settings"}
    end

    test "url configure_index" do
      assert Routes.url(:configure_index, index_name: @index_name) ==
               {:put,
                "http://localhost:8002/APPLICATION_ID/write/1/indexes/algolia_index/settings"}
    end

    # Index Endpoints
    test "url delete_index" do
      assert Routes.url(:delete_index, index_name: @index_name) ==
               {:delete, "http://localhost:8002/APPLICATION_ID/write/1/indexes/algolia_index"}
    end

    test "url move_index" do
      assert Routes.url(:move_index, index_name: @index_name) ==
               {:post,
                "http://localhost:8002/APPLICATION_ID/write/1/indexes/algolia_index/operation"}
    end

    test "url list_indices" do
      assert Routes.url(:list_indices) ==
               {:get, "http://localhost:8002/APPLICATION_ID/read/1/indexes"}
    end

    # Synonym Endpoints
    test "url save_synonym" do
      assert Routes.url(:save_synonym, index_name: @index_name, object_id: 10) ==
               {:put,
                "http://localhost:8002/APPLICATION_ID/write/1/indexes/algolia_index/synonyms/10"}
    end

    test "url save_synonyms" do
      assert Routes.url(:save_synonyms, index_name: @index_name) ==
               {:post,
                "http://localhost:8002/APPLICATION_ID/write/1/indexes/algolia_index/synonyms/batch"}
    end

    test "url get_synonym" do
      assert Routes.url(:get_synonym, index_name: @index_name, object_id: 10) ==
               {:get,
                "http://localhost:8002/APPLICATION_ID/read/1/indexes/algolia_index/synonyms/10"}
    end

    test "url clear_synonyms" do
      assert Routes.url(:clear_synonyms, index_name: @index_name) ==
               {:post,
                "http://localhost:8002/APPLICATION_ID/write/1/indexes/algolia_index/synonyms/clear"}
    end

    test "url delete_synonym" do
      assert Routes.url(:delete_synonym, index_name: @index_name, object_id: 10) ==
               {:delete,
                "http://localhost:8002/APPLICATION_ID/write/1/indexes/algolia_index/synonyms/10"}
    end

    test "url search_synonyms" do
      assert Routes.url(:search_synonyms, index_name: @index_name) ==
               {:post,
                "http://localhost:8002/APPLICATION_ID/read/1/indexes/algolia_index/synonyms/search"}
    end

    # Key Endpoints
    test "url add_api_key" do
      assert Routes.url(:add_api_key) ==
               {:post, "http://localhost:8002/APPLICATION_ID/write/1/keys"}
    end

    test "url update_api_key" do
      assert Routes.url(:update_api_key, key: "test") ==
               {:put, "http://localhost:8002/APPLICATION_ID/write/1/keys/test"}
    end

    test "url list_api_keys" do
      assert Routes.url(:list_api_keys) ==
               {:get, "http://localhost:8002/APPLICATION_ID/read/1/keys"}
    end

    test "url get_api_key" do
      assert Routes.url(:get_api_key, key: "test") ==
               {:get, "http://localhost:8002/APPLICATION_ID/read/1/keys/test"}
    end

    test "url delete_api_key" do
      assert Routes.url(:delete_api_key, key: "test") ==
               {:delete, "http://localhost:8002/APPLICATION_ID/write/1/keys/test"}
    end

    test "url restore_api_key" do
      assert Routes.url(:restore_api_key, key: "test") ==
               {:post, "http://localhost:8002/APPLICATION_ID/write/1/keys/test/restore"}
    end

    test "url add_index_api_key" do
      assert Routes.url(:add_index_api_key, index_name: @index_name) ==
               {:post, "http://localhost:8002/APPLICATION_ID/write/1/indexes/algolia_index/keys"}
    end

    test "url update_index_api_key" do
      assert Routes.url(:update_index_api_key, index_name: @index_name, key: "test") ==
               {:put,
                "http://localhost:8002/APPLICATION_ID/write/1/indexes/algolia_index/keys/test"}
    end

    test "url list_index_api_keys" do
      assert Routes.url(:list_index_api_keys, index_name: @index_name) ==
               {:get, "http://localhost:8002/APPLICATION_ID/write/1/indexes/algolia_index/keys"}
    end

    test "url list_all_index_api_keys" do
      assert Routes.url(:list_all_index_api_keys) ==
               {:get, "http://localhost:8002/APPLICATION_ID/write/1/indexes/*/keys"}
    end

    test "url get_index_api_key" do
      assert Routes.url(:get_index_api_key, index_name: @index_name, key: "test") ==
               {:get,
                "http://localhost:8002/APPLICATION_ID/write/1/indexes/algolia_index/keys/test"}
    end

    test "url delete_index_api_key" do
      assert Routes.url(:delete_index_api_key, index_name: @index_name, key: "test") ==
               {:delete,
                "http://localhost:8002/APPLICATION_ID/write/1/indexes/algolia_index/keys/test"}
    end

    # Rule Endpoints
    test "url save_rule" do
      assert Routes.url(:save_rule, index_name: @index_name, object_id: 10) ==
               {:put,
                "http://localhost:8002/APPLICATION_ID/write/1/indexes/algolia_index/rules/10"}
    end

    test "url batch_rules" do
      assert Routes.url(:batch_rules, index_name: @index_name) ==
               {:post,
                "http://localhost:8002/APPLICATION_ID/write/1/indexes/algolia_index/rules/batch"}
    end

    test "url get_rule" do
      assert Routes.url(:get_rule, index_name: @index_name, object_id: 10) ==
               {:get,
                "http://localhost:8002/APPLICATION_ID/write/1/indexes/algolia_index/rules/10"}
    end

    test "url delete_rule" do
      assert Routes.url(:delete_rule, index_name: @index_name, object_id: 10) ==
               {:delete,
                "http://localhost:8002/APPLICATION_ID/write/1/indexes/algolia_index/rules/10"}
    end

    test "url clear_rules" do
      assert Routes.url(:clear_rules, index_name: @index_name) ==
               {:post,
                "http://localhost:8002/APPLICATION_ID/write/1/indexes/algolia_index/rules/clear"}
    end

    test "url search_rules" do
      assert Routes.url(:search_rules, index_name: @index_name) ==
               {:post,
                "http://localhost:8002/APPLICATION_ID/write/1/indexes/algolia_index/rules/search"}
    end

    # Dictionary Endpoints
    test "url batch_dictionaries" do
      assert Routes.url(:batch_dictionaries, dictionary_name: "test") ==
               {:post, "http://localhost:8002/APPLICATION_ID/write/1/dictionaries/test/batch"}
    end

    test "url search_dictionaries_get" do
      assert Routes.url(:search_dictionaries_get, dictionary_name: "test") ==
               {:get, "http://localhost:8002/APPLICATION_ID/write/1/dictionaries/test/search"}
    end

    test "url search_dictionaries_post" do
      assert Routes.url(:search_dictionaries_post, dictionary_name: "test") ==
               {:post, "http://localhost:8002/APPLICATION_ID/write/1/dictionaries/test/search"}
    end

    test "url set_dictionary_settings" do
      assert Routes.url(:set_dictionary_settings) ==
               {:put, "http://localhost:8002/APPLICATION_ID/write/1/dictionaries/*/settings"}
    end

    test "url get_dictionary_settings" do
      assert Routes.url(:get_dictionary_settings) ==
               {:get, "http://localhost:8002/APPLICATION_ID/write/1/dictionaries/*/settings"}
    end

    test "url dictionary_languages" do
      assert Routes.url(:dictionary_languages) ==
               {:get, "http://localhost:8002/APPLICATION_ID/write/1/dictionaries/*/languages"}
    end

    # MultiCluster Endpoints
    test "url add_user_to_cluster" do
      assert Routes.url(:add_user_to_cluster) ==
               {:post, "http://localhost:8002/APPLICATION_ID/write/1/clusters/mapping"}
    end

    test "url add_users_to_cluster" do
      assert Routes.url(:add_users_to_cluster) ==
               {:post, "http://localhost:8002/APPLICATION_ID/write/1/clusters/mapping/batch"}
    end

    test "url top_users_in_clusters" do
      assert Routes.url(:top_users_in_clusters) ==
               {:get, "http://localhost:8002/APPLICATION_ID/write/1/clusters/mapping/top"}
    end

    test "url get_user_in_cluster" do
      assert Routes.url(:get_user_in_cluster, user_id: 10) ==
               {:get, "http://localhost:8002/APPLICATION_ID/write/1/clusters/mapping/10"}
    end

    test "url list_clusters" do
      assert Routes.url(:list_clusters) ==
               {:get, "http://localhost:8002/APPLICATION_ID/write/1/clusters"}
    end

    test "url list_users_in_clusters" do
      assert Routes.url(:list_users_in_clusters) ==
               {:get, "http://localhost:8002/APPLICATION_ID/write/1/clusters/mapping"}
    end

    test "url remove_user_from_cluster" do
      assert Routes.url(:remove_user_from_cluster, user_id: 10) ==
               {:delete, "http://localhost:8002/APPLICATION_ID/write/1/clusters/mapping/10"}
    end

    test "url search_user_in_cluster" do
      assert Routes.url(:search_user_in_cluster) ==
               {:post, "http://localhost:8002/APPLICATION_ID/write/1/clusters/mapping/search"}
    end

    test "url has_pending_mappings" do
      assert Routes.url(:has_pending_mappings) ==
               {:get, "http://localhost:8002/APPLICATION_ID/write/1/clusters/mapping/pending"}
    end

    # Vault Endpoints
    test "url list_allowed_sources" do
      assert Routes.url(:list_allowed_sources) ==
               {:get, "http://localhost:8002/APPLICATION_ID/read/1/security/sources"}
    end

    test "url replace_allowed_sources" do
      assert Routes.url(:replace_allowed_sources) ==
               {:put, "http://localhost:8002/APPLICATION_ID/write/1/security/sources"}
    end

    test "url add_allowed_source" do
      assert Routes.url(:add_allowed_source) ==
               {:post, "http://localhost:8002/APPLICATION_ID/write/1/security/sources/append"}
    end

    test "url delete_allowed_source" do
      assert Routes.url(:delete_allowed_source, source_cidr_ip: "test") ==
               {:delete, "http://localhost:8002/APPLICATION_ID/write/1/security/sources/test"}
    end

    # Advanced Endpoints
    test "url get_logs" do
      assert Routes.url(:get_logs) ==
               {:get, "http://localhost:8002/APPLICATION_ID/read/1/logs"}
    end

    test "url task" do
      assert Routes.url(:task, index_name: @index_name, task_id: 10) ==
               {:get, "http://localhost:8002/APPLICATION_ID/read/1/indexes/algolia_index/task/10"}
    end

    # Analytics Status Endpoint
    test "url analytics_status" do
      assert Routes.url(:analytics_status) ==
               {:get, "http://localhost:8003/analytics/2/status"}
    end

    # Search Analytics Endpoints
    test "url top_searches" do
      assert Routes.url(:top_searches) ==
               {:get, "http://localhost:8003/analytics/2/searches"}
    end

    test "url count_searches" do
      assert Routes.url(:count_searches) ==
               {:get, "http://localhost:8003/analytics/2/searches/count"}
    end

    test "url no_results" do
      assert Routes.url(:no_results) ==
               {:get, "http://localhost:8003/analytics/2/searches/noResults"}
    end

    test "url no_clicks" do
      assert Routes.url(:no_clicks) ==
               {:get, "http://localhost:8003/analytics/2/searches/noClicks"}
    end

    test "url no_result_rate" do
      assert Routes.url(:no_result_rate) ==
               {:get, "http://localhost:8003/analytics/2/searches/noResultRate"}
    end

    test "url no_click_rate" do
      assert Routes.url(:no_click_rate) ==
               {:get, "http://localhost:8003/analytics/2/searches/noClickRate"}
    end

    test "url top_hits" do
      assert Routes.url(:top_hits) ==
               {:get, "http://localhost:8003/analytics/2/hits"}
    end

    test "url count_users" do
      assert Routes.url(:count_users) ==
               {:get, "http://localhost:8003/analytics/2/users/count"}
    end

    test "url top_filters" do
      assert Routes.url(:top_filters) ==
               {:get, "http://localhost:8003/analytics/2/filters"}
    end

    test "url top_filters_no_results" do
      assert Routes.url(:top_filters_no_results) ==
               {:get, "http://localhost:8003/analytics/2/filters/noResults"}
    end

    test "url top_filters_for_attributes" do
      assert Routes.url(:top_filters_for_attributes, attribute_list: "foo") ==
               {:get, "http://localhost:8003/analytics/2/filters/foo"}
    end

    test "url top_filters_for_attribute" do
      assert Routes.url(:top_filters_for_attribute, attribute: "foo") ==
               {:get, "http://localhost:8003/analytics/2/filters/foo"}
    end

    test "url top_countries" do
      assert Routes.url(:top_countries) ==
               {:get, "http://localhost:8003/analytics/2/countries"}
    end

    # Click Analytics Endpoints
    test "url average_click_position" do
      assert Routes.url(:average_click_position) ==
               {:get, "http://localhost:8003/analytics/2/clicks/averageClickPosition"}
    end

    test "url click_positions" do
      assert Routes.url(:click_positions) ==
               {:get, "http://localhost:8003/analytics/2/clicks/positions"}
    end

    test "url click_through_rate" do
      assert Routes.url(:click_through_rate) ==
               {:get, "http://localhost:8003/analytics/2/clicks/clickThroughRate"}
    end

    # Conversion Analytics Endpoints
    test "url conversion_rate" do
      assert Routes.url(:conversion_rate) ==
               {:get, "http://localhost:8003/analytics/2/conversions/conversionRate"}
    end
  end

  describe "First retry" do
    # Search Endpoints
    test "url search" do
      assert Routes.url(:search, [index_name: @index_name], 1) ==
               {:post,
                "http://localhost:8002/APPLICATION_ID/1-retry/1/indexes/algolia_index/query"}
    end

    test "url search_multiple" do
      assert Routes.url(:search_multiple, [], 1) ==
               {:post, "http://localhost:8002/APPLICATION_ID/1-retry/1/indexes/*/queries"}
    end

    test "url search_facet" do
      assert Routes.url(:search_facet, [index_name: @index_name, facet_name: "test"], 1) ==
               {:post,
                "http://localhost:8002/APPLICATION_ID/1-retry/1/indexes/algolia_index/facets/test/query"}
    end

    test "url browse_index_post" do
      assert Routes.url(:browse_index_post, [index_name: @index_name], 1) ==
               {:post,
                "http://localhost:8002/APPLICATION_ID/1-retry/1/indexes/algolia_index/browse"}
    end

    test "url browse_index_get" do
      assert Routes.url(:browse_index_get, [index_name: @index_name], 1) ==
               {:get,
                "http://localhost:8002/APPLICATION_ID/1-retry/1/indexes/algolia_index/browse"}
    end

    # Object Endpoints
    test "url add_object" do
      assert Routes.url(:add_object, [index_name: @index_name], 1) ==
               {:post, "http://localhost:8002/APPLICATION_ID/1-retry/1/indexes/algolia_index"}
    end

    test "url save_object" do
      assert Routes.url(:save_object, [index_name: @index_name, object_id: 10], 1) ==
               {:put, "http://localhost:8002/APPLICATION_ID/1-retry/1/indexes/algolia_index/10"}
    end

    test "url delete_object" do
      assert Routes.url(:delete_object, [index_name: @index_name, object_id: 10], 1) ==
               {:delete,
                "http://localhost:8002/APPLICATION_ID/1-retry/1/indexes/algolia_index/10"}
    end

    test "url delete_by" do
      assert Routes.url(:delete_by, [index_name: @index_name], 1) ==
               {:post,
                "http://localhost:8002/APPLICATION_ID/1-retry/1/indexes/algolia_index/deleteByQuery"}
    end

    test "url clear_objects" do
      assert Routes.url(:clear_objects, [index_name: @index_name], 1) ==
               {:post,
                "http://localhost:8002/APPLICATION_ID/1-retry/1/indexes/algolia_index/clear"}
    end

    test "url partial_update" do
      assert Routes.url(:partial_update, [index_name: @index_name, object_id: 10], 1) ==
               {:post,
                "http://localhost:8002/APPLICATION_ID/1-retry/1/indexes/algolia_index/10/partial"}
    end

    test "url save_objects" do
      assert Routes.url(:save_objects, [index_name: @index_name], 1) ==
               {:post,
                "http://localhost:8002/APPLICATION_ID/1-retry/1/indexes/algolia_index/batch"}
    end

    test "url save_objects_multiple" do
      assert Routes.url(:save_objects_multiple, [], 1) ==
               {:post, "http://localhost:8002/APPLICATION_ID/1-retry/1/indexes/*/batch"}
    end

    test "url get_objects_multiple" do
      assert Routes.url(:get_objects_multiple, [], 1) ==
               {:post, "http://localhost:8002/APPLICATION_ID/1-retry/1/indexes/*/objects"}
    end

    test "url get_object" do
      assert Routes.url(:get_object, [index_name: @index_name, object_id: 10], 1) ==
               {:get, "http://localhost:8002/APPLICATION_ID/1-retry/1/indexes/algolia_index/10"}
    end

    # Setting Endpoints
    test "url get_settings" do
      assert Routes.url(:get_settings, [index_name: @index_name], 1) ==
               {:get,
                "http://localhost:8002/APPLICATION_ID/1-retry/1/indexes/algolia_index/settings"}
    end

    test "url configure_index" do
      assert Routes.url(:configure_index, [index_name: @index_name], 1) ==
               {:put,
                "http://localhost:8002/APPLICATION_ID/1-retry/1/indexes/algolia_index/settings"}
    end

    # Index Endpoints
    test "url delete_index" do
      assert Routes.url(:delete_index, [index_name: @index_name], 1) ==
               {:delete, "http://localhost:8002/APPLICATION_ID/1-retry/1/indexes/algolia_index"}
    end

    test "url move_index" do
      assert Routes.url(:move_index, [index_name: @index_name], 1) ==
               {:post,
                "http://localhost:8002/APPLICATION_ID/1-retry/1/indexes/algolia_index/operation"}
    end

    test "url list_indices" do
      assert Routes.url(:list_indices, [], 1) ==
               {:get, "http://localhost:8002/APPLICATION_ID/1-retry/1/indexes"}
    end

    # Synonym Endpoints
    test "url save_synonym" do
      assert Routes.url(:save_synonym, [index_name: @index_name, object_id: 10], 1) ==
               {:put,
                "http://localhost:8002/APPLICATION_ID/1-retry/1/indexes/algolia_index/synonyms/10"}
    end

    test "url save_synonyms" do
      assert Routes.url(:save_synonyms, [index_name: @index_name], 1) ==
               {:post,
                "http://localhost:8002/APPLICATION_ID/1-retry/1/indexes/algolia_index/synonyms/batch"}
    end

    test "url get_synonym" do
      assert Routes.url(:get_synonym, [index_name: @index_name, object_id: 10], 1) ==
               {:get,
                "http://localhost:8002/APPLICATION_ID/1-retry/1/indexes/algolia_index/synonyms/10"}
    end

    test "url clear_synonyms" do
      assert Routes.url(:clear_synonyms, [index_name: @index_name], 1) ==
               {:post,
                "http://localhost:8002/APPLICATION_ID/1-retry/1/indexes/algolia_index/synonyms/clear"}
    end

    test "url delete_synonym" do
      assert Routes.url(:delete_synonym, [index_name: @index_name, object_id: 10], 1) ==
               {:delete,
                "http://localhost:8002/APPLICATION_ID/1-retry/1/indexes/algolia_index/synonyms/10"}
    end

    test "url search_synonyms" do
      assert Routes.url(:search_synonyms, [index_name: @index_name], 1) ==
               {:post,
                "http://localhost:8002/APPLICATION_ID/1-retry/1/indexes/algolia_index/synonyms/search"}
    end

    # Key Endpoints
    test "url add_api_key" do
      assert Routes.url(:add_api_key, [], 1) ==
               {:post, "http://localhost:8002/APPLICATION_ID/1-retry/1/keys"}
    end

    test "url update_api_key" do
      assert Routes.url(:update_api_key, [key: "test"], 1) ==
               {:put, "http://localhost:8002/APPLICATION_ID/1-retry/1/keys/test"}
    end

    test "url list_api_keys" do
      assert Routes.url(:list_api_keys, [], 1) ==
               {:get, "http://localhost:8002/APPLICATION_ID/1-retry/1/keys"}
    end

    test "url get_api_key" do
      assert Routes.url(:get_api_key, [key: "test"], 1) ==
               {:get, "http://localhost:8002/APPLICATION_ID/1-retry/1/keys/test"}
    end

    test "url delete_api_key" do
      assert Routes.url(:delete_api_key, [key: "test"], 1) ==
               {:delete, "http://localhost:8002/APPLICATION_ID/1-retry/1/keys/test"}
    end

    test "url restore_api_key" do
      assert Routes.url(:restore_api_key, [key: "test"], 1) ==
               {:post, "http://localhost:8002/APPLICATION_ID/1-retry/1/keys/test/restore"}
    end

    test "url add_index_api_key" do
      assert Routes.url(:add_index_api_key, [index_name: @index_name], 1) ==
               {:post,
                "http://localhost:8002/APPLICATION_ID/1-retry/1/indexes/algolia_index/keys"}
    end

    test "url update_index_api_key" do
      assert Routes.url(:update_index_api_key, [index_name: @index_name, key: "test"], 1) ==
               {:put,
                "http://localhost:8002/APPLICATION_ID/1-retry/1/indexes/algolia_index/keys/test"}
    end

    test "url list_index_api_keys" do
      assert Routes.url(:list_index_api_keys, [index_name: @index_name], 1) ==
               {:get, "http://localhost:8002/APPLICATION_ID/1-retry/1/indexes/algolia_index/keys"}
    end

    test "url list_all_index_api_keys" do
      assert Routes.url(:list_all_index_api_keys, [], 1) ==
               {:get, "http://localhost:8002/APPLICATION_ID/1-retry/1/indexes/*/keys"}
    end

    test "url get_index_api_key" do
      assert Routes.url(:get_index_api_key, [index_name: @index_name, key: "test"], 1) ==
               {:get,
                "http://localhost:8002/APPLICATION_ID/1-retry/1/indexes/algolia_index/keys/test"}
    end

    test "url delete_index_api_key" do
      assert Routes.url(:delete_index_api_key, [index_name: @index_name, key: "test"], 1) ==
               {:delete,
                "http://localhost:8002/APPLICATION_ID/1-retry/1/indexes/algolia_index/keys/test"}
    end

    # Rule Endpoints
    test "url save_rule" do
      assert Routes.url(:save_rule, [index_name: @index_name, object_id: 10], 1) ==
               {:put,
                "http://localhost:8002/APPLICATION_ID/1-retry/1/indexes/algolia_index/rules/10"}
    end

    test "url batch_rules" do
      assert Routes.url(:batch_rules, [index_name: @index_name], 1) ==
               {:post,
                "http://localhost:8002/APPLICATION_ID/1-retry/1/indexes/algolia_index/rules/batch"}
    end

    test "url get_rule" do
      assert Routes.url(:get_rule, [index_name: @index_name, object_id: 10], 1) ==
               {:get,
                "http://localhost:8002/APPLICATION_ID/1-retry/1/indexes/algolia_index/rules/10"}
    end

    test "url delete_rule" do
      assert Routes.url(:delete_rule, [index_name: @index_name, object_id: 10], 1) ==
               {:delete,
                "http://localhost:8002/APPLICATION_ID/1-retry/1/indexes/algolia_index/rules/10"}
    end

    test "url clear_rules" do
      assert Routes.url(:clear_rules, [index_name: @index_name], 1) ==
               {:post,
                "http://localhost:8002/APPLICATION_ID/1-retry/1/indexes/algolia_index/rules/clear"}
    end

    test "url search_rules" do
      assert Routes.url(:search_rules, [index_name: @index_name], 1) ==
               {:post,
                "http://localhost:8002/APPLICATION_ID/1-retry/1/indexes/algolia_index/rules/search"}
    end

    # Dictionary Endpoints
    test "url batch_dictionaries" do
      assert Routes.url(:batch_dictionaries, [dictionary_name: "test"], 1) ==
               {:post, "http://localhost:8002/APPLICATION_ID/1-retry/1/dictionaries/test/batch"}
    end

    test "url search_dictionaries_get" do
      assert Routes.url(:search_dictionaries_get, [dictionary_name: "test"], 1) ==
               {:get, "http://localhost:8002/APPLICATION_ID/1-retry/1/dictionaries/test/search"}
    end

    test "url search_dictionaries_post" do
      assert Routes.url(:search_dictionaries_post, [dictionary_name: "test"], 1) ==
               {:post, "http://localhost:8002/APPLICATION_ID/1-retry/1/dictionaries/test/search"}
    end

    test "url set_dictionary_settings" do
      assert Routes.url(:set_dictionary_settings, [], 1) ==
               {:put, "http://localhost:8002/APPLICATION_ID/1-retry/1/dictionaries/*/settings"}
    end

    test "url get_dictionary_settings" do
      assert Routes.url(:get_dictionary_settings, [], 1) ==
               {:get, "http://localhost:8002/APPLICATION_ID/1-retry/1/dictionaries/*/settings"}
    end

    test "url dictionary_languages" do
      assert Routes.url(:dictionary_languages, [], 1) ==
               {:get, "http://localhost:8002/APPLICATION_ID/1-retry/1/dictionaries/*/languages"}
    end

    # MultiCluster Endpoints
    test "url add_user_to_cluster" do
      assert Routes.url(:add_user_to_cluster, [], 1) ==
               {:post, "http://localhost:8002/APPLICATION_ID/1-retry/1/clusters/mapping"}
    end

    test "url add_users_to_cluster" do
      assert Routes.url(:add_users_to_cluster, [], 1) ==
               {:post, "http://localhost:8002/APPLICATION_ID/1-retry/1/clusters/mapping/batch"}
    end

    test "url top_users_in_clusters" do
      assert Routes.url(:top_users_in_clusters, [], 1) ==
               {:get, "http://localhost:8002/APPLICATION_ID/1-retry/1/clusters/mapping/top"}
    end

    test "url get_user_in_cluster" do
      assert Routes.url(:get_user_in_cluster, [user_id: 10], 1) ==
               {:get, "http://localhost:8002/APPLICATION_ID/1-retry/1/clusters/mapping/10"}
    end

    test "url list_clusters" do
      assert Routes.url(:list_clusters, [], 1) ==
               {:get, "http://localhost:8002/APPLICATION_ID/1-retry/1/clusters"}
    end

    test "url list_users_in_clusters" do
      assert Routes.url(:list_users_in_clusters, [], 1) ==
               {:get, "http://localhost:8002/APPLICATION_ID/1-retry/1/clusters/mapping"}
    end

    test "url remove_user_from_cluster" do
      assert Routes.url(:remove_user_from_cluster, [user_id: 10], 1) ==
               {:delete, "http://localhost:8002/APPLICATION_ID/1-retry/1/clusters/mapping/10"}
    end

    test "url search_user_in_cluster" do
      assert Routes.url(:search_user_in_cluster, [], 1) ==
               {:post, "http://localhost:8002/APPLICATION_ID/1-retry/1/clusters/mapping/search"}
    end

    test "url has_pending_mappings" do
      assert Routes.url(:has_pending_mappings, [], 1) ==
               {:get, "http://localhost:8002/APPLICATION_ID/1-retry/1/clusters/mapping/pending"}
    end

    # Vault Endpoints
    test "url list_allowed_sources" do
      assert Routes.url(:list_allowed_sources, [], 1) ==
               {:get, "http://localhost:8002/APPLICATION_ID/1-retry/1/security/sources"}
    end

    test "url replace_allowed_sources" do
      assert Routes.url(:replace_allowed_sources, [], 1) ==
               {:put, "http://localhost:8002/APPLICATION_ID/1-retry/1/security/sources"}
    end

    test "url add_allowed_source" do
      assert Routes.url(:add_allowed_source, [], 1) ==
               {:post, "http://localhost:8002/APPLICATION_ID/1-retry/1/security/sources/append"}
    end

    test "url delete_allowed_source" do
      assert Routes.url(:delete_allowed_source, [source_cidr_ip: "test"], 1) ==
               {:delete, "http://localhost:8002/APPLICATION_ID/1-retry/1/security/sources/test"}
    end

    # Advanced Endpoints
    test "url get_logs" do
      assert Routes.url(:get_logs, [], 1) ==
               {:get, "http://localhost:8002/APPLICATION_ID/1-retry/1/logs"}
    end

    test "url task" do
      assert Routes.url(:task, [index_name: @index_name, task_id: 10], 1) ==
               {:get,
                "http://localhost:8002/APPLICATION_ID/1-retry/1/indexes/algolia_index/task/10"}
    end
  end
end
