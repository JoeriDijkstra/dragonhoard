defmodule Dragonhoard.Repo.Migrations.AddExtraInformation do
  use Ecto.Migration

  def change do
    alter table :items do
      add :extra_info, :text
    end
  end
end
