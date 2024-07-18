package com.example.demo;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Builder;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.ToString;


@ToString
@Getter
@RequiredArgsConstructor
@Table(name = "tbl_memberinfo")
@Entity
@Builder
public class MemberInfo {
	@Id
	@Column(length = 100, nullable = false)	    
	private String id;   
	
	@Column(length = 300, nullable = false)    
	private String password;
				
	public MemberInfo(String id, String password) {
		this.id = id;
		this.password = password;
	}
}