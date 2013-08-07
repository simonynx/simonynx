<?php
include "./config.php";

// 接收参数
$arg=! empty($_POST) ? $_POST : $_GET;
//var_dump($arg);exit;

// $sign为验证字符串
$sign = $arg['sign'];
$sid = $arg['sid'];

unset( $arg['sign'],$arg['sid'] );
// timeout
if ( abs( time()-$arg['time'] ) > 900 ) {
    exit("time out");
}
// sign fail
if ( get_sign( $arg, $secure_login_key ) != $sign ) {
    exit("sign fail");
}
//hash_key
$hash_sign=strtoupper( sha1(pack("I2Ca*",$arg['user_id'],$arg['time'],$arg['guard_wallow'],$secure_login_server_key) ) );

$flash_args['user_id'] = $arg['user_id'];
$flash_args['time'] = $arg['time'];
$flash_args['cm'] = $arg['guard_wallow'];
$flash_args['plat'] = $arg['user_from'];
$flash_args['sid'] = $sid;
$flash_args['sign'] = $hash_sign;
$flash_args['charge_page'] =$flash_args['charge_page'].'/'.$sid.'/u/'.$user_id.'/';

$auth = base64_encode(json_encode( $flash_args ));
header("location:_index.html?auth=".$auth);
/*********************公用方法*****************************/

/**
 * get_sign( $data, $key )
 * 获取校验码
 * @param array $data 获取到的参数
 * @param string $key 密钥
 * @return string 校验字符串
 */
function get_sign( $data, $key )
{
    $param	= array_filter($data, 'empty_filter');
    ksort($param);
    $query	= http_build_query($param, '', '&').$key;
    return md5($query);
}

/**
 * empty_filter($value)
 * 校验时用的方法
 */
function empty_filter($value)
{
    return ($value !== '');
}
?>