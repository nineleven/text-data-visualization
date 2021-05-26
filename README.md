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
install R from https://www.r-project.org/

## Examples
