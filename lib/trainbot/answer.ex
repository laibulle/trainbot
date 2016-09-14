defmodule Trainbot.Answer do
  def get_unknow_journey(message) do
    "<@#{message.user}> Je ne connais pas cette ce trajet"
  end 
end
