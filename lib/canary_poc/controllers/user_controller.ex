defmodule CanaryPoc.Controllers.UserController do
  use Plug.Router
  import Canary.Plugs

  require Logger
  alias CanaryPoc.Models.User

  plug :set_canary_action
  plug :set_current_user
  plug :load_and_authorize_resource, model: User

  plug :match
  plug :dispatch

  post "/user" do
    Logger.debug("#{inspect(conn.assigns[:authorized])}")
    send_resp(conn, 200, "User created")
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end

  defp set_current_user(conn, _opts) do
    # Simulate fetching the current user from the session or database
    user = %User{id: 1, role: "admin"} # Example user, replace with actual logic
    Plug.Conn.assign(conn, :current_user, user)
  end

  defp set_canary_action(conn, _opts) do
    case {conn.method, conn.request_path} do
      {"POST", "/user"} -> Plug.Conn.assign(conn, :canary_action, :create)
      _ -> conn
    end
  end
end
