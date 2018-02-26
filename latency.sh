# =============================
# iRule: logInsight_iRule_http START
# ==============================

when CLIENT_ACCEPTED {
    set client [IP::client_addr] 
    set client_req_start_time [clock clicks -milliseconds] 
}

when SERVER_CONNECTED
{
     set server_req_start_time [clock clicks -milliseconds]    
}

when HTTP_REQUEST_SEND
{
    set http_req_send_start_time [clock clicks -milliseconds]
    set node_elapsed_time [expr {$http_req_send_start_time - $server_req_start_time}]
    
}

when HTTP_REQUEST {
   
    set client_latency [expr {[clock clicks -milliseconds] -  $client_req_start_time} ]
    set vhost [HTTP::host]:[TCP::local_port]
    set url [HTTP::uri]
    set method [HTTP::method]
    set http_version [HTTP::version]
    set user_agent [HTTP::header "User-Agent"]
    set tcp_start_time [clock clicks -milliseconds]
    set req_start_time [clock format [clock seconds] -format "%Y/%m/%d %H:%M:%S"]
    set req_elapsed_time 0
    set virtual_server [LB::server]

    if { [HTTP::header Content-Length] > 0 } then {
        set req_length [HTTP::header "Content-Length"]
        if {$req_length > 4000000} then {
            set req_length 4000000
        }
        HTTP::collect $req_length
    } else {
        set req_length 0
    }

    if { [HTTP::header "Referer"] ne "" } then {
        set referer [HTTP::header "Referer"]
    } else {
        set referer -
    }
}


when HTTP_RESPONSE {

    set hsl [HSL::open -proto TCP -pool logInsight_pool_syslog]
    set resp_start_time [clock format [clock seconds] -format "%Y/%m/%d %H:%M:%S"]
    set node [IP::server_addr]:[TCP::server_port]
    set status [HTTP::status]
   set req_elapsed_time [expr {[clock clicks -milliseconds] - $tcp_start_time}]
    set server_latency [expr {[clock clicks -milliseconds] -  $server_req_start_time} ]
	
    if { [HTTP::header Content-Length] > 0 } then {
        set response_length [HTTP::header "Content-Length"]
    } else {
        set response_length 0
    }

   HSL::send $hsl "<190>f5_web_access_info|$vhost|$virtual_server|$client|$method|\"$url\"|HTTP/$http_version|$req_start_time|$req_length|$req_elapsed_time|$node|$status|$resp_start_time|$response_length|$user_agent|$client_latency|$server_latency|\"$referer\"\r\n"
}
