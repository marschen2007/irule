when RULE_INIT {
    set static::debug 1
}
when CLIENTSSL_CLIENTCERT {
    # Example subject: 
    # C=US, O=f5test.local, OU=User Certificate, CN=user/emailAddress=user@f5test.local
    set subject_dn [X509::subject [SSL::cert 0]]
    if { $subject_dn != "" } {
        if { $static::debug }{ log "Client Certificate received: $subject_dn" }
    }
}
when HTTP_REQUEST {
    if { [HTTP::uri] starts_with "/companyA" } {
        if { $subject_dn contains "CN=John Smith" } {
            pool companyA
        } else {
            reject
        }
    } elseif { [HTTP::uri] starts_with "/companyB" } {
        if { $subject_dn contains "CN=Bob Smith" } {
            pool companyB
        } else {
            reject
        }
    }
}
