defmodule JekyllInterface.SiteController do
  use JekyllInterface.Web, :controller

  alias JekyllInterface.Site

  def index(conn, _params) do
    sites = Repo.all(Site)
    render(conn, "index.html", sites: sites)
  end

  def new(conn, _params) do
    changeset = Site.changeset(%Site{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"site" => site_params}) do
    changeset = Site.changeset(%Site{}, site_params)

    case Repo.insert(changeset) do
      {:ok, site} ->
        conn
        |> put_flash(:info, "Site created successfully.")
        |> redirect(to: site_post_path(conn, :index, site))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    site = Repo.get!(Site, id)
    case JekyllEditor.index(site.fullpath) do
      {:ok, filenames} ->
        render(conn, "show.html", site: site, filenames: filenames)
      {:error, message} ->
        render(conn, "show.html", site: site, error: message)
      end
  end

  def edit(conn, %{"id" => id}) do
    site = Repo.get!(Site, id)
    changeset = Site.changeset(site)
    render(conn, "edit.html", site: site, changeset: changeset)
  end

  def update(conn, %{"id" => id, "site" => site_params}) do
    site = Repo.get!(Site, id)
    changeset = Site.changeset(site, site_params)

    case Repo.update(changeset) do
      {:ok, site} ->
        conn
        |> put_flash(:info, "Site updated successfully.")
        |> redirect(to: site_path(conn, :show, site))
      {:error, changeset} ->
        render(conn, "edit.html", site: site, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    site = Repo.get!(Site, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(site)

    conn
    |> put_flash(:info, "Site deleted successfully.")
    |> redirect(to: site_path(conn, :index))
  end
end
