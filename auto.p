@auto[]

######################################### Config #########################################

$site[$env:SERVER_NAME]
$uri_site[//$site]
$uri_stat[//$site]
$uri_js[//$site/js]
$uri_css[//$site/css]
$uri_img[//$site/img]

$mysql_host[localhost]
$mysql_database[utest]
$mysql_user[utest]
$mysql_pass[f1nrXOiA6kGX1zQsAB5N]

$log_enable(true)
$log_file[$site]

$salt[gelfvmwelvkfvmlkewfvvemvsdfdfoiqnv45234t1091]

$session_timeout(1)
$cdb[mysql://$mysql_user^if(def $mysql_pass){:$mysql_pass}@$mysql_host/$mysql_database?charset=utf8]


######################################### global hook for errors #########################################
@unhandled_exception[exception;stack] 
^log_error[$exception.type, $exception.source, $exception.file, $exception.lineno, $exception.colno, $exception.comment]
$exception.handled(true)


#########################################  functions #########################################

##########################################################################################################################################################################
@dbq[code]
^connect[$cdb]{^table::sql{^taint[optimized-as-is][$code]}}

##########################################################################################################################################################################
@dbs[code]
^connect[$cdb]{^string:sql{^taint[optimized-as-is][$code]}}

##########################################################################################################################################################################
@dbi[code]
^connect[$cdb]{^int:sql{^taint[optimized-as-is][$code]}}

##########################################################################################################################################################################
@dbv[code]
^connect[$cdb]{^void:sql{$code}}

##########################################################################################################################################################################
@dbh[code]
^connect[$cdb]{^hash::sql{^taint[optimized-as-is][$code]}}

##########################################################################################################################################################################
@log_error[comment][v;now;prefix;message;line]
 ^if($log_enable){
   $now[^date::now[]]
   $prefix[[^now.sql-string[]] $env:REMOTE_ADDR: ]
   $message[$request:uri]
   $line[$prefix $message $comment ^#0A]
   ^line.save[append;/${log_file}_error.log]
   $result[]
 }

##########################################################################################################################################################################
@gen_session_key[s]
 $result[^math:sha1[$env:HTTP_REMOTE_ADDR $env:HTTP_USER_AGENT $s $salt]]

##########################################################################################################################################################################
@view_tab[mo]
 ^if(def $mo){
  $st[border="1"]
  $line(1)
  $cmo[^mo.columns[]]<table $st><tr><td>№</td>^cmo.menu{<td>$cmo.column</td>}</tr>^mo.menu{<tr><td>$line ^line.inc[]</td>^cmo.menu{<td>$mo.[$cmo.column]</td>}</tr>}</table>
 }{no data}
