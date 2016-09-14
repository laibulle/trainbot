# Trainbot

Trainbot is a Slackbot which check train journey against SNCF API.

## Getting started 

    cp config/secret.exs.dist config/secret.exs
    mix deps.get
    mix run --no-halt


## Commands

Save a journey

    @trainbot enregistre "travail" "admin%3A68000extern" "admin%3A58404extern"



List all my journeys


    @trainbot list



Get journey for a trip


    @trainbot travail

