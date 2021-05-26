# Text data vizualization

This is my student project for a python programming course at SPbSTU.
The program consists of two parts. RShiny client takes an arbitrary text from user and sends it to a server. A django server extracts the words from the text and encodes each word as a 1x26 vector. Then those codes are passed back to the client, where its' dimensionality is reduced to 1x2. Finally, the codes are plotted on a graph with the words, corresponding to those codes as label.

## Installation
### Python
After cloning the repository, run
```
pip install -r requirement.txt
```
### R
Install R from https://www.r-project.org/

Install required R packages with
```
R -e install.packages(c('shiny', 'plotly', 'httr'))
```
### PostgreSQL
Install PostgreSQL from https://www.postgresql.org/

Create a database that corrsponds to DATABASES dictionary in [textviz/settings.py](textviz/settings.py)

### Setup django
Run
```
python server/manage.py makemigrations
```
and
```
python server/manage.py migrate
```

## Examples
### Running locally
Start a django server with
```
python server/manage.py runserver
```
Run
```
R -e shiny::runApp('rshiny/app.R')
```
This should output you the url address of the appliction.
