<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<HTML>
	<head>
		<meta charset="utf8">
	</head>
	<body onload="loginCheck()">
		<script>	
			let TimerCheck;
			var loginok = '<%=(String)session.getAttribute("loginok")%>';
			var member_grade = '<%=(String)session.getAttribute("memberGrade")%>';
			function loginCheck() {				
				if(loginok != "" && loginok != "null") {
					document.getElementById("loginbox").style.display = "none";
					document.getElementById("contentsdiv").style.display = "block";								  
					getList();
				} else {
					document.getElementById("loginbox").style.display = "block";
					document.getElementById("contentsdiv").style.display = "none";
					document.getElementById("userid").focus();
				}
			}
			function goLogin() {
				var userid = document.getElementById("userid").value;
				var password = document.getElementById("userpassword").value;
				document.getElementById("userid").value = "";
				document.getElementById("userpassword").value = "";
				const payload = new FormData();
				payload.append("userid", userid);
				payload.append("password", password);
				
				fetch("http://192.168.22.10:8080/loginREST", {
					  method: "POST",
					  body: payload
				})
				.then((response) => response.json())
				.then((data) => {
					document.getElementById("userid").focus();	
					if(data.result == "fail") {
						alert("로그인 실패");	
					} else {
						loginok = userid;
						member_grade = data.grade;
						document.getElementById("loginbox").style.display = "none";
						document.getElementById("contentsdiv").style.display = "block";
						TimerCheck = setInterval(getList, 1000);
						getList();
					}						  
				});  
			}	
			function getList() {
				console.log("GetLIST Start");
				fetch("http://192.168.22.10:8080/listREST")
					.then((response) => response.json())
					.then((data) => {
					  document.getElementById("contentsTable").innerHTML = 
					  				"<tr> " +
					  					"<td width=100>ID</td> " +
					  					"<td width=100>작성자</td> " +
					  					"<td width=200>내용</td>" +
					  				"</tr>";
					  for(index = 0; index < data.length; index++) {
						var delText = "";
						var modText = "";
						if(data[index].password == loginok || member_grade == "admin") {
							delText = "<a href='javascript:goDel(" + data[index].id + ")'>[X]</a>";
							modText = "<a href='javascript:goMod(" + data[index].id + ", \"" + data[index].password + "\", \"" + data[index].name + "\")'>[V]</a>";
					    }
						document.getElementById("contentsTable").innerHTML += 
							"		<tr><td>" + delText + " " + modText + " " + data[index].id + "</td>" +
							"			<td>" + data[index].name + "</td>" +
							"			<td>" + data[index].contents + "</td>" +
							"		</tr>";
						
						
					  }
					  document.getElementById("contents").focus();
					});
			}
			function goLogout() {
				fetch("http://192.168.22.10:8080/logoutREST")
				.then((response) => {
					loginok = "";
					member_grade = "";
					document.getElementById("loginbox").style.display = "block";
					document.getElementById("contentsdiv").style.display = "none";	
					document.getElementById("userid").focus();	 
					clearInterval(TimerCheck);	 
				}); 		
			}
			function goDel(id) {
				if(confirm("정말 삭제하시겠습니까?")){
					fetch("http://192.168.22.10:8080/delREST?id=" + id)
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
			function goMod(id, modPass, modName) {
				var modifyText = prompt("수정 내용");
				fetch("http://192.168.22.10:8080/modREST?id=" + id + "&contents=" + modifyText
						+ "&password=" + modPass + "&name=" + modName)
				.then((response) => {
					getList();		  
				}); 							
			}
			function goAdd() {
				var contents = document.getElementById("contents").value;
				const payload = new FormData();
				payload.append("contents", contents);
				console.log(payload);
				fetch("http://192.168.22.10:8080/addREST", {
					  method: "POST",
					  body: payload,
				})
				.then((response) => {
				  document.getElementById("contents").value = "";
				  getList();				  
				});
			}	
			function keyPress(event, menunum) {
				if(event.keyCode == 13) {
					if(menunum == 1) {
						goAdd();	
					} else {
						goLogin();
					}					
				}
			}		
		</script>
		<div id="loginbox">
			<input type="text" id="userid" placeholder="아이디"><br>
			<input type="password" id="userpassword" placeholder="비밀번호"  onKeydown="javascript:keyPress(event, 2)">
			<input type="button" value="로그인" onclick="javascript:goLogin()">
		</div>
		<div id="contentsdiv">
			<table>			
				<tr>
					<td colspan=3>
						<input type="text" id="contents" name="contents" placeholder="내용" onKeydown="javascript:keyPress(event, 1)" >
						<input type="button" value="입력" onclick="javascript:goAdd()">
						<input type="button" value="로그아웃" onclick="javascript:goLogout()">
					</td>
				</tr>				
			</table>
			<table id="contentsTable">
			</table>
		</div>
	</body>	
</HTML>