defmodule TandladventuresWeb.PageController do
  use TandladventuresWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
