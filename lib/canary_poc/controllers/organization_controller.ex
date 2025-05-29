defmodule CanaryPoc.Controllers.OrganizationController do
  use Plug.Router
  import Canary.Plugs

  require Logger
  alias CanaryPoc.Models.User
  alias CanaryPoc.Models.Organization

  plug :set_canary_action
  plug :set_current_user
  plug :load_and_authorize_resource, model: Organization

  plug :match
  plug :dispatch

  get "/:id" do
    Logger.debug("#{inspect(conn.assigns[:authorized])}")
    send_resp(conn, 200, "Organization details")
  end

  post "/" do
    Logger.debug("#{inspect(conn.assigns[:authorized])}")
    send_resp(conn, 200, "Organization created")
  end

  put "/:id" do
    Logger.debug("#{inspect(conn.assigns[:authorized])}")
    send_resp(conn, 200, "Organization updated")
  end

  delete "/:id" do
    Logger.debug("#{inspect(conn.assigns[:authorized])}")
    send_resp(conn, 200, "Organization deleted")
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end

  defp set_current_user(conn, _opts) do
    # Simulate fetching the current user from the session
    user = %User{id: 1, role: "admin"}
    Plug.Conn.assign(conn, :current_user, user)
  end

  defp set_canary_action(conn, _opts) do
    case {conn.method, conn.request_path} do
      {"POST", "/organization"} -> Plug.Conn.assign(conn, :canary_action, :create)
      {"GET", "/organization/" <> id} ->
        if String.match?(id, ~r/^\d+$/) do
          Plug.Conn.assign(conn, :canary_action, :show)
        else
          conn
        end
      {"PUT", "/organization/" <> id} ->
        if String.match?(id, ~r/^\d+$/) do
          Plug.Conn.assign(conn, :canary_action, :update)
        else
          conn
        end
      {"DELETE", "/organization/" <> id} ->
        if String.match?(id, ~r/^\d+$/) do
          Plug.Conn.assign(conn, :canary_action, :delete)
        else
          conn
        end
      _ ->
        Logger.debug("No specific action set for #{conn.method} #{conn.request_path}")
        conn
    end
  end
end
