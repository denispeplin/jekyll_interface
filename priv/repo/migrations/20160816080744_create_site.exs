defmodule JekyllInterface.Repo.Migrations.CreateSite do
  use Ecto.Migration

  def change do
    create table(:sites) do
      add :fullpath, :string

      timestamps()
    end

  end
end
