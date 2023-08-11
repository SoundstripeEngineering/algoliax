defmodule Algoliax.Resources.Analytics do
  import Algoliax.Utils, only: [index_name: 2, camelize: 1, format_queries: 1]
  import Algoliax.Client, only: [request: 1]

  def analytics_status do
    request(%{
      action: :analytics_status,
      url_params: []
    })
  end

  def top_searches do
    request(%{
      action: :top_searches,
      url_params: []
    })
  end

  def count_searches do
    request(%{
      action: :count_searches,
      url_params: []
    })
  end

  def no_results do
    request(%{
      action: :no_results,
      url_params: []
    })
  end

  def no_clicks do
    request(%{
      action: :no_clicks,
      url_params: []
    })
  end

  def no_result_rate do
    request(%{
      action: :no_result_rate,
      url_params: []
    })
  end

  def no_click_rate do
    request(%{
      action: :no_click_rate,
      url_params: []
    })
  end

  def top_hits do
    request(%{
      action: :top_hits,
      url_params: []
    })
  end

  def count_users do
    request(%{
      action: :count_users,
      url_params: []
    })
  end

  def top_filters do
    request(%{
      action: :top_filters,
      url_params: []
    })
  end

  def top_filters_no_results do
    request(%{
      action: :top_filters_no_results,
      url_params: []
    })
  end

  def top_filters_for_attributes do
    request(%{
      action: :top_filters_for_attributes,
      url_params: []
    })
  end

  def top_filters_for_attribute do
    request(%{
      action: :top_filters_for_attribute,
      url_params: []
    })
  end

  def top_countries do
    request(%{
      action: :top_countries,
      url_params: []
    })
  end

  def average_click_position do
    request(%{
      action: :average_click_position,
      url_params: []
    })
  end

  def click_positions do
    request(%{
      action: :click_positions,
      url_params: []
    })
  end

  def click_through_rate do
    request(%{
      action: :click_through_rate,
      url_params: []
    })
  end

  def conversion_rate do
    request(%{
      action: :conversion_rate,
      url_params: []
    })
  end
end
