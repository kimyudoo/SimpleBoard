package com.example.demo;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


@Repository
public interface MemberInfoRepository extends JpaRepository<MemberInfo, String>{
	Long countByIdAndPassword(String userid, String password);
}
