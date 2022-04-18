var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = FileUtils","category":"page"},{"location":"#FileUtils","page":"Home","title":"FileUtils","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation for FileUtils.","category":"page"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [FileUtils]","category":"page"},{"location":"#FileUtils.map_filenames","page":"Home","title":"FileUtils.map_filenames","text":"map_filenames(f::Function, path=pwd(); filter_filenames=Returns(true), force=false)\n\nExamples\n\nmap_filenames(filename -> replace(filename, \".txt\" => \".txt.backup\"); filter_filenames=startswith(\"example_\"))\n\n\n\n\n\n","category":"function"},{"location":"#FileUtils.max_version-Tuple{AbstractString}","page":"Home","title":"FileUtils.max_version","text":"max_version(pkgname)\n\nExamples\n\nmax_version(\"ITensors\")\n\n\n\n\n\n","category":"method"},{"location":"#FileUtils.replace_filenames-Tuple{Any, Vararg{Any}}","page":"Home","title":"FileUtils.replace_filenames","text":"replace_filenames(path=pwd(), replacement::Pair{String,String}; filter=Returns(true), force=false)\n\nExamples\n\nreplace_filenames(pwd(), \".txt\" => \".txt.backup\")\n\n\n\n\n\n","category":"method"},{"location":"#FileUtils.replace_in_files-Tuple{Any, Any}","page":"Home","title":"FileUtils.replace_in_files","text":"replace_in_files(path::String, replacement::Pair{String,String}; ignore_dirs=[], recursive=false, showdiffs=true)\n\nExamples\n\nreplace_in_files(\".\", \"@show\" => \"@test\"; recursive=true, ignore_dirs=[\".git\"])\n\n\n\n\n\n","category":"method"}]
}