defmodule JekyllInterface.Repo.Migrations.CreatePost do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :filename, :string
      add :site_id, references(:sites, on_delete: :nothing)

      timestamps()
    end
    create index(:posts, [:site_id])

  end
end
