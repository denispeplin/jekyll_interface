defmodule JekyllInterface.SiteTest do
  use JekyllInterface.ModelCase

  alias JekyllInterface.Site

  @valid_attrs %{fullpath: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Site.changeset(%Site{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Site.changeset(%Site{}, @invalid_attrs)
    refute changeset.valid?
  end
end
