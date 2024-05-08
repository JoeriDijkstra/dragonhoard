defmodule Dragonhoard.Repo.Migrations.AddUserToItem do
  use Ecto.Migration

  def change do
    alter table(:items) do
      add :owner_id, references(:users, type: :binary_id, on_delete: :delete_all), null: false
      add :holder_id, references(:users, type: :binary_id, on_delete: :delete_all), null: false
    end
  end
end
