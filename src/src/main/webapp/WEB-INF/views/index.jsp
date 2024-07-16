<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<HTML>
	<body>
		<table>
			<tr>
				<td>ID</td>
				<td>작성자</td>
				<td>내용</td>
			</tr>
			<c:forEach items="${boardList}" var="item">
			<tr>
				<td>${item.id}</td>
				<td>${item.name}</td>
				<td>${item.contents}</td>
			</tr>
			</c:forEach>
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