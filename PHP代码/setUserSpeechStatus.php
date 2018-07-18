<?php
 
    @$mysqli = new mysqli("localhost", "warron", "098543", "Random");
    $mysqli->query("SET NAMES UTF8");//解决UTF-8乱码问题，数据表中的字段编码类型为utf8_general_ci
    @$userID;
    @$hasSpeech;
    @$isNextShare;
    if($_SERVER['REQUEST_METHOD']=="GET"){
        if(isset($_GET["userID"])){//存在name
            $userID = $_GET["userID"];
            $hasSpeech = $_GET["hasSpeech"];
        }
        if(isset($_GET["hasSpeech"])){//存在hasSpeech
            $hasSpeech = $_GET["hasSpeech"];
        }
        if(isset($_GET["isNextShare"])){
            $isNextShare =  $_GET["isNextShare"];
        }
    }else if($_SERVER['REQUEST_METHOD']=="POST"){
        if(isset($_POST["userID"])){//存在name
            $userID = $_POST["userID"];
        } if(isset($_POST["hasSpeech"])){//存在hasSpeech
            $hasSpeech = $_POST["hasSpeech"];
        }
        if(isset($_POST["isNextShare"])){
            $isNextShare =  $_POST["isNextShare"];
        }
    }else{
        @$a = array();
        $a["msg"]='请使用post或者get方式';
        $a["code"]="401";
        exit(json_encode($a,true));
    }
   
    if(empty($userID)){
        @$a = array();
        $a["msg"]='用户ID为空,不能修改';
        $a["code"]= "402";
        exit(json_encode($a,true));
    }
    @$sql = "SELECT username from users where userID = ". " '$userID';";
    @$result = $mysqli->query($sql);
    @$rowcount = mysqli_num_rows($result);

    if($rowcount <= 0){
        @$a = array();
        $a["msg"]='没有该用户,不能修改';
        $a["code"]="403";
        exit(json_encode($a,true));
    }else{
        if ($hasSpeech>1){
            $hasSpeech = 1;//大于1的情况也算为1
        }
        @$sqlInsert = "UPDATE users SET hasSpeech="."'$hasSpeech' WHERE userID="."'$userID'";
        @$inserResult = $mysqli->query($sqlInsert);
        if($inserResult > 0){
            @$a = array();
            $a["msg"]='修改成功';
            $a["code"]= "200";
            $a["userID"]=$userID;
            $a["hasSpeech"]=$hasSpeech;
            
            //查询是否所有人都分享了
            @$sqlHasFinished = "Select * from users where userID = 0";
            @$sqlFinishResult = $mysqli->query($sqlInsert);
            if($sqlFinishResult == 0){//说明本轮分享已经完成
                @$sqlReset = "UPDATE users SET hasSpeech = 0";
                 $mysqli->query($sqlReset);
            }
            if(isset($isNextShare)){//如果设置了 是下周分享的参数 这里 就需要走
                @$sqlReset = "UPDATE users SET isNextShare = 0";
                $mysqli->query($sqlReset);
                $sqlReset = "UPDATE users SET isNextShare = 1 where userID = "."'$userID'";
                $mysqli->query($sqlReset);
                $a["isNextShare"] = "1";
            }
            exit(json_encode($a,true));
        }
    }
	?>


