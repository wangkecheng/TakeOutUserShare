<?php
 
    @$mysqli = new mysqli("localhost", "warron", "098543", "Random");
    $mysqli->query("SET NAMES UTF8");//解决UTF-8乱码问题，数据表中的字段编码类型为utf8_general_ci
    
    if($_SERVER['REQUEST_METHOD']!="GET" && $_SERVER['REQUEST_METHOD']!="POST"){
        @$a = array();
        $a["msg"]='请使用post或者get方式';
        $a["code"]="403";
        exit(json_encode($a,true));
    }
    
    @$sql = "SELECT * from users;";
    @$result = $mysqli->query($sql);
    @$rowcount = mysqli_num_rows($result);
    if($rowcount > 0){
        @$resultArr = array();
        $resultArr["msg"] = '查询成功';
        $resultArr["code"] = "200";
        $resultArr["count"] = $rowcount;
        $resultArr["data"] = array();
        while(@$row = mysqli_fetch_row($result)){
            @$item = array("userName" => $row[0],"hasSpeech"=>$row[1],"userID"=>$row[2],"isNextShare"=>$row[3]);
            array_push($resultArr["data"],$item);
        }
        exit(json_encode($resultArr,true));
    }else{
        @$resultArr = array();
        $resultArr["msg"] = '暂时没有成员';
        $resultArr["code"] = "203";
        exit(json_encode($resultArr,true));
    }
	?>
//function characet($data){//编码转换方法
//    if( !empty($data) ){
//        $fileType = mb_detect_encoding($data , array('UTF-8','GBK','LATIN1','BIG5')) ;
//        if( $fileType != 'UTF-8'){
//            $data = mb_convert_encoding($data ,'utf-8' , $fileType);
//        }
//    }
//    return $data;
//}

