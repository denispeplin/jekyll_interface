defmodule JekyllInterface.PageControllerTest do
  use JekyllInterface.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "<input type=\"file\" webkitdirectory directory multiple/>"
  end
end
