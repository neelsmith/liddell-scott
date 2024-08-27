using Markdown
using Downloads


scriptversion = "1.0.0"
function versioninfo()
    """
    ## Version history:
    
    - **1.0.0**: initial release
    """
end



"""Sort articles following the Blackwell algorithm: exact lemma match comes out on top, then lemma substrings alphabetically sorted, then remaining articles in alphabetical order."""
function blackwell_sort(matches, lemmastring)
	lemmarestring = "([^\\|]+)\\|([^\\|]+)\\|$(lemmastring)(.*)"
	lemmare = Regex(lemmarestring)
	top = filter(s -> occursin(lemmare, s), matches)

	lemmaanyrestring = "([^\\|]+)\\|([^\\|]+)\\|[^\\|]*$(lemmastring)[^\\|]*\\|(.*)"
	lemma_any_re = Regex(lemmaanyrestring)
	middle = filter(s -> occursin(lemma_any_re, s) && ! (occursin(lemmare, s)) , matches)
	
	bottom = filter(s -> (! occursin(lemma_any_re, s)) && (! (occursin(lemmare, s))) , matches)
	
	vcat(top, middle, bottom)
end

"""Read list of alphabetic-only lemmas to search."""
function read_lemmas(f = "lsj-lemmas-alphabetic.txt"; remote = true)
    if remote
        url = "http://shot.holycross.edu/lexica/lsj-lemmas-alphabetic.txt"
        f = Downloads.download(url)
        content = readlines(f)
        rm(f)
        content

    else
        readlines(f)
    end
end


"""Read Liddell-Scott articles."""
function read_lsj(f = "lsj-articles.cex"; remote = true)
    if remote
        url = "http://shot.holycross.edu/lexica/lsj-articles.cex"
        f = Downloads.download(url)
        content = readlines(f)
        rm(f)
        content

    else
        readlines(f)
    end
end


"""Format a list of data lines from delimited-text source as a single Markdown text.
"""
function format(entries)
    formatted = map(entries) do entry
        cols = split(entry,"|")
        urn = cols[2]
        lemma = cols[3]
        text = cols[4]
        string("## *", lemma, "*\n\n`", urn,"`\n\n", text)
    end
    join(formatted, "\n\n")
end

"""Search a list of articles for text matching a string."""
function text(s; articles = articles)
    matches = filter(article -> occursin(s,article), articles)
    formatted = blackwell_sort(matches, s) |> format
    article = length(matches) == 1 ? "article" : "articles"
    hdr = """# $(length(matches)) $(article) matching *$(s)*\n\n""" 
    string(hdr, formatted)
end

"""Search a list of articles for identifying ID matching a string."""
function id(s; articles = articles)
    pttrn = "urn:cite2:hmt:lsj.chicago_md:" * s * "\\|"
    re = Regex(pttrn)
    matches = filter(article -> occursin(re,article), articles)
    formatted = blackwell_sort(matches, s) |> format
    article = length(matches) == 1 ? "article" : "articles"
    hdr = """# $(length(matches)) $(article) for ID *$(s)*\n\n""" 
    string(hdr, formatted)
end

"""Search a list of articles for lemma matching a string,
optionally limiting search to matching the beginning of the lemma.
"""
function lemma(s; lemmas = lemmas, articles = articles, initial = false)
    
    pttrn =  initial ? "^$(s)" : s
    re = Regex(pttrn)
    match_indices = findall(lemm -> occursin(re, lemm), lemmas)
    matches = map(i -> articles[i], match_indices)
    formatted = blackwell_sort(matches, s) |> format
    article = length(matches) == 1 ? "article" : "articles"
    
    hdr = """# $(length(matches)) $(article) with lemma matching *$(s)*\n\n""" 
    string(hdr, formatted)
end



@info("Script version: $(scriptversion)")
@info("To see version info:")
@info("   versioninfo() |> Markdown.parse\n\n")
@info("Downloading Liddell-Scott lexicon...")
try
    global articles = read_lsj()
    @info("Complete.")
catch
    @warn("\nCouldn't download dictionary data.")
    @info("\nIf you have a local copy, you can use it by running:")
    @info("    articles = read_ls(remote = false)\n")
end
@info("")
@info("Downloading list of searchable lemmas...")
try
    global lemmas = read_lemmas()
    @info("Complete.")
catch
    @warn("\nCouldn't download list of lemmas.")
    @info("\nIf you have a local copy, you can use it by running:")
    @info("    lemmas = read_lemmas(remote = false)\n")
end



@info("\nUse one of these to view formatted articles in your REPL.")
@info("\nFind article by ID:")
@info("    id(IDVALUE) |> Markdown.parse\n")
@info("\nFind matching lemma:")
@info("    lemma(STRING) |> Markdown.parse\n")
@info("\nFull-text search:")
@info("    text(STRING) |> Markdown.parse\n")
