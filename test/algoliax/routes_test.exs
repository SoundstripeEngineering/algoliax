defmodule Algoliax.RoutesTest do
  use ExUnit.Case, async: true

  alias Algoliax.Routes

  @index_name :algolia_index

  setup do
    Application.put_env(:algoliax, :application_id, "APPLICATION_ID")

    people = %{objectID: 10}

    {:ok, %{people: people}}
  end

  describe "First attempts" do
    test "url search" do
      assert Routes.url(:search, index_name: @index_name) ==
               {:post, "http://localhost:8002/APPLICATION_ID/write/algolia_index/query"}
    end

    test "url search_multiple" do
      assert Routes.url(:search_multiple) ==
               {:post, "http://localhost:8002/APPLICATION_ID/write/*/queries"}
    end

    test "url search_facet" do
      assert Routes.url(:search_facet, index_name: @index_name, facet_name: "test") ==
               {:post,
                "http://localhost:8002/APPLICATION_ID/write/algolia_index/facets/test/query"}
    end

    test "url delete_index" do
      assert Routes.url(:delete_index, index_name: @index_name) ==
               {:delete, "http://localhost:8002/APPLICATION_ID/write/algolia_index"}
    end

    test "url move_index" do
      assert Routes.url(:move_index, index_name: @index_name) ==
               {:post, "http://localhost:8002/APPLICATION_ID/write/algolia_index/operation"}
    end

    test "url get_settings" do
      assert Routes.url(:get_settings, index_name: @index_name) ==
               {:get, "http://localhost:8002/APPLICATION_ID/read/algolia_index/settings"}
    end

    test "url configure_index" do
      assert Routes.url(:configure_index, index_name: @index_name) ==
               {:put, "http://localhost:8002/APPLICATION_ID/write/algolia_index/settings"}
    end

    test "url save_objects" do
      assert Routes.url(:save_objects, index_name: @index_name) ==
               {:post, "http://localhost:8002/APPLICATION_ID/write/algolia_index/batch"}
    end

    test "url get_object" do
      assert Routes.url(:get_object, index_name: @index_name, object_id: 10) ==
               {:get, "http://localhost:8002/APPLICATION_ID/read/algolia_index/10"}
    end

    test "url save_object" do
      assert Routes.url(:save_object, index_name: @index_name, object_id: 10) ==
               {:put, "http://localhost:8002/APPLICATION_ID/write/algolia_index/10"}
    end

    test "url delete_object" do
      assert Routes.url(:delete_object, index_name: @index_name, object_id: 10) ==
               {:delete, "http://localhost:8002/APPLICATION_ID/write/algolia_index/10"}
    end

    test "url task" do
      assert Routes.url(:task, index_name: @index_name, task_id: 10) ==
               {:get, "http://localhost:8002/APPLICATION_ID/read/algolia_index/task/10"}
    end

    test "url delete_by" do
      assert Routes.url(:delete_by, index_name: @index_name) ==
               {:post, "http://localhost:8002/APPLICATION_ID/write/algolia_index/deleteByQuery"}
    end
  end

  describe "First retry" do
    test "url search" do
      assert Routes.url(:search, [index_name: @index_name], 1) ==
               {:post, "http://localhost:8002/APPLICATION_ID/retry/1/algolia_index/query"}
    end

    test "url search_multiple" do
      assert Routes.url(:search_multiple, [], 1) ==
               {:post, "http://localhost:8002/APPLICATION_ID/retry/1/*/queries"}
    end

    test "url search_facet" do
      assert Routes.url(:search_facet, [index_name: @index_name, facet_name: "test"], 1) ==
               {:post,
                "http://localhost:8002/APPLICATION_ID/retry/1/algolia_index/facets/test/query"}
    end

    test "url delete_index" do
      assert Routes.url(:delete_index, [index_name: @index_name], 1) ==
               {:delete, "http://localhost:8002/APPLICATION_ID/retry/1/algolia_index"}
    end

    test "url move_index" do
      assert Routes.url(:move_index, [index_name: @index_name], 1) ==
               {:post, "http://localhost:8002/APPLICATION_ID/retry/1/algolia_index/operation"}
    end

    test "url get_settings" do
      assert Routes.url(:get_settings, [index_name: @index_name], 1) ==
               {:get, "http://localhost:8002/APPLICATION_ID/retry/1/algolia_index/settings"}
    end

    test "url configure_index" do
      assert Routes.url(:configure_index, [index_name: @index_name], 1) ==
               {:put, "http://localhost:8002/APPLICATION_ID/retry/1/algolia_index/settings"}
    end

    test "url save_objects" do
      assert Routes.url(:save_objects, [index_name: @index_name], 1) ==
               {:post, "http://localhost:8002/APPLICATION_ID/retry/1/algolia_index/batch"}
    end

    test "url get_object" do
      assert Routes.url(:get_object, [index_name: @index_name, object_id: 10], 1) ==
               {:get, "http://localhost:8002/APPLICATION_ID/retry/1/algolia_index/10"}
    end

    test "url save_object" do
      assert Routes.url(:save_object, [index_name: @index_name, object_id: 10], 1) ==
               {:put, "http://localhost:8002/APPLICATION_ID/retry/1/algolia_index/10"}
    end

    test "url delete_object" do
      assert Routes.url(:delete_object, [index_name: @index_name, object_id: 10], 1) ==
               {:delete, "http://localhost:8002/APPLICATION_ID/retry/1/algolia_index/10"}
    end

    test "url task" do
      assert Routes.url(:task, [index_name: @index_name, task_id: 10], 1) ==
               {:get, "http://localhost:8002/APPLICATION_ID/retry/1/algolia_index/task/10"}
    end

    test "url delete_by" do
      assert Routes.url(:delete_by, [index_name: @index_name], 1) ==
               {:post, "http://localhost:8002/APPLICATION_ID/retry/1/algolia_index/deleteByQuery"}
    end
  end
end
