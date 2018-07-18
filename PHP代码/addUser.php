<?php
 
    @$mysqli = new mysqli("localhost", "warron", "098543", "Random");
    $mysqli->query("SET NAMES UTF8");//解决UTF-8乱码问题，数据表中的字段编码类型为utf8_general_ci
    @$userName;
    if($_SERVER['REQUEST_METHOD']=="GET"){

        if(isset($_GET["userName"])){//存在name
            $userName = $_GET["userName"];
        }
    }else if($_SERVER['REQUEST_METHOD']=="POST"){
        if(isset($_POST["userName"])){//存在name
            $userName = $_POST["userName"];
        }
    }else{
        @$a = array();
        $a["msg"]='请使用post或者get方式';
        $a["code"]="403";
        exit(json_encode($a,true));
    }
   
    if(empty($userName)){
        @$a = array();
        $a["msg"]='用户名为空,不能添加';
        $a["code"]= "403";
        exit(json_encode($a,true));
    }
    @$sql = "SELECT username from users where userName = ". " '$userName';";
    @$result = $mysqli->query($sql);
    @$rowcount = mysqli_num_rows($result);

    if($rowcount > 0){
        @$a = array();
        $a["msg"]='已有用户名';
        $a["code"]="403";
        exit(json_encode($a,true));
    }else{
        @$sqlInsert = "Insert INTO users (userName,hasSpeech) VALUES("."'$userName'".",'0');";
        @$inserResult = $mysqli->query($sqlInsert);
        if($inserResult > 0){
            
            @$sqlAddUser = "SELECT username,hasSpeech ,userID,isNextShare FROM users WHERE userID=(SELECT MAX(userID) FROM users)";//查询刚添加的用户
            @$sqlResult = $mysqli->query($sqlAddUser);
            
            @$a = array();
            $a["msg"]='添加成功';
            $a["code"]= "200";
            $a["data"] = array();
            while(@$row = mysqli_fetch_row($sqlResult)){
                @$item = array("userName"=>$row[0],"hasSpeech"=>$row[1],"userID"=>$row[2],"isNextShare"=>$row[3]);
                array_push($a["data"],$item);
            }
            exit(json_encode($a,true));
        }
    }
	?>


