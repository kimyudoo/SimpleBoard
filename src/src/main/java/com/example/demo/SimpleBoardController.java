package com.example.demo;

import java.time.LocalDate;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import com.google.gson.Gson; 

@Controller
public class SimpleBoardController {
	@Autowired
	private SimpleBoardDataRepository simpleBoardDAO;
	
	@Autowired
	private MemberInfoRepository memberDAO;
	
	@RequestMapping(value="/", method=RequestMethod.GET)
	public String index(HttpServletRequest request) {
		List<SimpleBoardData> result = simpleBoardDAO.findAll(Sort.by(Sort.Direction.DESC, "id"));
		request.setAttribute("boardList", result);
		return "index_rest";
	}
	@RequestMapping(value="/logoutREST", method=RequestMethod.GET)
	@ResponseBody
	public String logoutREST(HttpServletRequest request, HttpSession session) {
		session.setAttribute("loginok", "");
		session.setAttribute("loginname", "");
		return "{\"result\": \"success\"}";
	}
	@RequestMapping(value="/loginREST", method=RequestMethod.POST)
	@ResponseBody
	public String loginREST(HttpServletRequest request, HttpSession session) {
		String userId = request.getParameter("userid");
		String userPassword = request.getParameter("password");		
		Long findCount = memberDAO.countByIdAndPassword(userId, userPassword);		
		if(findCount <= 0) {
			return "{\"result\": \"fail\"}";
		} else {
			Optional<MemberInfo> mem = memberDAO.findById(userId);
			MemberInfo resultMem = mem.get();
			String userName = resultMem.getName();
			int userGrade = resultMem.getGrade();
			String grade;
			if(userGrade == 0) {
				grade = "member";
			} else {
				grade = "admin";			}
			session.setAttribute("loginok", userId);
			session.setAttribute("loginname", userName);
			session.setAttribute("memberGrade", grade);			
			return "{\"result\": \"success\", \"grade\": \"" + grade + "\" }";
		}
	}
	@RequestMapping(value="/add", method=RequestMethod.POST)
	public String add(HttpServletRequest request) {
		String name = request.getParameter("username");
		String contents = request.getParameter("contents");
		SimpleBoardData simpleBoard = SimpleBoardData.builder()
						.name(name)
						.contents(contents)
						.build();
		simpleBoardDAO.save(simpleBoard);
		List<SimpleBoardData> result = simpleBoardDAO.findAll(Sort.by(Sort.Direction.DESC, "id"));
		request.setAttribute("boardList", result);
		return "index";
	}
	

	@RequestMapping(value="/addREST", method=RequestMethod.POST)
	@ResponseBody
	public String addREST(HttpServletRequest request, HttpSession session) {
		String name = (String)session.getAttribute("loginname");
		String contents = request.getParameter("contents");
		String password = (String)session.getAttribute("loginok");
		SimpleBoardData simpleBoard = SimpleBoardData.builder()
						.name(name)
						.contents(contents)
						.password(password)
						.build();
		simpleBoardDAO.save(simpleBoard);
		return "OK";
	}
	@RequestMapping(value="/modREST", method=RequestMethod.GET)
	@ResponseBody
	public String modREST(HttpServletRequest request, HttpSession session) {
		String contents = request.getParameter("contents");
		String idStr = request.getParameter("id");
		String modPass = request.getParameter("password");
		String modName = request.getParameter("name");
		Long id = Long.parseLong(idStr);
		System.out.print("CONTENTS = > " + contents + ", ID => " + id);
		SimpleBoardData simpleBoard = SimpleBoardData.builder()
						.id(id)
						.name(modName)
						.password(modPass)
						.contents(contents)
						.build();
		simpleBoardDAO.save(simpleBoard);
		return "OK";
	}
	@RequestMapping(value="/listREST", method=RequestMethod.GET)
	@ResponseBody
	public String listREST(HttpServletRequest request) {
		List<SimpleBoardData> resultList = simpleBoardDAO.findAll(Sort.by(Sort.Direction.DESC, "id"));
		String json = new Gson().toJson(resultList);
		return json;
	}
	
	@RequestMapping(value="/delREST", method=RequestMethod.GET)
	@ResponseBody
	public String delREST(HttpServletRequest request, HttpSession session) {
		String id = request.getParameter("id");
		String password = (String)session.getAttribute("loginok");
		String memberGrade = (String)session.getAttribute("membergrade");
		Long contentsId = Long.parseLong(id);		
		Long findCount = simpleBoardDAO.countByIdAndPassword(contentsId, password);
		if(findCount > 0 || memberGrade.equals("admin")) {
			simpleBoardDAO.deleteById(contentsId);
			return "{\"result\": \"success\"}";
		} else {
			return "{\"result\": \"fail\"}";
		}
	}	
}
