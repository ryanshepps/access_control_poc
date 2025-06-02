defmodule CanaryPoc.AccessControl do
  require Logger

  def has_roles?(%{roles: user_roles}, required_roles) do
    Logger.debug("checking roles: #{inspect(user_roles)} against required roles: #{inspect(required_roles)}")

    Enum.any?(required_roles, fn role -> role in user_roles end)
  end

  def has_roles?(conn, required_roles) do
    Logger.debug("Checking roles for user: #{inspect(conn.assigns)} against required roles: #{inspect(required_roles)}")
    authorized = has_roles?(conn.assigns[:current_user], required_roles)

    if authorized do
      Plug.Conn.assign(conn, :authorized, true)
    else
      Plug.Conn.assign(conn, :authorized, false)
    end
  end
end
