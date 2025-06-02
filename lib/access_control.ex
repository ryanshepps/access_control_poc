defmodule CanaryPoc.AccessControl do
  require Logger

  defmacro __using__(_opts) do
    quote do
      import CanaryPoc.AccessControl
      import Plug.Router
      Module.register_attribute(__MODULE__, :roles, accumulate: false)
    end
  end

  def has_any_roles?(%{roles: user_roles}, required_roles) do
    Logger.debug("Checking roles: #{inspect(user_roles)} against required roles: #{inspect(required_roles)}")
    Enum.any?(required_roles, fn role -> role in user_roles end)
  end

  def has_any_roles?(conn, required_roles) do
    authorized = has_any_roles?(conn.assigns[:current_user], required_roles)

    if authorized do
      Plug.Conn.assign(conn, :authorized, true)
    else
      Plug.Conn.assign(conn, :authorized, false)
    end
  end

  defmacro protected_route(method, path, roles, body) do
    quote do
      Logger.debug("Defining protected route: #{unquote(method)} #{unquote(path)} with roles: #{inspect(unquote(roles))}")
      unquote(method)(unquote(path)) do
        conn = var!(conn)
        conn
        |> has_any_roles?(unquote(roles))
        |> case do
          %{assigns: %{authorized: true}} ->
            unquote(body)
          _ ->
            send_resp(conn, 403, "Forbidden")
        end
      end
    end
  end

  defmacro has_any_roles(roles) do
    quote do
      @roles unquote(roles)
    end
  end

  # HTTP method macros with role protection
  defmacro get_protected(path, do: body) do
    quote do
      protected_route(:get, unquote(path), @roles, unquote(body))
    end
  end

  defmacro post_protected(path, do: body) do
    quote do
      protected_route(:post, unquote(path), @roles, unquote(body))
    end
  end

  defmacro put_protected(path, do: body) do
    quote do
      protected_route(:put, unquote(path), @roles, unquote(body))
    end
  end

  defmacro delete_protected(path, do: body) do
    quote do
      protected_route(:delete, unquote(path), @roles, unquote(body))
    end
  end
end
