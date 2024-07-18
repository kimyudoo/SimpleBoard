<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<HTML>
	<head>
		<meta charset="utf8">
	</head>
	<body onload="loginCheck()">
		<script>	
			var loginok = '<%=(String)session.getAttribute("loginok")%>';
			var member_grade = "";
			function loginCheck() {
				if(loginok != "" && loginok != "null") {
					document.getElementById("loginbox").style.display = "none";
					document.getElementById("contentsdiv").style.display = "block";
					getList();
				} else {
					document.getElementById("loginbox").style.display = "block";
					document.getElementById("contentsdiv").style.display = "none";
				}
			}
			function goLogin() {
				var userid = document.getElementById("userid").value;
				var password = document.getElementById("userpassword").value;
				const payload = new FormData();
				payload.append("userid", userid);
				payload.append("password", password);
				fetch("http://127.0.0.1:8080/loginREST", {
					  method: "POST",
					  body: payload,
				})
				.then((response) => response.json())
				.then((data) => {
					if(data.result == "fail") {
						alert("로그인 실패");	
					} else {
						loginok = userid;
						member_grade = data.grade;
						document.getElementById("loginbox").style.display = "none";
						document.getElementById("contentsdiv").style.display = "block";
						getList();
					}						  
				});  
			}	
			function getList() {
				fetch("http://127.0.0.1:8080/listREST")
					.then((response) => response.json())
					.then((data) => {
					  document.getElementById("contentsTable").innerHTML = 
					  				"<tr> " +
					  					"<td width=50>ID</td> " +
					  					"<td width=100>작성자</td> " +
					  					"<td width=200>내용</td>" +
					  				"</tr>";
					  for(index = 0; index < data.length; index++) {
						var delText = "";
						if(data[index].password == loginok || member_grade == "admin") {
							delText = "<a href='javascript:goDel(" + data[index].id + ")'>[X]</a>";
					    }
						document.getElementById("contentsTable").innerHTML += 
							"		<tr><td>" + delText + " " + data[index].id + "</td>" +
							"			<td>" + data[index].name + "</td>" +
							"			<td>" + data[index].contents + "</td>" +
							"		</tr>";
						
						
					  }
					  document.getElementById("username").focus();
					});
			}
			function goLogout() {
				fetch("http://127.0.0.1:8080/logoutREST")
				.then((response) => {
					loginok = "";
					member_grade = "";
					document.getElementById("loginbox").style.display = "block";
					document.getElementById("contentsdiv").style.display = "none";		  
				}); 		
			}
			function goDel(id) {
				if(confirm("정말 삭제하시겠습니까?")){
					fetch("http://127.0.0.1:8080/delREST?id=" + id)
					.then((response) => response.json())
					.then((data) => {
						if(data.result == "fail") {
							alert("비밀번호가 틀렸습니다.");	
						} else {
							getList();
						}						  
					});    
				}				
			}
			function goAdd() {
				var contents = document.getElementById("contents").value;
				const payload = new FormData();
				payload.append("contents", contents);
				fetch("http://127.0.0.1:8080/addREST", {
					  method: "POST",
					  body: payload,
				})
				.then((response) => {
				  document.getElementById("contents").value = "";
				  getList();				  
				});
			}	
			function keyPress(event) {
				if(event.keyCode == 13) {
					goAdd();
				}
			}		
		</script>
		<div id="loginbox">
			<form name="loginForm" method="POST">
				<input type="text" id="userid"><br>
				<input type="password" id="userpassword">
				<input type="button" value="로그인" onclick="javascript:goLogin()">
			</form>
		</div>
		<div id="contentsdiv">
			<table>			
				<tr>
					<td colspan=3>
						<form id="myform" method="POST">
							<input type="text" id="contents" name="contents" placeholder="내용" onKeydown="javascript:keyPress(event)" >
							<input type="button" value="입력" onclick="javascript:goAdd()">
							<input type="button" value="로그아웃" onclick="javascript:goLogout()">
						</form>
					</td>
				</tr>				
			</table>
			<table id="contentsTable">
			</table>
		</div>
	</body>	
</HTML>