# Trainbot

Trainbot is a Slackbot which check train journey against SNCF API.

## Getting started

    cp config/secret.exs.dist config/secret.exs
    mix deps.get
    mix run --no-halt


## Commands

__Save a journey__

    Enregistre le trajet <nom du trajet> de <gare de départ> à <gare d'arrivée>.


    Enregistre le trajet travail de admin%3A68000extern à admin%3A58404extern.
    Enregistre le trajet maison de admin%3A58404extern à admin%3A68000extern.


__List all my journeys__


    Liste mes trajets.

__Get journey for a trip__


    Horaires pour <nom du trajet>.


__Delete a journey__


	Supprime le trajet <nom du trajet>.
