<?php
 
    @$mysqli = new mysqli("localhost", "warron", "098543", "Random");
    $mysqli->query("SET NAMES UTF8");//解决UTF-8乱码问题，数据表中的字段编码类型为utf8_general_ci
    @$userID;
    @$userName;
    if($_SERVER['REQUEST_METHOD']=="GET"){
        if(isset($_GET["userID"])){//存在name
            $userID = $_GET["userID"];
            $userName = $_GET["userName"];
        }
    }else if($_SERVER['REQUEST_METHOD']=="POST"){
        if(isset($_POST["userID"])){//存在name
            $userID = $_POST["userID"];
            $userName = $_POST["userName"];
        }
    }else{
        @$a = array();
        $a["msg"]='请使用post或者get方式';
        $a["code"]="403";
        exit(json_encode($a,true));
    }
   
    if(empty($userID)){
        @$a = array();
        $a["msg"]='用户ID为空,不能修改';
        $a["code"]= "403";
        exit(json_encode($a,true));
    }
    if(empty($userName)){
        @$a = array();
        $a["msg"]='用户名为空,不能修改';
        $a["code"]= "403";
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
        @$sqlUpdate = "UPDATE users SET userName="."'$userName' WHERE userID="."'$userID'";
        @$updateResult = $mysqli->query($sqlUpdate);
        if($updateResult > 0){
            @$a = array();
            $a["msg"]='修改成功';
            $a["code"]= "200";
            $a["userID"]= $userID;
            $a["userName"]= $userName; 
            exit(json_encode($a,true));
        }
    }
	?>


