function get-messsage {
    param (
       # Parameter help description
       [Parameter(Mandatory=$false)][string]$name 
           )
    return "Hello, $name!"
}

get-messsage 