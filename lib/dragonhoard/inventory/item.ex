defmodule Dragonhoard.Inventory.Item do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "items" do
    field :name, :string
    field :description, :string
    field :amount, :integer
    field :extra_info, :string

    belongs_to :owner, Dragonhoard.Accounts.User
    belongs_to :holder, Dragonhoard.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:name, :description, :amount, :extra_info, :owner_id, :holder_id])
    |> validate_required([:name, :description, :amount, :owner_id, :holder_id])
  end
end
