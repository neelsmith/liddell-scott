# Simple Liddell-Scott lexicon

Interactively search and read content of Liddell and Scott 's *Greek Lexicon* using Julia.

> Prerequisites: [the Julia language](https://julialang.org/downloads/).


## Using a Pluto notebook

Prerequisites: add the Pluto package.  (E.g., from a Julia REPL, `] add Pluto`.)

> ### COMING SOON!


## From a Julia REPL

At a Julia REPL:

```{julia}
julia> include("reader.jl")
```

Read an article identified by ID:


```{julia}
julia> id("n101961") |> Markdown.parse
```

Read articles with lemmas matching a string:

```{julia}
julia> lemma("σχολι" ) |> Markdown.parse
```
> **Tip**: add an optional `initial` argument to limit matches to lemmas beginning with the search string.
>
> ```{julia}
> julia> lemma("σχολιο")
> "# 3 articles with lemma matching *σχολιο*\n\n## *σχολιογράφος*\n\n`urn:cite2:hmt:lsj.chicago_md:n101963`\n\n**σχολιογράφος** [ ᾰ], ὁ, `A` **writer of scholia, commentator**, Sch.Par. A.R. 3.376. \n\n## *προσχόλιον*\n\n`urn:cite2:hmt:lsj.chicago_md:n90378`\n\n**προσχόλιον**, τό, `A` **ante-room of a school**, Gloss. \n\n## *σχόλιον*\n\n`urn:cite2:hmt:lsj.chicago_md:n101964`\n\n**σχόλιον**, τό, (σχολή II) `A` **interpretation, comment**, Cic. *Att.* 16.7.3; σχόλια λέγειν Arr. *Epict.* 3.21.6; esp. **short note, scholium**, Gal. 18(2).847, etc.; σχόλια συναγείρων Luc. *Vit.Auct.* 23, cf. Porph. *Plot.* 3; σ. εἴς τι **on** a book, Marin. *Procl.* 27. `A.II` **tedious speech, lecture**, Hsch., Phot. "
>
> julia> lemma("σχολιο"; initial = true)
> "# 2 articles with lemma matching *σχολιο*\n\n## *σχολιογράφος*\n\n`urn:cite2:hmt:lsj.chicago_md:n101963`\n\n**σχολιογράφος** [ ᾰ], ὁ, `A` **writer of scholia, commentator**, Sch.Par. A.R. 3.376. \n\n## *σχόλιον*\n\n`urn:cite2:hmt:lsj.chicago_md:n101964`\n\n**σχόλιον**, τό, (σχολή II) `A` **interpretation, comment**, Cic. *Att.* 16.7.3; σχόλια λέγειν Arr. *Epict.* 3.21.6; esp. **short note, scholium**, Gal. 18(2).847, etc.; σχόλια συναγείρων Luc. *Vit.Auct.* 23, cf. Porph. *Plot.* 3; σ. εἴς τι **on** a book, Marin. *Procl.* 27. `A.II` **tedious speech, lecture**, Hsch., Phot. "
> ```

Read articles with any text matching a string:

```{julia}
julia> text("scholiast") |> Markdown.parse
```

> **Tip**: if you just want to see how many articles match a term, use any of the above functions without `Markdown.parse`.  Example:
>
> ```{julia}
> julia> text("Lys.")
> "# 2607 articles matching *Lys.*\n\n## *ἀβάκιον*\n\n`urn:cite2:hmt:lsj.chicago_md:n42`\n\n**ἀβάκιον**, τό, `A` = ἄβαξ 1.1a, Lys. *Fr.* 50, Alex. 15.3, Plb. 5.26.13. `A...b` = ἄβαξ 1.1b, Plu. *Cat.Mi.* 90. `A..2` = ἄβαξ I.2, Poll. 10.150. `A..3` pl., **slabs** (?) in theatre, Suid. s.v. ἄβαξι. \n\n## *ἄβυσσος*\n\n`urn:cite2:hmt:lsj.chicago_md:n222`\n\n**ἄβυσσος**, ον, `A` **bottomless, unfathomed**, πηγαί Hdt" ⋯ 6024963 bytes ⋯ "` **short frock** ( ὑπὲρ γονάτων X. *An.* 5.4.13), worn by men, Ar. *Av.* 946, Lys. 10.10, Phld. *Ir.* p.39W., etc.; with a girdle, Pl. *Hp.Mi.* 368c; ὥστε με.. θοἰμάτιον προέσθαι καὶ μικροῦ γυμνὸν ἐν τῷ χ. γενέσθαι D. 21.216, cf. Pl. *Hp.Mi.* 368c : less freq. of women, **shift**, D. 19.197, *IG* 22.1514.12, al.; σχιστὸς χ. Apollod.Com. 12. `A.II` **coat** of an abscess, Archig. ap. Aët. 8.76. "
> ```
>
> An impressive 2607 articles include citations of Lysias!



    

## About the dictionary

The Julia script and Pluto notebook search articles extracted from a digital edition of Liddell and Scott's *Greek Lexicon* in Markdown formatting by Christopher Blackwell, and [freely available on github](https://github.com/Eumaeus/cite_lsj_cex).


## How searching works

The articles are in a simple delimited-text format with a sequence number, an identifying CITE2 URN, a lemma string, and the full article.  Searches for ID or full text match are applied directly to the delimited-text contents.

For searching by lemma, the script and Pluto notebook use a parallel list of lemma forms with alphabetic characters only. This list is created by removing from the following from the lemma form in the full article:

- punctuation characters
- digit characters
- accents
- breathings
- macra and brevia marking vowel quantity



## Working offline

You can download the extracted articles from [here](http://shot.holycross.edu/lexica/lsj-articles.cex), then load them into the variable `articles`:

```julia
julia> articles = read_lsj(remote = false)
```


Download the list of alphabetic lemma forms from [here](http://shot.holycross.edu/lexica/lsj-lemmas-alphabetic.txt), and load them into the variable `lemmas`:

```julia
julia> lemmas = read_lemmas(remote = false)
```