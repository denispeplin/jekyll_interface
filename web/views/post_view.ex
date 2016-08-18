defmodule JekyllInterface.PostView do
  use JekyllInterface.Web, :view

  def filename(changeset) do
    {_, file} = Ecto.Changeset.fetch_field(changeset, :filename)
    file
  end
end
