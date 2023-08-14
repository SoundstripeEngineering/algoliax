defmodule Algoliax.Resources.Analytics do
  import Algoliax.Utils, only: [index_name: 2, camelize: 1]
  import Algoliax.Client, only: [request: 1]

  def analytics_status(module, settings) do
    index = index_name(module, settings)

    request(%{
      action: :analytics_status,
      url_params: [index: index]
    })
  end

  def top_searches(module, settings, url_params \\ []) do
    index = index_name(module, settings)

    request(%{
      action: :top_searches,
      url_params: Keyword.merge([index: index], url_params)
    })
  end

  def count_searches(module, settings, url_params \\ []) do
    index = index_name(module, settings)

    request(%{
      action: :count_searches,
      url_params: Keyword.merge([index: index], url_params)
    })
  end

  def no_results(module, settings, url_params \\ []) do
    index = index_name(module, settings)

    request(%{
      action: :no_results,
      url_params: Keyword.merge([index: index], url_params)
    })
  end

  def no_clicks(module, settings, url_params \\ []) do
    index = index_name(module, settings)

    request(%{
      action: :no_clicks,
      url_params: Keyword.merge([index: index], url_params)
    })
  end

  def no_result_rate(module, settings, url_params \\ []) do
    index = index_name(module, settings)

    request(%{
      action: :no_result_rate,
      url_params: Keyword.merge([index: index], url_params)
    })
  end

  def no_click_rate(module, settings, url_params \\ []) do
    index = index_name(module, settings)

    request(%{
      action: :no_click_rate,
      url_params: Keyword.merge([index: index], url_params)
    })
  end

  def top_hits(module, settings, url_params \\ []) do
    index = index_name(module, settings)

    request(%{
      action: :top_hits,
      url_params: Keyword.merge([index: index], url_params)
    })
  end

  def count_users(module, settings, url_params \\ []) do
    index = index_name(module, settings)

    request(%{
      action: :count_users,
      url_params: Keyword.merge([index: index], url_params)
    })
  end

  def top_filters(module, settings, url_params \\ []) do
    index = index_name(module, settings)

    request(%{
      action: :top_filters,
      url_params: Keyword.merge([index: index], url_params)
    })
  end

  def top_filters_no_results(module, settings, url_params \\ []) do
    index = index_name(module, settings)

    request(%{
      action: :top_filters_no_results,
      url_params: Keyword.merge([index: index], url_params)
    })
  end

  def top_filters_for_attributes(module, settings, url_params \\ []) do
    index = index_name(module, settings)

    request(%{
      action: :top_filters_for_attributes,
      url_params: Keyword.merge([index: index], url_params)
    })
  end

  def top_filters_for_attribute(module, settings, url_params \\ []) do
    index = index_name(module, settings)

    request(%{
      action: :top_filters_for_attribute,
      url_params: Keyword.merge([index: index], url_params)
    })
  end

  def top_countries(module, settings, url_params \\ []) do
    index = index_name(module, settings)

    request(%{
      action: :top_countries,
      url_params: Keyword.merge([index: index], url_params)
    })
  end

  def average_click_position(module, settings, url_params \\ []) do
    index = index_name(module, settings)

    request(%{
      action: :average_click_position,
      url_params: Keyword.merge([index: index], url_params)
    })
  end

  def click_positions(module, settings, url_params \\ []) do
    index = index_name(module, settings)

    request(%{
      action: :click_positions,
      url_params: Keyword.merge([index: index], url_params)
    })
  end

  def click_through_rate(module, settings, url_params \\ []) do
    index = index_name(module, settings)

    request(%{
      action: :click_through_rate,
      url_params: Keyword.merge([index: index], url_params)
    })
  end

  def conversion_rate(module, settings, url_params \\ []) do
    index = index_name(module, settings)

    request(%{
      action: :conversion_rate,
      url_params: Keyword.merge([index: index], url_params)
    })
  end
end
