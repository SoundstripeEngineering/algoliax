defmodule Algoliax.Client do
  @moduledoc false

  require Logger

  alias Algoliax.{Config, Routes}

  def request(request, retry \\ 0)

  def request(_request, 4) do
    {:error, "Failed after 3 attempts"}
  end

  def request(%{action: action, url_params: url_params} = request, retry) do
    body = Map.get(request, :body)
    {method, url} = Routes.url(action, url_params, retry)
    log(action, method, url, body)

    Req.new(
      method: method,
      url: url,
      json: body,
      params: url_params,
      connect_options: [timeout: recv_timeout()],
      retry: fn response ->
        response.body
        |> inspect()
        |> Logger.debug()
        request(request, retry + 1)
        false
      end
    )
    |> Req.Request.put_headers(request_headers())
    |> Req.Request.run_request()
    |> build_response(action)
  end

  defp build_response({%{options: options}, %{status: status, body: body}}, _)
       when status in 200..299 do
    Algoliax.Response.new(body, Map.to_list(options))
  end

  defp build_response({_, %{status: status, body: body}}, action) do
    handle_error(status, body, action)
  end

  defp handle_error(404, response, action) when action in [:get_settings, :get_object] do
    {:error, 404, response}
  end

  defp handle_error(code, response, _action) do
    error = Map.get(response, "message")

    raise Algoliax.AlgoliaApiError, %{code: code, error: error}
  end

  defp request_headers do
    [
      {"X-Algolia-API-Key", Config.api_key()},
      {"X-Algolia-Application-Id", Config.application_id()}
    ]
  end

  defp log(action, method, url, body) do
    action = action |> to_string() |> String.upcase()
    method = method |> to_string() |> String.upcase()
    message = "#{action}: #{method} #{url}"

    message =
      if body do
        message <> ", body: #{inspect(body)}"
      else
        message
      end

    Logger.debug(message)
  end

  defp recv_timeout() do
    Application.get_env(:algoliax, :recv_timeout, 5000)
  end
end
