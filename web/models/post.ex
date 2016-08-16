defmodule JekyllInterface.Post do
  use JekyllInterface.Web, :model

  schema "posts" do
    field :filename, :string
    belongs_to :site, JekyllInterface.Site

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:filename])
    |> validate_required([:filename])
  end
end
