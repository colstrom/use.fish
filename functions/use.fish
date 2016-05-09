function use --argument module
    switch "$module"
        case help --help -h ''
            echo 'usage: use (module|path)' >&2
            false
        case '/*'
            if test -d $module
                if contains $module $fish_function_path
                    true
                else
                    test -z $QUIET
                    and echo loading $module >&2
                    set fish_function_path $module $fish_function_path
                    true
                end
            else
                test -z $QUIET
                and echo $module is not a directory >&2
                return 21
            end
        case '.*'
            use (fish_realpath $module)
        case '*'
            test -z $FISH_USE_MODULES_PATH
            and set FISH_USE_MODULES_PATH ~/.config/fish/use.modules
            set module_path (string join / $FISH_USE_MODULES_PATH $module/functions)
            if test -d $module_path
                use (fish_realpath $module_path)
            else
                test -z $QUIET
                and echo cannot import from undefined module: $module >&2
                return 2
            end
    end
end
