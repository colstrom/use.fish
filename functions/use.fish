function use --argument library
    switch "$library"
        case help --help -h ''
            echo 'usage: use (library|path)' >&2
            false
        case '/*'
            if test -d $library
                if contains $library $fish_function_path
                    true
                else
                    set fish_function_path $library $fish_function_path
                end
            else
                echo $library is not a directory >&2
                return 21
            end
        case '.*'
            use (fish_realpath $library)
        case '*'
            test -z $FISH_LIBRARY_PATH
            and set FISH_LIBRARY_PATH $fish_config/functions.d
            use (fish_realpath (string join / $FISH_LIBRARY_PATH $library))
    end
end
