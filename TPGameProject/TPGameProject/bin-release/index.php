<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <style>
        * { margin:0; padding:0; text-align:center; }
        #box { width:270px; margin:0 auto; border:1px solid #ccc; text-align:center; }
        .row { width:270px; margin-bottom:5px; text-align:left; }
        .row span { width:90px; display:inline-block; text-align:right;  }
        .center { text-align:center; }
        .center input { width:60px; }
    </style>
    <script type="text/javascript">
        window.onload = function(){
            document.getElementById('uri').value = location.protocol + '//' + location.host + '/login.php';
        };
    </script>
</head>
<body>
    <div id="box">
        <form method="post">
            <div class="row">
                <span>用户id：</span>
                <input type="text" name="user_id" maxlength="9" onkeyup="value=value.replace(/[^\d]/g,'') "  onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d]/g,''))" />
            </div>
            <div class="row">
                <span>防沉迷：</span>
                <label for="adult">成人：</label><input type="radio" name="guard_wallow" value="0" id="adult" checked="true"/>
                <label for="young">未成年：</label><input type="radio" name="guard_wallow" value="1" id="young" />
            </div>
			<div class="row" hidden="true">
                <span>用户渠道：</span>
                <input type="text" name="user_from" value="zhenwu"/>
            </div>
            <div class="row" hidden="true">
                <span>登录地址：</span>
                <input type="text" name="uri" id="uri" value="" />
            </div>
            <div class="row center">
                <input type="submit" value="提交" />
                <input type="reset" value="清空" />
            </div>
        </form>
    </div>
</body>
</html>
<?php
if ( !empty($_POST) ) {
    $arg = $_POST;
    $uri  = $arg['uri'];
    
    unset($arg['key'], $arg['uri']);
    
    $arg['time'] = time();
    
    $arg['sign'] = get_sign($arg, '123456');
    
    echo <<<EOT
        <form action="{$uri}" method="post" target="_blank">
            <input type="hidden" name="user_from" value="{$arg['user_from']}" />
            <input type="hidden" name="user_id" value="{$arg['user_id']}" />
            <input type="hidden" name="guard_wallow" value="{$arg['guard_wallow']}" />
            <input type="hidden" name="time" value="{$arg['time']}" />
			<input type="hidden" name="sid" value="0" />
            <input type="hidden" name="sign" value="{$arg['sign']}" />
            <input type="submit" value="登录游戏" />
        </form>
EOT;
}

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