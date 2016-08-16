defmodule JekyllInterface.Site do
  use JekyllInterface.Web, :model

  schema "sites" do
    field :fullpath, :string
    has_many :posts, JekyllInterface.Post

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:fullpath])
    |> validate_required([:fullpath])
  end
end
