defmodule CanaryPoc.Controllers.OrganizationController do
  use Plug.Router

  require Logger

  import CanaryPoc.AccessControl

  plug :match
  plug :dispatch

  get "/:id" do
    conn
      |> has_roles?(["admin", "manager", "employee"])
      |> case do
        %{assigns: %{authorized: true}} ->
          send_resp(conn, 200, "Organization retrieved")
        _ ->
          send_resp(conn, 403, "Forbidden")
      end
  end

  post "/" do
    conn
      |> has_roles?(["admin"])
      |> case do
        %{assigns: %{authorized: true}} ->
          send_resp(conn, 201, "Organization created")
        _ ->
          send_resp(conn, 403, "Forbidden")
      end
  end

  put "/:id" do
    conn
      |> has_roles?(["admin", "manager"])
      |> case do
        %{assigns: %{authorized: true}} ->
          send_resp(conn, 200, "Organization updated")
        _ ->
          send_resp(conn, 403, "Forbidden")
      end
  end

  delete "/:id" do
    conn
      |> has_roles?(["admin"])
      |> case do
        %{assigns: %{authorized: true}} ->
          send_resp(conn, 200, "Organization deleted")
        _ ->
          send_resp(conn, 403, "Forbidden")
      end
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end

end
