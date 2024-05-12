defmodule Dragonhoard.Repo.Migrations.AddRequestData do
  use Ecto.Migration

  def change do
    alter table(:requests) do
      add :user_id, references(:users, type: :binary_id), null: false
      add :item_id, references(:items, type: :binary_id), null: false
      add :amount, :integer, null: false, default: 1
      add :approved, :boolean, null: true, default: nil
    end
  end
end
