defmodule CanaryPoc.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  forward "/user", to: CanaryPoc.Controllers.UserController
  forward "/organization", to: CanaryPoc.Controllers.OrganizationController

  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
