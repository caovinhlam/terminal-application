#!/bin/bash
if gem list bundler -i
then
    echo "Bundler already installed"
    echo "Installing Dependencies"
    bundle install
else
    echo "Installing Bundler"
    gem install bundler
    echo "Installing Dependencies"
    bundle install
fi

ruby main.rb accounts.json tasks_db.json assigned_tasks_db.json