defmodule JekyllInterface.PostController do
  use JekyllInterface.Web, :controller

  alias JekyllInterface.Site
  alias JekyllInterface.Post

  plug :assign_site

  def index(conn, _params) do
    {:ok, posts} = JekyllEditor.index(conn.assigns[:site].fullpath)
    render(conn, "index.html", site: conn.assigns[:site], posts: posts)
  end

  def new(conn, _params) do
    changeset = Post.changeset(%Post{})
    render(conn, "new.html", site: conn.assigns[:site], changeset: changeset)
  end

  def create(conn, %{"post" => post_params}) do
    changeset = Post.changeset(%Post{}, post_params)

    case Repo.insert(changeset) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: site_post_path(conn, :index, conn.assigns[:site]))
      {:error, changeset} ->
        render(conn, "new.html", site: conn.assigns[:site], changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)
    render(conn, "show.html", site: conn.assigns[:site], post: post)
  end

  def edit(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)
    changeset = Post.changeset(post)
    render(conn, "edit.html", site: conn.assigns[:site], post: post, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Repo.get!(Post, id)
    changeset = Post.changeset(post, post_params)

    case Repo.update(changeset) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: site_post_path(conn, :show, conn.assigns[:site], post))
      {:error, changeset} ->
        render(conn, "edit.html", site: conn.assigns[:site], post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: site_post_path(conn, :index, conn.assigns[:site]))
  end

  defp assign_site(conn, _opts) do
    case conn.params do
      %{"site_id" => site_id} ->
        assign(conn, :site, Repo.get!(Site, site_id))
      _ ->
        conn
    end
  end
end
