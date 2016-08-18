defmodule JekyllInterface.Repo.Migrations.AddContentToPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :content, :text
    end
  end
end
