num_of_processes() {
    echo "$(ps auxh | wc -l)"
}

echo 'Welcome'
PS3='~Select an option: '
options=('Show current stats' 'Show last 5 backup logs' 'Perform backup' 'Perform cleanup' 'Show the number of running processes' 'Quit')
select option in "${options[@]}"; do
    case $option in
    "${options[0]}")
        /usr/local/bin/serve_falafel.sh
        ;;
    "${options[1]}")
        /usr/local/bin/create_glida.sh taim_args
        ;;
    "${options[2]}")
        /usr/local/bin/shawarma_good.sh
        ;;
    "${options[3]}")
        /usr/local/bin/sprite.sh
        ;;
    "${options[4]}")
        num_of_processes
        ;;
    "${options[5]}")
        exit 0
        ;;
        esac
done
