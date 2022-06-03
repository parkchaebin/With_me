<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link href="icon.png"rel="shortcut icon"type="image/x-icon"><!--아이콘-->
<%@page import ="java.sql.*"%>
<%@ page import="javax.sql.*" %>
<%@ page import="javax.naming.*" %>
<%  
    //mysql jdbc 드라이버 불러오기
    Class.forName("com.mysql.cj.jdbc.Driver");
    //db 연결역할
    Connection conn =null;
    //db 명령 전달 역할
    PreparedStatement pstmt =null;
    //select문 정보 저장 역할
    ResultSet rs =null;
    //입력받은 값 변수에 저장
    String uid = request.getParameter("id");
    String uphone = request.getParameter("phone");
    
    try {                    
        //jdbcDriver 주소 변수에 저장
        String jdbcDriver ="jdbc:mysql://118.67.129.235:3306/with_me?serverTimezone=UTC"; 
        //mysql 로그인 정보
        String dbUser ="taxi"; 
        String dbPass ="1234";
        
        //질의문 형태로 저장 
        String query ="select * from user where user_id=? and user_phone=?";
        
        //해당 주소로 로그인해서 db연결
        conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
        //sql 구문 전달해줄 Statement 생성
        pstmt = conn.prepareStatement(query);
        pstmt.setString(1,uid);
        pstmt.setString(2,uphone);
        //select문 실행하여 rs에 값 저장
        rs = pstmt.executeQuery();
        
        if(rs.next()){ //입력받은 정보와 db에 저장되어 있는 정보 비교
            String user_pw = rs.getString("user_pw");
            session.setAttribute("find_pw", "비밀번호는 '"+user_pw+"'입니다.");
            response.sendRedirect("find-pw.jsp");
        } else{ //db에 존재하지 않는 전화번호의 경우
            session.setAttribute("none", "존재하지 않는 회원 정보입니다.");
            response.sendRedirect("find-pw.jsp");
        }
   
    } catch(SQLException ex) { //예외처리
        out.println(ex.getMessage());
        ex.printStackTrace();
    } finally { //ResultSet,connection, statement 반환
        if (rs !=null) try { rs.close(); } catch(SQLException ex) {}
        if (pstmt !=null) try { pstmt.close(); } catch(SQLException ex) {}
        if (conn !=null) try { conn.close(); } catch(SQLException ex) {}
    }
%>