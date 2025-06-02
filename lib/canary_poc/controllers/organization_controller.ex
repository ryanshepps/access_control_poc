defmodule CanaryPoc.Controllers.OrganizationController do
  use Plug.Router
  use CanaryPoc.AccessControl

  require Logger

  plug :match
  plug :dispatch

  has_any_roles ["admin", "manager", "employee"]
  get_protected "/:id" do
    send_resp(conn, 200, "Organization retrieved")
  end

  has_any_roles ["admin"]
  post_protected "/" do
    send_resp(conn, 201, "Organization created")
  end

  has_any_roles ["admin", "manager"]
  put_protected "/:id" do
    send_resp(conn, 200, "Organization updated")
  end

  has_any_roles ["admin"]
  delete_protected "/:id" do
    send_resp(conn, 200, "Organization deleted")
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end

end
