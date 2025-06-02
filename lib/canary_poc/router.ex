defmodule CanaryPoc.Router do
  use Plug.Router

  alias CanaryPoc.Models.User

  plug :set_current_user

  plug :match
  plug :dispatch

  forward "/organization", to: CanaryPoc.Controllers.OrganizationController

  match _ do
    send_resp(conn, 404, "Not Found")
  end

  defp set_current_user(conn, _opts) do
    # Simulate fetching the current user from the session or database
    user = %User{
      id: 1,
      name: "Homer Simpson",
      email: "homer@burnsnuclearpower.com",
      roles: ["admin"],
      organization_id: 1
    }
    Plug.Conn.assign(conn, :current_user, user)
  end
end
