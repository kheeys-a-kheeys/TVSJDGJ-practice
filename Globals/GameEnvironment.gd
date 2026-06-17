extends Node
# note to self: remember to credit minesweeper assets from,
# https://uchimama.itch.io/minesweeper-tileset
# y'know, if we can't get assets from anywhere else

var TABLE: Array # Mine/Monster locations based on their levels
var RADAR: Array # Table with adjacency numbers
var CLOTH: Array # Table to determine what tiles are hidden from the player (at the start, the entire thing)
