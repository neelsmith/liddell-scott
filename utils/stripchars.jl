using Orthography, PolytonicGreek
f = "lemmalist.txt"
lemmas = readlines(f)

ortho = literaryGreek()

map(l -> rmbreathing(rmaccents(l, ortho),ortho), lemmas)