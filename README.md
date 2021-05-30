# Text data vizualization

This is my student project for a python programming course at SPbSTU.
The program consists of two parts. RShiny client takes an arbitrary text from user and sends it to a server. A django server extracts the words from the text and encodes each word as a 1x26 vector. Then those codes are passed back to the client, where its' dimensionality is reduced to 1x2. Finally, the codes are plotted on a graph with the words, corresponding to those codes as label. The server part of this project can be found [here](https://github.com/nineleven/textviz-server).

## Installation
Install R from https://www.r-project.org/

Install required R packages with
```
R -e install.packages(c('shiny', 'plotly', 'httr'))
```
## Running locally
First, configure the url address of the API in [config.R](rshiny/config.R)
Then, run
```
R -e shiny::runApp('rshiny/app.R')
```
This should output you the local address of the application.
