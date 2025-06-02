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

  def has_organization_access?(%{organization_id: org_id}, organization_id) do
    Logger.debug("Checking organization access: #{inspect(org_id)} for organization: #{organization_id}")
    org_id == organization_id
  end

  def has_organization_access?(conn, organization_id) do
    authorized = has_organization_access?(conn.assigns[:current_user], organization_id)

    if authorized do
      Plug.Conn.assign(conn, :authorized, true)
    else
      Plug.Conn.assign(conn, :authorized, false)
    end
  end

  defmacro protected_route(method, path, roles, organization_id, body) do
    quote do
      Logger.debug("Defining protected route: #{unquote(method)} #{unquote(path)} with roles: #{inspect(unquote(roles))}")
      unquote(method)(unquote(path)) do
        conn = var!(conn)
        current_user = conn.assigns[:current_user]

        roles_authorized = has_any_roles?(current_user, unquote(roles))
        org_authorized = has_organization_access?(current_user, unquote(organization_id))

        if roles_authorized && org_authorized do
          conn = Plug.Conn.assign(conn, :authorized, true)
          unquote(body)
        else
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

  defmacro has_organization_access(organization_id) do
    quote do
      @organization_id unquote(organization_id)
    end
  end

  # HTTP method macros with role protection
  defmacro get_protected(path, do: body) do
    quote do
      protected_route(:get, unquote(path), @roles, @organization_id, unquote(body))
    end
  end

  defmacro post_protected(path, do: body) do
    quote do
      protected_route(:post, unquote(path), @roles, @organization_id, unquote(body))
    end
  end

  defmacro put_protected(path, do: body) do
    quote do
      protected_route(:put, unquote(path), @roles, @organization_id, unquote(body))
    end
  end

  defmacro delete_protected(path, do: body) do
    quote do
      protected_route(:delete, unquote(path), @roles, @organization_id, unquote(body))
    end
  end
end
