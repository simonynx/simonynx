<?php
    // 关闭报错信息
    error_reporting(0);
	ini_set('date.timezone','Asia/Shanghai');
    
    // 约定登录密钥
    $secure_login_key = '123456';
	//服务器密钥
	$secure_login_server_key='fj1fj1@!$#!789364^458fj1_lfas';
    // flash实时参数
    // playerid改为login.php内传入
    $flash_args = array(
		'log_level' => "6",
        'error_page' => "",
        'charge_page' => "",
		'reg_page' => "",
        'res_host' => "http://ynx.qyfz.com/res/",
        'login_host' => "game.qyfz.com",
        'login_port' => "9227",
    );
?>