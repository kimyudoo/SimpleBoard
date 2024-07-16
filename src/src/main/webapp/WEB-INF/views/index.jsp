<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<HTML>
	<body>
		<table>
			<tr>
				<td>ID</td>
				<td>작성자</td>
				<td>내용</td>
			</tr>
			<tr>
				<td>1</td>
				<td>홍길동</td>
				<td>하이하이하이~!</td>
			</tr>
			<tr>
				<td colspan=3>
					<form method="POST" action="/add">
						<input type="text" name="username" placeholder="이름">
						<input type="text" name="contents" placeholder="내용">
						<input type="submit" value="입력">
					</form>
				</td>
			</tr>
		</table>
	</body>	
</HTML>