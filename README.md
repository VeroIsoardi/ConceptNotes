# Concept Notes

A notes app where users organise notes into notebooks and export them as HTML.

Built for *Taller de Tecnologías de Producción de Software* (Ruby track), part of the Analista Programador Universitario degree at UNLP.

![Ruby on Rails 6](https://img.shields.io/badge/Rails_6.1-D30001?style=flat-square&logo=rubyonrails&logoColor=white)
![Tailwind CSS](https://img.shields.io/badge/Tailwind_CSS-06B6D4?style=flat-square&logo=tailwindcss&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=flat-square&logo=mysql&logoColor=white)

![Concept Notes screenshot](https://github.com/user-attachments/assets/ae7307e0-9938-40b0-b446-5b97b392972b)

## Features

- Sign up, log in and edit your account (authentication with Sorcery).
- Create, rename, export and delete notebooks.
- Create, edit, export and delete notes.
- Export every note at once.

## Stack

Ruby 2.7 · Rails 6.1 · MySQL · Sorcery · Tailwind CSS

## Setup

The app lives in [`Concept/`](Concept/).

```bash
cd Concept
bundle install
yarn install
rails db:create db:migrate db:seed
rails server
```
