###HOW DO I SPLIT A URL AND ASSIGN THEM TO SEPARATE VARIABLES ?
#There's a number of ways to perform string splitting/parsing (i.e regex, getfield etc). However in this recipe we use the 'scan' command. The has the benefit of using less over head then regex whilst also allowing you to split the string only using the first instance of '/' which is not possible via 'getfield'.

    when HTTP_REQUEST {
        set url "www.bbc.com/sales/pictures/monkey.jpg"
        set uri ""
        scan $url {%[^/]%s} host uri
        log local0. "host = $host ; uri = $uri"
    }

#This produces the following log entry,

    Nov  4 20:26:10 local/tmm info tmm[4917]: Rule IRULE-NEWTEST <HTTP_REQUEST>: host = www.bbc.com ; uri = /sales/pictures/monkey.jpg

Further information on the 'scan' command can be found at https://devcentral.f5.com/articles/irules-101-16-parsing-strings-with-the-tcl-scan-command