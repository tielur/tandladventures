defmodule TandladventuresWeb.Router do
  use TandladventuresWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TandladventuresWeb do
    pipe_through :browser

    get "/", PageController, :index

    # Make sure to put this line after any other routes you may already have as it will catch all requests at the first directory level.
    get "/:slug", PostController, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", TandladventuresWeb do
  #   pipe_through :api
  # end
end
