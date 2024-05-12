defmodule Dragonhoard.Requests.Request do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "requests" do
    field :title, :string
    field :amount, :integer
    field :approved, :boolean

    belongs_to :user, Dragonhoard.Accounts.User
    belongs_to :item, Dragonhoard.Inventory.Item

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(request \\ %__MODULE__{}, attrs) do
    request
    |> cast(attrs, [:title, :amount, :user_id, :item_id])
    |> validate_required([:title, :amount, :user_id, :item_id])
  end

  def approve_changeset(request, approved?) do
    request
    |> cast(%{approved: approved?}, [:approved])
    |> validate_required(:approved)
  end

  def outgoing_query(user_id) do
    from(r in __MODULE__,
      where: r.user_id == ^user_id,
      order_by: [desc: r.inserted_at]
    )
  end

  def only_open_query(query) do
    from(r in query,
      where: is_nil(r.approved)
    )
  end

  def incoming_query(user_id) do
    from(r in __MODULE__,
      join: i in assoc(r, :item),
      where: i.holder_id == ^user_id and is_nil(r.approved),
      order_by: [desc: r.inserted_at]
    )
  end
end
