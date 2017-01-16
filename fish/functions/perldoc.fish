function perldoc
    if type cpandoc > /dev/null 2>&1
        cpandoc $argv
    else
        command perldoc $argv
    end
end
