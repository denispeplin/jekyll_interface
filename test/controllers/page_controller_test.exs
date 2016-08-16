defmodule JekyllInterface.PageControllerTest do
  use JekyllInterface.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert redirected_to(conn) == site_path(conn, :index)
  end
end
