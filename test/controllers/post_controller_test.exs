defmodule JekyllInterface.PostControllerTest do
  use JekyllInterface.ConnCase

  import Mock

  alias JekyllInterface.Post
  @valid_attrs %{filename: "some content"}
  @invalid_attrs %{filename: ""}

  setup do
    site = insert(:site)
    {:ok, conn: build_conn, site: site}
  end

  test "lists all entries on index", %{conn: conn, site: site} do
    with_mock JekyllEditor, [index: fn(_fullpath) -> {:ok, ["file.md"]} end] do
      conn = get conn, site_post_path(conn, :index, site)
      assert called JekyllEditor.index(site.fullpath)
      assert html_response(conn, 200) =~ "Listing posts"
      assert html_response(conn, 200) =~ "file.md"
    end
  end

  test "renders form for new resources", %{conn: conn, site: site} do
    conn = get conn, site_post_path(conn, :new, site)
    assert html_response(conn, 200) =~ "New post"
  end

  test "creates resource and redirects when data is valid", %{conn: conn, site: site} do
    conn = post conn, site_post_path(conn, :create, site), post: @valid_attrs
    assert redirected_to(conn) == site_post_path(conn, :index, site)
    assert Repo.get_by(Post, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, site: site} do
    conn = post conn, site_post_path(conn, :create, site), post: @invalid_attrs
    assert html_response(conn, 200) =~ "New post"
  end

  test "shows chosen resource", %{conn: conn, site: site} do
    post = insert(:post)
    conn = get conn, site_post_path(conn, :show, site, post)
    assert html_response(conn, 200) =~ "Show post"
    assert html_response(conn, 200) =~ post.filename
  end

  test "renders page not found when id is nonexistent", %{conn: conn, site: site} do
    assert_error_sent 404, fn ->
      get conn, site_post_path(conn, :show, site, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn, site: site} do
    post = insert(:post)
    conn = get conn, site_post_path(conn, :edit, site, post)
    assert html_response(conn, 200) =~ "Edit post"
    assert html_response(conn, 200) =~ post.filename
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn, site: site} do
    post = insert(:post)
    conn = put conn, site_post_path(conn, :update, site, post), post: @valid_attrs
    assert redirected_to(conn) == site_post_path(conn, :show, site, post)
    assert Repo.get_by(Post, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, site: site} do
    post = insert(:post)
    conn = put conn, site_post_path(conn, :update, site, post), post: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit post"
  end

  test "deletes chosen resource", %{conn: conn, site: site} do
    post = insert(:post)
    conn = delete conn, site_post_path(conn, :delete, site, post)
    assert redirected_to(conn) == site_post_path(conn, :index, site)
    refute Repo.get(Post, post.id)
  end
end
