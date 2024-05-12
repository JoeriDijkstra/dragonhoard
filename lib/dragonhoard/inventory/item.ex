defmodule Dragonhoard.Inventory.Item do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Dragonhoard.Accounts.User
  alias Dragonhoard.Repo

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
    |> cast(attrs, [
      :name,
      :description,
      :amount,
      :extra_info,
      :owner_id,
      :holder_id
    ])
    |> convert_owner(attrs)
    |> convert_holder(attrs)
    |> validate_required([:name, :description, :amount, :owner_id, :holder_id])
  end

  defp convert_owner(changeset, %{"owner" => owner}) when is_binary(owner) do
    case Repo.get_by(User, email: owner) do
      nil ->
        changeset

      %User{id: user_id} ->
        change(changeset, %{owner_id: user_id})
    end
  end

  defp convert_owner(changeset, _), do: changeset

  defp convert_holder(changeset, %{"holder" => holder}) when is_binary(holder) do
    case Repo.get_by(User, email: holder) do
      nil ->
        changeset

      %User{id: user_id} ->
        change(changeset, %{holder_id: user_id})
    end
  end

  defp convert_holder(changeset, _), do: changeset

  def my_items_query(user_id) do
    from(
      i in __MODULE__,
      where: i.owner_id == ^user_id
    )
  end

  def held_items_query(user_id) do
    from(
      i in __MODULE__,
      where: i.holder_id == ^user_id
    )
  end
end
