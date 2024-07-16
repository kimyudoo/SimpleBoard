package com.example.demo;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class SimpleBoardController {
	@Autowired
	private SimpleBoardDataRepository simpleBoardDAO;
	
	@RequestMapping(value="/", method=RequestMethod.GET)
	public String index(HttpServletRequest request) {
		List<SimpleBoardData> result = simpleBoardDAO.findAll(Sort.by(Sort.Direction.DESC, "id"));
		request.setAttribute("boardList", result);
		return "index";
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
	
}
