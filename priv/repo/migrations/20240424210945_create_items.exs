defmodule Dragonhoard.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :string
      add :amount, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
