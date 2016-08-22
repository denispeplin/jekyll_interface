defmodule JekyllInterface.SiteControllerTest do
  use JekyllInterface.ConnCase
  import Mock

  alias JekyllInterface.Site
  @valid_attrs %{fullpath: "some content"}
  @invalid_attrs %{fullpath: ""}

  test "lists all entries on index", %{conn: conn} do
    site = insert(:site)
    conn = get conn, site_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing sites"
    assert html_response(conn, 200) =~ site.fullpath
    assert html_response(conn, 200) =~ site_post_path(conn, :index, site)
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, site_path(conn, :new)
    assert html_response(conn, 200) =~ "New site"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, site_path(conn, :create), site: @valid_attrs
    site = Repo.get_by(Site, @valid_attrs)
    assert site
    assert redirected_to(conn) == site_post_path(conn, :index, site)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, site_path(conn, :create), site: @invalid_attrs
    assert html_response(conn, 200) =~ "New site"
  end

  test "shows chosen resource and Jekyll filenames", %{conn: conn} do
    site = insert(:site)
    with_mock JekyllEditor, [index: fn(_fullpath) -> {:ok, ["1.md"]} end] do
      conn = get conn, site_path(conn, :show, site)
      assert called JekyllEditor.index(site.fullpath)
      assert html_response(conn, 200) =~ "Show site"
      assert html_response(conn, 200) =~ site.fullpath
      assert html_response(conn, 200) =~ "1.md"
    end
  end

  test "shows chosen and error for Jekyll if directory is wrong", %{conn: conn} do
    site = insert(:site)
    with_mock JekyllEditor, [index: fn(_fullpath) -> {:error, :enoent} end] do
      conn = get conn, site_path(conn, :show, site)
      assert called JekyllEditor.index(site.fullpath)
      assert html_response(conn, 200) =~ "Show site"
      assert html_response(conn, 200) =~ site.fullpath
      assert html_response(conn, 200) =~ "enoent"
    end
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, site_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    site = insert(:site)
    conn = get conn, site_path(conn, :edit, site)
    assert html_response(conn, 200) =~ "Edit site"
    assert html_response(conn, 200) =~ site.fullpath
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    site = insert(:site)
    conn = put conn, site_path(conn, :update, site), site: @valid_attrs
    assert redirected_to(conn) == site_path(conn, :show, site)
    assert Repo.get_by(Site, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    site = insert(:site)
    conn = put conn, site_path(conn, :update, site), site: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit site"
  end

  test "deletes chosen resource", %{conn: conn} do
    site = insert(:site)
    conn = delete conn, site_path(conn, :delete, site)
    assert redirected_to(conn) == site_path(conn, :index)
    refute Repo.get(Site, site.id)
  end
end
