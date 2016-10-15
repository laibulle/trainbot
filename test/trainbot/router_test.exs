defmodule Trainbot.JourneyControllerTest do
  use ExUnit.Case
  doctest Trainbot

  test "parse register " do
    assert Trainbot.JourneyController.parse_register("enregistre le trajet travail de Armentieres à Lille Flandres.") == {:ok, %{from: "Armentieres", name: "travail", to: "Lille Flandres"}}
    assert Trainbot.JourneyController.parse_register("Enregistre le trajet maison de admin%3A58404extern à admin%3A68000extern.") == {:ok, %{from: "admin%3A58404extern", name: "maison", to: "admin%3A68000extern"}}
  end

  test "parse delete" do
    assert Trainbot.JourneyController.parse_delete("supprime le trajet travail.") == {:ok, %{name: "travail"}}
  end

  test "parse list" do
    assert Trainbot.JourneyController.parse_list("liste mes trajets.") == {:ok, %{}}
  end

  test "parse schedule" do
    assert Trainbot.JourneyController.parse_schedule("horaires pour maison.") == {:ok, %{name: "maison"}}
  end

end