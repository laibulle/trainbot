defmodule Trainbot.Answer do
  def journey_already_exists() do
    list = [
      "Ce trajet existe déjà."
    ]
    Enum.random(list)
  end

  def get_unknow_journey() do
    list = [
    	"Je ne connais pas ce trajet.",
    ]
    Enum.random(list)
  end

  def get_done() do
  	list = ["Voilà !", "C'est fait.", "OK"]
  	Enum.random(list)
  end

  def get_do_not_understand() do
  	list = [
  		"Je ne comprend pas.",
  		"Que veux tu dire par là ?",
  		"C'est pas faux.",
  		"La vache, je pige pas un broc de ce que tu racontes.",
  	]
  	Enum.random(list)
  end

  def unknow_journey(name) do
    list = [
      "Tu n'as pas de trajet #{name} enregistré.",
      "#{name} ?",
      "Je ne connais pas le trajet #{name}.",
    ]
    Enum.random(list)
  end

  def waiting_sncf() do
    list = [
      "Attends je demande à la SNCF...",
      "Attends un peu...",
      "Heuuuu...",
    ]
    Enum.random(list)
  end
end
