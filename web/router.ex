defmodule JekyllInterface.Router do
  use JekyllInterface.Web, :router

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

  scope "/", JekyllInterface do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    resources "/sites", SiteController
    resources "/posts", PostController
  end

  # Other scopes may use custom stacks.
  # scope "/api", JekyllInterface do
  #   pipe_through :api
  # end
end
