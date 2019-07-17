defmodule TandladventuresWeb.PostController do
  use TandladventuresWeb, :controller
  alias Tandladventures.Repo

  def show(conn, %{"slug" => slug}) do
    case Repo.get_by_slug(slug) do
      {:ok, post} -> render(conn, "show.html", post: post)
      :not_found -> not_found(conn)
    end
  end

  def not_found(conn) do
    conn
    |> put_status(:not_found)
    |> render(TandladventuresWeb.ErrorView, "404.html")
  end
end
