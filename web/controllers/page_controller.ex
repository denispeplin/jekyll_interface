defmodule JekyllInterface.PageController do
  use JekyllInterface.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
