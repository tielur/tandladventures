defmodule TandladventuresWeb.PageController do
  use TandladventuresWeb, :controller
  alias Tandladventures.Repo

  def index(conn, _params) do
    {:ok, posts} = Repo.list()
    render(conn, "index.html", posts: posts)
  end
end
